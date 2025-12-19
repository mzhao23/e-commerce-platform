"""
E-Commerce Recommendation System
Reads user behavior from JSON files, generates recommendations using ML models, 
and saves to MySQL database.
"""

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, roc_auc_score
from db_config import (DB_CONFIG, BEHAVIOR_DATA_DIR, SEARCH_DATA_DIR, 
                       RECOMMENDATION_EXPIRE_HOURS, RECOMMENDATIONS_PER_USER)
import pymysql
import json
import os
from datetime import datetime, timedelta
from collections import defaultdict
import warnings
warnings.filterwarnings('ignore')


# ============================================================================
# DATABASE HELPER FUNCTIONS
# ============================================================================

def get_db():
    config = DB_CONFIG.copy()
    config['cursorclass'] = pymysql.cursors.DictCursor
    return pymysql.connect(**config)


def query_db(query, args=(), one=False):
    """Execute a query and return results."""
    conn = get_db()
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, args or ())
            result = cursor.fetchone() if one else cursor.fetchall()
        return result
    finally:
        conn.close()


def execute_db(sql, args=None):
    """Execute an insert/update query."""
    conn = get_db()
    try:
        with conn.cursor() as cursor:
            cursor.execute(sql, args or ())
            conn.commit()
            return cursor.lastrowid
    finally:
        conn.close()


# ============================================================================
# DATA LOADER - FROM JSON AND DATABASE
# ============================================================================

class BehaviorDataLoader:
    """Load user behavior data from JSON files and database."""
    
    def __init__(self):
        self.behavior_data = []
        self.search_data = []
        self.users = []
        self.products = []
        self.orders = []
        self.ratings = []
        
    def load_json_files(self):
        """Load behavior and search data from JSON files."""
        print("\n[Loading JSON behavior data...]")
        
        # Load behavior data
        if os.path.exists(BEHAVIOR_DATA_DIR):
            for filename in os.listdir(BEHAVIOR_DATA_DIR):
                if filename.endswith('.json'):
                    filepath = os.path.join(BEHAVIOR_DATA_DIR, filename)
                    try:
                        with open(filepath, 'r', encoding='utf-8') as f:
                            data = json.load(f)
                            self.behavior_data.extend(data)
                            print(f"  Loaded {len(data)} sessions from {filename}")
                    except Exception as e:
                        print(f"  Error loading {filename}: {e}")
        else:
            print(f"  Directory not found: {BEHAVIOR_DATA_DIR}")
        
        # Load search data
        if os.path.exists(SEARCH_DATA_DIR):
            for filename in os.listdir(SEARCH_DATA_DIR):
                if filename.endswith('.json'):
                    filepath = os.path.join(SEARCH_DATA_DIR, filename)
                    try:
                        with open(filepath, 'r', encoding='utf-8') as f:
                            data = json.load(f)
                            self.search_data.extend(data)
                            print(f"  Loaded {len(data)} searches from {filename}")
                    except Exception as e:
                        print(f"  Error loading {filename}: {e}")
        else:
            print(f"  Directory not found: {SEARCH_DATA_DIR}")
        
        print(f"Total behavior sessions: {len(self.behavior_data)}")
        print(f"Total search records: {len(self.search_data)}")
        
    def load_database_data(self):
        """Load user, product, order data from database."""
        print("\n[Loading database data...]")
        
        # Load customers
        self.users = query_db("""
            SELECT CustomerId, CusFirstName, CusLastName, CusEmail,
                   TIMESTAMPDIFF(YEAR, CusDOB, CURDATE()) as Age
            FROM CustomerInfo
        """)
        print(f"  Loaded {len(self.users)} customers")
        
        # Load products
        self.products = query_db("""
            SELECT p.ProductId, p.ProductName, p.BrandId, p.CategoryId, p.Price,
                   b.BrandName, c.CategoryName
            FROM ProductInfo p
            LEFT JOIN BrandInfo b ON p.BrandId = b.BrandId
            LEFT JOIN ProductCategory c ON p.CategoryId = c.CategoryId
            WHERE p.PublishStatus = 1
        """)
        print(f"  Loaded {len(self.products)} products")
        
        # Load orders with details
        self.orders = query_db("""
            SELECT o.OrderId, o.CustomerId, o.TotalAmount, o.OrderStatus, o.CreatedAt,
                   d.ProductId, d.ProductCount, d.TotalPrice
            FROM OrderInfo o
            JOIN OrderDetail d ON o.OrderId = d.OrderId
            WHERE o.OrderStatus != 'cancelled'
        """)
        print(f"  Loaded {len(self.orders)} order details")
        
        # Load ratings
        self.ratings = query_db("""
            SELECT CustomerId, ProductId, RatingScore, Review
            FROM ProductRating
        """)
        print(f"  Loaded {len(self.ratings)} ratings")
        
    def build_user_profiles(self):
        """Build user profiles from all data sources."""
        print("\n[Building user profiles...]")
        
        user_profiles = {}
        
        # Initialize profiles from database users
        for user in self.users:
            uid = user['CustomerId']
            user_profiles[uid] = {
                'CustomerId': uid,
                'Age': user.get('Age') or 30,
                'order_count': 0,
                'total_spend': 0,
                'avg_order_value': 0,
                'purchased_products': set(),
                'purchased_brands': set(),
                'purchased_categories': set(),
                'viewed_products': set(),
                'carted_products': set(),
                'searched_queries': [],
                'avg_rating_given': 0,
                'rating_count': 0,
                'view_count': 0,
                'cart_count': 0,
                'purchase_count': 0
            }
        
        # Add order data
        for order in self.orders:
            uid = order['CustomerId']
            if uid in user_profiles:
                user_profiles[uid]['order_count'] += 1
                user_profiles[uid]['total_spend'] += float(order['TotalPrice'] or 0)
                user_profiles[uid]['purchased_products'].add(order['ProductId'])
                user_profiles[uid]['purchase_count'] += 1
        
        # Calculate avg order value
        for uid, profile in user_profiles.items():
            if profile['order_count'] > 0:
                profile['avg_order_value'] = profile['total_spend'] / profile['order_count']
        
        # Add brand/category from purchased products
        product_dict = {p['ProductId']: p for p in self.products}
        for uid, profile in user_profiles.items():
            for pid in profile['purchased_products']:
                if pid in product_dict:
                    profile['purchased_brands'].add(product_dict[pid]['BrandId'])
                    profile['purchased_categories'].add(product_dict[pid]['CategoryId'])
        
        # Add rating data
        for rating in self.ratings:
            uid = rating['CustomerId']
            if uid in user_profiles:
                user_profiles[uid]['rating_count'] += 1
                user_profiles[uid]['avg_rating_given'] += rating['RatingScore']
        
        for uid, profile in user_profiles.items():
            if profile['rating_count'] > 0:
                profile['avg_rating_given'] /= profile['rating_count']
        
        # Add behavior data from JSON
        for session in self.behavior_data:
            uid = session.get('CustomerId')
            if uid not in user_profiles:
                user_profiles[uid] = {
                    'CustomerId': uid,
                    'Age': 30,
                    'order_count': 0,
                    'total_spend': 0,
                    'avg_order_value': 0,
                    'purchased_products': set(),
                    'purchased_brands': set(),
                    'purchased_categories': set(),
                    'viewed_products': set(),
                    'carted_products': set(),
                    'searched_queries': [],
                    'avg_rating_given': 0,
                    'rating_count': 0,
                    'view_count': 0,
                    'cart_count': 0,
                    'purchase_count': 0
                }
            
            for event in session.get('Events', []):
                event_type = event.get('EventType')
                product_id = event.get('ProductId')
                
                if event_type == 'View' and product_id:
                    user_profiles[uid]['viewed_products'].add(product_id)
                    user_profiles[uid]['view_count'] += 1
                elif event_type == 'AddToCart' and product_id:
                    user_profiles[uid]['carted_products'].add(product_id)
                    user_profiles[uid]['cart_count'] += 1
                elif event_type == 'Purchase' and product_id:
                    user_profiles[uid]['purchased_products'].add(product_id)
                    user_profiles[uid]['purchase_count'] += 1
        
        # Add search data from JSON
        for search in self.search_data:
            uid = search.get('CustomerId')
            if uid in user_profiles:
                user_profiles[uid]['searched_queries'].append(search.get('SearchQuery', ''))
        
        print(f"Built profiles for {len(user_profiles)} users")
        return user_profiles
    
    def build_product_profiles(self):
        """Build product profiles."""
        print("\n[Building product profiles...]")
        
        product_profiles = {}
        
        for product in self.products:
            pid = product['ProductId']
            product_profiles[pid] = {
                'ProductId': pid,
                'ProductName': product['ProductName'],
                'BrandId': product['BrandId'],
                'CategoryId': product['CategoryId'],
                'Price': float(product['Price']),
                'view_count': 0,
                'cart_count': 0,
                'purchase_count': 0,
                'avg_rating': 0,
                'rating_count': 0
            }
        
        # Add rating data
        for rating in self.ratings:
            pid = rating['ProductId']
            if pid in product_profiles:
                product_profiles[pid]['rating_count'] += 1
                product_profiles[pid]['avg_rating'] += rating['RatingScore']
        
        for pid, profile in product_profiles.items():
            if profile['rating_count'] > 0:
                profile['avg_rating'] /= profile['rating_count']
        
        # Add behavior counts
        for session in self.behavior_data:
            for event in session.get('Events', []):
                pid = event.get('ProductId')
                if pid and pid in product_profiles:
                    event_type = event.get('EventType')
                    if event_type == 'View':
                        product_profiles[pid]['view_count'] += 1
                    elif event_type == 'AddToCart':
                        product_profiles[pid]['cart_count'] += 1
                    elif event_type == 'Purchase':
                        product_profiles[pid]['purchase_count'] += 1
        
        # Add order purchase counts
        for order in self.orders:
            pid = order['ProductId']
            if pid in product_profiles:
                product_profiles[pid]['purchase_count'] += order.get('ProductCount', 1)
        
        print(f"Built profiles for {len(product_profiles)} products")
        return product_profiles
    
    def build_training_data(self, user_profiles, product_profiles):
        """Build training data for ML models."""
        print("\n[Building training data for ML models...]")
        
        training_data = []
        
        for uid, user in user_profiles.items():
            for pid, product in product_profiles.items():
                # Create feature vector
                features = {
                    'CustomerId': uid,
                    'ProductId': pid,
                    # User features
                    'user_age': user.get('Age') or 30,
                    'user_order_count': user['order_count'],
                    'user_total_spend': user['total_spend'],
                    'user_avg_order_value': user['avg_order_value'],
                    'user_rating_count': user['rating_count'],
                    'user_avg_rating_given': user['avg_rating_given'],
                    'user_view_count': user['view_count'],
                    'user_cart_count': user['cart_count'],
                    'user_purchase_count': user['purchase_count'],
                    'user_unique_brands': len(user['purchased_brands']),
                    'user_unique_categories': len(user['purchased_categories']),
                    # Product features
                    'product_price': product['Price'],
                    'product_brand_id': product['BrandId'] or 0,
                    'product_category_id': product['CategoryId'] or 0,
                    'product_view_count': product['view_count'],
                    'product_cart_count': product['cart_count'],
                    'product_purchase_count': product['purchase_count'],
                    'product_avg_rating': product['avg_rating'],
                    'product_rating_count': product['rating_count'],
                    # Interaction features
                    'user_viewed_product': 1 if pid in user['viewed_products'] else 0,
                    'user_carted_product': 1 if pid in user['carted_products'] else 0,
                    'user_bought_brand': 1 if product['BrandId'] in user['purchased_brands'] else 0,
                    'user_bought_category': 1 if product['CategoryId'] in user['purchased_categories'] else 0,
                    # Price fit
                    'price_fit_ratio': product['Price'] / user['avg_order_value'] if user['avg_order_value'] > 0 else 1,
                    # Label: did user purchase this product?
                    'label': 1 if pid in user['purchased_products'] else 0
                }
                training_data.append(features)
        
        df = pd.DataFrame(training_data)
        print(f"Built training data: {len(df)} samples")
        print(f"Positive samples (purchases): {df['label'].sum()} ({df['label'].mean()*100:.2f}%)")
        
        return df


# ============================================================================
# ML PURCHASE PREDICTION MODEL
# ============================================================================

class PurchasePredictionModel:
    """Machine Learning model to predict purchase probability."""
    
    def __init__(self):
        self.models = {
            'RandomForest': RandomForestClassifier(
                n_estimators=100, 
                max_depth=10, 
                random_state=42, 
                n_jobs=-1
            ),
            'GradientBoosting': GradientBoostingClassifier(
                n_estimators=100, 
                max_depth=5,
                random_state=42
            ),
            'LogisticRegression': LogisticRegression(
                max_iter=1000, 
                random_state=42
            )
        }
        self.best_model = None
        self.best_model_name = None
        self.scaler = StandardScaler()
        self.feature_columns = None
        self.feature_importance = None
        self.results = {}
        
    def train(self, df):
        """Train all models and select the best one."""
        print("\n" + "=" * 60)
        print("Training ML Purchase Prediction Models")
        print("=" * 60)
        
        # Define feature columns (exclude IDs and label)
        self.feature_columns = [col for col in df.columns 
                                if col not in ['CustomerId', 'ProductId', 'label']]
        
        X = df[self.feature_columns]
        y = df['label']
        
        # Handle class imbalance - undersample if needed
        if y.mean() < 0.1:
            print(f"  Class imbalance detected ({y.mean()*100:.2f}% positive)")
            # Simple undersampling
            pos_samples = df[df['label'] == 1]
            neg_samples = df[df['label'] == 0].sample(n=min(len(pos_samples) * 5, len(df[df['label'] == 0])), random_state=42)
            balanced_df = pd.concat([pos_samples, neg_samples])
            X = balanced_df[self.feature_columns]
            y = balanced_df['label']
            print(f"  Balanced dataset: {len(balanced_df)} samples ({y.mean()*100:.2f}% positive)")
        
        # Split data
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42, stratify=y
        )
        
        print(f"\nTraining set: {len(X_train)} samples")
        print(f"Test set: {len(X_test)} samples")
        
        # Scale features
        X_train_scaled = self.scaler.fit_transform(X_train)
        X_test_scaled = self.scaler.transform(X_test)
        
        # Train and evaluate each model
        for name, model in self.models.items():
            print(f"\nTraining {name}...")
            model.fit(X_train_scaled, y_train)
            
            y_pred = model.predict(X_test_scaled)
            y_prob = model.predict_proba(X_test_scaled)[:, 1]
            
            accuracy = accuracy_score(y_test, y_pred)
            precision = precision_score(y_test, y_pred, zero_division=0)
            recall = recall_score(y_test, y_pred, zero_division=0)
            f1 = f1_score(y_test, y_pred, zero_division=0)
            
            try:
                auc = roc_auc_score(y_test, y_prob)
            except:
                auc = 0.5
            
            self.results[name] = {
                'accuracy': accuracy,
                'precision': precision,
                'recall': recall,
                'f1': f1,
                'auc': auc,
                'model': model
            }
            
            print(f"  Accuracy:  {accuracy:.4f}")
            print(f"  Precision: {precision:.4f}")
            print(f"  Recall:    {recall:.4f}")
            print(f"  F1 Score:  {f1:.4f}")
            print(f"  AUC-ROC:   {auc:.4f}")
        
        # Select best model based on AUC
        self.best_model_name = max(self.results, key=lambda x: self.results[x]['auc'])
        self.best_model = self.results[self.best_model_name]['model']
        
        print(f"\n*** Best Model: {self.best_model_name} (AUC: {self.results[self.best_model_name]['auc']:.4f}) ***")
        
        # Get feature importance
        if hasattr(self.best_model, 'feature_importances_'):
            self.feature_importance = pd.DataFrame({
                'feature': self.feature_columns,
                'importance': self.best_model.feature_importances_
            }).sort_values('importance', ascending=False)
            
            print("\nTop 10 Feature Importances:")
            for _, row in self.feature_importance.head(10).iterrows():
                print(f"  {row['feature']}: {row['importance']:.4f}")
        
        return self.results
    
    def predict_purchase_probability(self, user_profile, product_profile, user_profiles):
        """Predict purchase probability for a user-product pair."""
        # Build feature vector
        features = {
            'user_age': user_profile.get('Age') or 30,
            'user_order_count': user_profile['order_count'],
            'user_total_spend': user_profile['total_spend'],
            'user_avg_order_value': user_profile['avg_order_value'],
            'user_rating_count': user_profile['rating_count'],
            'user_avg_rating_given': user_profile['avg_rating_given'],
            'user_view_count': user_profile['view_count'],
            'user_cart_count': user_profile['cart_count'],
            'user_purchase_count': user_profile['purchase_count'],
            'user_unique_brands': len(user_profile['purchased_brands']),
            'user_unique_categories': len(user_profile['purchased_categories']),
            'product_price': product_profile['Price'],
            'product_brand_id': product_profile['BrandId'] or 0,
            'product_category_id': product_profile['CategoryId'] or 0,
            'product_view_count': product_profile['view_count'],
            'product_cart_count': product_profile['cart_count'],
            'product_purchase_count': product_profile['purchase_count'],
            'product_avg_rating': product_profile['avg_rating'],
            'product_rating_count': product_profile['rating_count'],
            'user_viewed_product': 1 if product_profile['ProductId'] in user_profile['viewed_products'] else 0,
            'user_carted_product': 1 if product_profile['ProductId'] in user_profile['carted_products'] else 0,
            'user_bought_brand': 1 if product_profile['BrandId'] in user_profile['purchased_brands'] else 0,
            'user_bought_category': 1 if product_profile['CategoryId'] in user_profile['purchased_categories'] else 0,
            'price_fit_ratio': product_profile['Price'] / user_profile['avg_order_value'] if user_profile['avg_order_value'] > 0 else 1,
        }
        
        # Create dataframe with correct column order
        X = pd.DataFrame([features])[self.feature_columns]
        X_scaled = self.scaler.transform(X)
        
        return self.best_model.predict_proba(X_scaled)[0][1]


# ============================================================================
# RECOMMENDATION ENGINE
# ============================================================================

class RecommendationEngine:
    """Generate recommendations using collaborative filtering, content-based, and ML methods."""
    
    def __init__(self):
        self.user_profiles = {}
        self.product_profiles = {}
        self.user_similarity = None
        self.product_similarity = None
        self.ml_model = None
        
    def fit(self, user_profiles, product_profiles, ml_model=None):
        """Build recommendation model."""
        print("\n[Training Recommendation Engine...]")
        
        self.user_profiles = user_profiles
        self.product_profiles = product_profiles
        self.ml_model = ml_model
        
        # Build user-item interaction matrix
        users = list(user_profiles.keys())
        products = list(product_profiles.keys())
        
        # Create interaction matrix (views + carts + purchases)
        interaction_matrix = np.zeros((len(users), len(products)))
        
        user_idx = {u: i for i, u in enumerate(users)}
        product_idx = {p: i for i, p in enumerate(products)}
        
        for uid, profile in user_profiles.items():
            if uid not in user_idx:
                continue
            ui = user_idx[uid]
            
            # Weight: view=1, cart=2, purchase=3
            for pid in profile['viewed_products']:
                if pid in product_idx:
                    interaction_matrix[ui, product_idx[pid]] += 1
            for pid in profile['carted_products']:
                if pid in product_idx:
                    interaction_matrix[ui, product_idx[pid]] += 2
            for pid in profile['purchased_products']:
                if pid in product_idx:
                    interaction_matrix[ui, product_idx[pid]] += 3
        
        # Compute user similarity
        print("  Computing user similarity...")
        if interaction_matrix.sum() > 0:
            self.user_similarity = pd.DataFrame(
                cosine_similarity(interaction_matrix),
                index=users,
                columns=users
            )
        
        # Compute product similarity based on features
        print("  Computing product similarity...")
        product_features = []
        for pid in products:
            p = product_profiles[pid]
            product_features.append([
                p['BrandId'] or 0,
                p['CategoryId'] or 0,
                p['Price'],
                p['avg_rating'],
                p['purchase_count']
            ])
        
        product_features = np.array(product_features)
        if len(product_features) > 0:
            scaler = StandardScaler()
            product_features_scaled = scaler.fit_transform(product_features)
            
            self.product_similarity = pd.DataFrame(
                cosine_similarity(product_features_scaled),
                index=products,
                columns=products
            )
        
        self.users = users
        self.products = products
        self.user_idx = user_idx
        self.product_idx = product_idx
        
        print("  Recommendation engine ready!")
        
    def get_collaborative_recommendations(self, user_id, n=10, n_similar_users=5):
        """Get recommendations based on similar users."""
        if self.user_similarity is None or user_id not in self.user_similarity.index:
            return []
        
        similar_users = self.user_similarity[user_id].sort_values(ascending=False)[1:n_similar_users+1]
        
        user_profile = self.user_profiles.get(user_id, {})
        interacted = (user_profile.get('purchased_products', set()) | 
                     user_profile.get('viewed_products', set()) |
                     user_profile.get('carted_products', set()))
        
        recommendations = defaultdict(float)
        
        for similar_user, similarity in similar_users.items():
            if similar_user in self.user_profiles:
                similar_profile = self.user_profiles[similar_user]
                for pid in similar_profile.get('purchased_products', set()):
                    if pid not in interacted and pid in self.product_profiles:
                        recommendations[pid] += similarity * 3
                for pid in similar_profile.get('carted_products', set()):
                    if pid not in interacted and pid in self.product_profiles:
                        recommendations[pid] += similarity * 2
        
        sorted_recs = sorted(recommendations.items(), key=lambda x: x[1], reverse=True)[:n]
        return sorted_recs
    
    def get_content_based_recommendations(self, user_id, n=10):
        """Get recommendations based on user's purchase/view history."""
        if self.product_similarity is None:
            return []
        
        user_profile = self.user_profiles.get(user_id, {})
        
        purchased = user_profile.get('purchased_products', set())
        viewed = user_profile.get('viewed_products', set())
        carted = user_profile.get('carted_products', set())
        
        interacted = purchased | viewed | carted
        
        if not interacted:
            return []
        
        recommendations = defaultdict(float)
        
        for pid in purchased:
            if pid in self.product_similarity.index:
                similar_products = self.product_similarity[pid].sort_values(ascending=False)[1:11]
                for similar_pid, similarity in similar_products.items():
                    if similar_pid not in interacted:
                        recommendations[similar_pid] += similarity * 3
        
        for pid in carted:
            if pid in self.product_similarity.index:
                similar_products = self.product_similarity[pid].sort_values(ascending=False)[1:6]
                for similar_pid, similarity in similar_products.items():
                    if similar_pid not in interacted:
                        recommendations[similar_pid] += similarity * 2
        
        for pid in viewed:
            if pid in self.product_similarity.index:
                similar_products = self.product_similarity[pid].sort_values(ascending=False)[1:4]
                for similar_pid, similarity in similar_products.items():
                    if similar_pid not in interacted:
                        recommendations[similar_pid] += similarity * 1
        
        sorted_recs = sorted(recommendations.items(), key=lambda x: x[1], reverse=True)[:n]
        return sorted_recs
    
    def get_ml_recommendations(self, user_id, n=10):
        """Get recommendations based on ML purchase prediction."""
        if self.ml_model is None or self.ml_model.best_model is None:
            return []
        
        user_profile = self.user_profiles.get(user_id)
        if not user_profile:
            return []
        
        interacted = (user_profile.get('purchased_products', set()) | 
                     user_profile.get('viewed_products', set()))
        
        predictions = []
        for pid, product in self.product_profiles.items():
            if pid not in interacted:
                try:
                    prob = self.ml_model.predict_purchase_probability(
                        user_profile, product, self.user_profiles
                    )
                    predictions.append((pid, prob))
                except:
                    continue
        
        predictions.sort(key=lambda x: x[1], reverse=True)
        return predictions[:n]
    
    def get_popular_recommendations(self, user_id, n=10):
        """Get popular products as fallback."""
        user_profile = self.user_profiles.get(user_id, {})
        interacted = (user_profile.get('purchased_products', set()) | 
                     user_profile.get('viewed_products', set()))
        
        popularity = []
        for pid, profile in self.product_profiles.items():
            if pid not in interacted:
                score = (profile['purchase_count'] * 3 + 
                        profile['cart_count'] * 2 + 
                        profile['view_count'] * 1 +
                        profile['avg_rating'] * 10)
                popularity.append((pid, score))
        
        popularity.sort(key=lambda x: x[1], reverse=True)
        return popularity[:n]
    
    def get_hybrid_recommendations(self, user_id, n=10):
        """Combine all recommendation methods."""
        recommendations = defaultdict(lambda: {'score': 0, 'methods': []})
        
        # Collaborative filtering (weight: 0.25)
        cf_recs = self.get_collaborative_recommendations(user_id, n * 2)
        if cf_recs:
            max_cf = max([s for _, s in cf_recs])
            for pid, score in cf_recs:
                normalized = score / max_cf if max_cf > 0 else 0
                recommendations[pid]['score'] += normalized * 0.25
                recommendations[pid]['methods'].append('collaborative_filtering')
        
        # Content-based (weight: 0.25)
        cb_recs = self.get_content_based_recommendations(user_id, n * 2)
        if cb_recs:
            max_cb = max([s for _, s in cb_recs])
            for pid, score in cb_recs:
                normalized = score / max_cb if max_cb > 0 else 0
                recommendations[pid]['score'] += normalized * 0.25
                recommendations[pid]['methods'].append('content_based')
        
        # ML-based (weight: 0.35)
        ml_recs = self.get_ml_recommendations(user_id, n * 2)
        if ml_recs:
            for pid, score in ml_recs:
                recommendations[pid]['score'] += score * 0.35
                recommendations[pid]['methods'].append('xgboost_model')
        
        # Popularity (weight: 0.15)
        pop_recs = self.get_popular_recommendations(user_id, n * 2)
        if pop_recs:
            max_pop = max([s for _, s in pop_recs])
            for pid, score in pop_recs:
                normalized = score / max_pop if max_pop > 0 else 0
                recommendations[pid]['score'] += normalized * 0.15
                if 'popularity' not in recommendations[pid]['methods']:
                    recommendations[pid]['methods'].append('popularity')
        
        # Sort by final score
        sorted_recs = sorted(recommendations.items(), 
                            key=lambda x: x[1]['score'], 
                            reverse=True)[:n]
        
        # Normalize scores to 0-1
        if sorted_recs:
            max_score = sorted_recs[0][1]['score']
            if max_score > 0:
                for pid, data in sorted_recs:
                    data['score'] = min(data['score'] / max_score, 0.9999)
        
        return sorted_recs


# ============================================================================
# DATABASE WRITER
# ============================================================================

class RecommendationWriter:
    """Write recommendations to ProductRecommendation table."""
    
    @staticmethod
    def clear_expired_recommendations():
        """Clear expired recommendations."""
        conn = get_db()
        try:
            with conn.cursor() as cursor:
                cursor.execute("DELETE FROM ProductRecommendation WHERE ExpiresAt < NOW()")
                deleted = cursor.rowcount
                conn.commit()
                print(f"  Cleared {deleted} expired recommendations")
        finally:
            conn.close()
    
    @staticmethod
    def save_recommendations(user_id, recommendations, expires_hours=RECOMMENDATION_EXPIRE_HOURS):
        """Save recommendations to database."""
        if not recommendations:
            return 0
        
        conn = get_db()
        expires_at = datetime.now() + timedelta(hours=expires_hours)
        
        try:
            with conn.cursor() as cursor:
                cursor.execute(
                    "DELETE FROM ProductRecommendation WHERE CustomerId = %s",
                    (user_id,)
                )
                
                inserted = 0
                for pid, data in recommendations:
                    score = data['score']
                    methods = data['methods']
                    
                    # Determine primary recommendation type
                    if 'xgboost_model' in methods:
                        rec_type = 'xgboost_model'
                    elif 'collaborative_filtering' in methods:
                        rec_type = 'collaborative_filtering'
                    elif 'content_based' in methods:
                        rec_type = 'content_based'
                    else:
                        rec_type = 'hybrid'
                    
                    reason = RecommendationWriter._generate_reason(rec_type, methods)
                    
                    cursor.execute("""
                        INSERT INTO ProductRecommendation 
                        (CustomerId, ProductId, RecommendationType, RecommendationScore, 
                         RecommendationReason, IsClicked, IsPurchased, CreatedAt, ExpiresAt)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, NOW(), %s)
                    """, (user_id, pid, rec_type, round(score, 4), reason, 0, 0, expires_at))
                    inserted += 1
                
                conn.commit()
                return inserted
        finally:
            conn.close()
    
    @staticmethod
    def _generate_reason(rec_type, methods):
        """Generate human-readable recommendation reason."""
        reasons = {
            'collaborative_filtering': [
                'Based on similar users purchases',
                'Users like you also bought',
                'Popular among similar shoppers'
            ],
            'content_based': [
                'Based on your browsing history',
                'Similar to products you liked',
                'Matches your interests'
            ],
            'xgboost_model': [
                'ML recommendation based on your behavior',
                'Predicted to match your preferences',
                'Personalized pick for you'
            ],
            'hybrid': [
                'Recommended for you',
                'Top pick for you',
                'You may also like'
            ],
            'popularity': [
                'Trending product',
                'Best seller',
                'Highly rated'
            ]
        }
        
        import random
        return random.choice(reasons.get(rec_type, ['Recommended for you']))


# ============================================================================
# MAIN EXECUTION
# ============================================================================

def main():
    """Main execution function."""
    print("=" * 70)
    print("   E-COMMERCE RECOMMENDATION SYSTEM")
    print("   With ML Purchase Prediction Models")
    print("=" * 70)
    
    # Step 1: Load data
    print("\n[STEP 1] Loading Data...")
    loader = BehaviorDataLoader()
    loader.load_json_files()
    loader.load_database_data()
    
    # Step 2: Build profiles
    print("\n[STEP 2] Building User & Product Profiles...")
    user_profiles = loader.build_user_profiles()
    product_profiles = loader.build_product_profiles()
    
    # Step 3: Build training data and train ML models
    print("\n[STEP 3] Training ML Models...")
    training_df = loader.build_training_data(user_profiles, product_profiles)
    
    ml_model = PurchasePredictionModel()
    ml_results = ml_model.train(training_df)
    
    # Step 4: Train recommendation engine
    print("\n[STEP 4] Training Recommendation Engine...")
    engine = RecommendationEngine()
    engine.fit(user_profiles, product_profiles, ml_model)
    
    # Step 5: Generate recommendations for all users
    print("\n[STEP 5] Generating Recommendations...")
    
    RecommendationWriter.clear_expired_recommendations()
    
    total_saved = 0
    users_processed = 0
    
    for user_id in user_profiles.keys():
        recommendations = engine.get_hybrid_recommendations(user_id, n=RECOMMENDATIONS_PER_USER)
        
        if recommendations:
            saved = RecommendationWriter.save_recommendations(user_id, recommendations)
            total_saved += saved
            users_processed += 1
            
            if users_processed <= 3:
                print(f"\n  User {user_id} recommendations:")
                for pid, data in recommendations[:5]:
                    product = product_profiles.get(pid, {})
                    methods_str = ', '.join(data['methods'][:2])
                    print(f"    - Product {pid}: {product.get('ProductName', 'Unknown')[:30]}... "
                          f"(Score: {data['score']:.4f}, Methods: {methods_str})")
    
    # Step 6: Summary
    print("\n" + "=" * 70)
    print("   RECOMMENDATION GENERATION COMPLETE!")
    print("=" * 70)
    
    print("\n  ML Model Performance:")
    for name, result in ml_results.items():
        print(f"    {name}: AUC={result['auc']:.4f}, F1={result['f1']:.4f}")
    print(f"    Best Model: {ml_model.best_model_name}")
    
    print(f"\n  Users processed: {users_processed}")
    print(f"  Total recommendations saved: {total_saved}")
    print(f"  Recommendations per user: ~{total_saved // max(users_processed, 1)}")
    
    count = query_db("SELECT COUNT(*) as cnt FROM ProductRecommendation WHERE ExpiresAt > NOW()", one=True)
    print(f"\n  Active recommendations in database: {count['cnt']}")
    
    print("\n  Done! Recommendations are now available in the webapp.")
    
    return engine, ml_model, user_profiles, product_profiles


if __name__ == "__main__":
    engine, ml_model, users, products = main()
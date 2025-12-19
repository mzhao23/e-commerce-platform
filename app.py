"""
E-Commerce Web Application (Mock Data - No Database)
For UI Testing Only
"""

from flask import Flask, render_template, request, redirect, url_for, flash, session
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
from functools import wraps
import json
import os
import uuid
from db_config import DB_CONFIG, BEHAVIOR_DATA_DIR, SEARCH_DATA_DIR
import pymysql
pymysql.cursors.DictCursor

# Initialize Flask
app = Flask(__name__)
app.secret_key = 'dev-secret-key-12345'

# ============================================================================
# conn database
# ============================================================================
def get_db():
    config = DB_CONFIG.copy()
    config['cursorclass'] = pymysql.cursors.DictCursor
    return pymysql.connect(**config)

def query_db(query, args=(), one=False):
    conn = get_db()
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, args or ())
            result = cursor.fetchone() if one else cursor.fetchall()
        return result
    finally:
        conn.close()

def execute_db(sql, args=None):
    conn = get_db()
    try:
        with conn.cursor() as cursor:
            cursor.execute(sql, args or ())
            conn.commit()
            return cursor.lastrowid
    finally:
        conn.close()


# ============================================================================
# USER BEHAVIOR TRACKING MODULE
# ============================================================================
class BehaviorTracker:
    """
    User Behavior Tracker
    - Records user actions: View, AddToCart, RemoveFromCart, Purchase, Search
    - Saves data to JSON files in real-time
    - Stores metadata in UnstructuredDataRef table
    """

    def __init__(self):
        self.sessions = {}  # {session_id: {customer_id, events, start_time}}

    def _get_current_period(self) -> str:
        """Get current time period (YYYY-MM)"""
        return datetime.now().strftime('%Y-%m')

    def _get_behavior_filepath(self) -> str:
        """Get behavior data file path for current month"""
        period = self._get_current_period()
        return os.path.join(BEHAVIOR_DATA_DIR, f'behavior_{period.replace("-", "_")}.json')

    def _get_search_filepath(self) -> str:
        """Get search data file path for current month"""
        period = self._get_current_period()
        return os.path.join(SEARCH_DATA_DIR, f'searches_{period.replace("-", "_")}.json')

    def _load_json_file(self, filepath: str) -> list:
        """Load JSON file"""
        if os.path.exists(filepath):
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except:
                return []
        return []

    def _save_json_file(self, filepath: str, data: list):
        """Save JSON file"""
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

    def _update_unstructured_data_ref(self, ref_type: str, filepath: str):
        """Update UnstructuredDataRef table"""
        period = self._get_current_period()

        # Get file info
        file_size = os.path.getsize(filepath) if os.path.exists(filepath) else 0
        data = self._load_json_file(filepath)
        record_count = len(data)

        # Check if record exists
        existing = query_db(
            "SELECT DataRefId FROM UnstructuredDataRef WHERE RefType = %s AND DataPeriod = %s",
            (ref_type, period),
            one=True
        )

        if existing:
            # Update existing record
            execute_db(
                "UPDATE UnstructuredDataRef SET RecordCount = %s, FileSize = %s WHERE DataRefId = %s",
                (record_count, file_size, existing['DataRefId'])
            )
        else:
            # Insert new record
            execute_db(
                """INSERT INTO UnstructuredDataRef 
                   (RefType, RefId, FilePath, DataPeriod, RecordCount, FileSize) 
                   VALUES (%s, %s, %s, %s, %s, %s)""",
                (ref_type, 0, filepath, period, record_count, file_size)
            )

    def get_or_create_session(self, customer_id: int) -> str:
        """Get or create user session"""
        # Check for active session
        session_key = f"behavior_session_{customer_id}"

        if session_key in session:
            session_id = session[session_key]
            if session_id in self.sessions:
                return session_id

        # Create new session
        now = datetime.now()
        session_id = f"sess_{now.strftime('%Y%m%d')}_{uuid.uuid4().hex[:8]}"

        self.sessions[session_id] = {
            'customer_id': customer_id,
            'start_time': now,
            'events': []
        }

        session[session_key] = session_id
        return session_id

    def track_event(self, customer_id: int, event_type: str, product_id: int = None,
                    duration: int = None, extra_data: dict = None):
        """
        Record user behavior event

        Args:
            customer_id: Customer ID
            event_type: Event type (View, AddToCart, RemoveFromCart, Purchase, Search)
            product_id: Product ID
            duration: View duration in seconds (only for View events)
            extra_data: Additional data
        """
        session_id = self.get_or_create_session(customer_id)
        now = datetime.now()

        event = {
            'EventType': event_type,
            'Timestamp': now.strftime('%Y-%m-%dT%H:%M:%SZ')
        }

        if product_id:
            event['ProductId'] = product_id

        if duration and event_type == 'View':
            event['Duration'] = duration

        if extra_data:
            event.update(extra_data)

        self.sessions[session_id]['events'].append(event)

        # Save to file
        self._save_session_to_file(session_id)

    def track_search(self, customer_id: int, query: str,
                     clicked_products: list = None, purchased_product: int = None,
                     result_count: int = 0):
        """
        Record search behavior

        Args:
            customer_id: Customer ID
            query: Search query
            clicked_products: List of clicked product IDs
            purchased_product: Purchased product ID
            result_count: Number of search results
        """
        now = datetime.now()

        search_record = {
            'SearchId': f"search_{now.strftime('%Y%m%d')}_{uuid.uuid4().hex[:8]}",
            'CustomerId': customer_id,
            'SearchQuery': query,
            'Timestamp': now.strftime('%Y-%m-%dT%H:%M:%SZ'),
            'ClickedProducts': clicked_products or [],
            'PurchasedProduct': purchased_product,
            'SearchResultCount': result_count
        }

        # Load existing data
        filepath = self._get_search_filepath()
        data = self._load_json_file(filepath)

        # Add new record
        data.append(search_record)

        # Save file
        self._save_json_file(filepath, data)

        # Update database reference
        self._update_unstructured_data_ref('search_logs', filepath)

    def _save_session_to_file(self, session_id: str):
        """Save session to file"""
        if session_id not in self.sessions:
            return

        session_data = self.sessions[session_id]
        filepath = self._get_behavior_filepath()

        # Load existing data
        data = self._load_json_file(filepath)

        # Create session record
        session_record = {
            'SessionId': session_id,
            'CustomerId': session_data['customer_id'],
            'Timestamp': session_data['start_time'].strftime('%Y-%m-%dT%H:%M:%SZ'),
            'Events': session_data['events']
        }

        # Update or add session
        found = False
        for i, record in enumerate(data):
            if record.get('SessionId') == session_id:
                data[i] = session_record
                found = True
                break

        if not found:
            data.append(session_record)

        # Save file
        self._save_json_file(filepath, data)

        # Update database reference
        self._update_unstructured_data_ref('user_behavior', filepath)

    def end_session(self, customer_id: int):
        """End user session"""
        session_key = f"behavior_session_{customer_id}"
        if session_key in session:
            session_id = session.pop(session_key)
            if session_id in self.sessions:
                self._save_session_to_file(session_id)
                del self.sessions[session_id]


# Global behavior tracker instance
behavior_tracker = BehaviorTracker()


# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

def login_required(f):
    """Login required decorator"""

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please login first', 'warning')
            return redirect(url_for('login'))
        return f(*args, **kwargs)

    return decorated_function


def get_current_user():
    """Get current logged-in user"""
    if 'user_id' in session:
        user = query_db(
            "SELECT CustomerId as id, CusFirstName as first_name, CusLastName as last_name, CusEmail as email "
            "FROM CustomerInfo WHERE CustomerId = %s",
            (session['user_id'],),
            one=True
        )
        return user
    return None


def get_recommendations(user_id, n=4):
    """Get product recommendations"""
    recommendations = query_db(
        """
        SELECT p.ProductId as id, p.ProductName as name, p.Price as price, 
               p.ProductDesc as `desc`, p.CategoryId as category,
               c.CategoryImage as image,
               r.RecommendationScore as score
        FROM ProductRecommendation r
        JOIN ProductInfo p ON r.ProductId = p.ProductId
        LEFT JOIN ProductCategory c ON p.CategoryId = c.CategoryId
        WHERE r.CustomerId = %s AND r.ExpiresAt > NOW()
        ORDER BY r.RecommendationScore DESC
        LIMIT %s
        """,
        (user_id, n)
    )

    if not recommendations:
        recommendations = query_db(
            "SELECT ProductId as id, ProductName as name, Price as price, "
            "ProductDesc as `desc`, CategoryId as category "
            "FROM ProductInfo WHERE PublishStatus = 1 ORDER BY RAND() LIMIT %s",
            (n,)
        )

    return recommendations


# ============================================================================
# TEMPLATE CONTEXT
# ============================================================================

@app.context_processor
def inject_user():
    return {'current_user': get_current_user()}


# ============================================================================
# ROUTES - HOME
# ============================================================================

@app.route('/')
def index():
    featured = query_db(
        """SELECT p.ProductId as id, p.ProductName as name, p.Price as price, 
                  p.ProductDesc as `desc`, p.CategoryId as category,
                  c.CategoryImage as image
           FROM ProductInfo p
           LEFT JOIN ProductCategory c ON p.CategoryId = c.CategoryId
           WHERE p.PublishStatus = 1 LIMIT 8"""
    )

    recommendations = []
    if 'user_id' in session:
        recommendations = get_recommendations(session['user_id'], n=4)

    return render_template('index.html', products=featured, recommendations=recommendations)


# ============================================================================
# ROUTES - USER AUTHENTICATION
# ============================================================================

@app.route('/login', methods=['GET', 'POST'])
def login():
    if 'user_id' in session:
        return redirect(url_for('index'))

    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        user = query_db(
            "SELECT CustomerId, CusEmail, PasswordHash FROM CustomerInfo WHERE CusEmail = %s",
            (email,),
            one=True
        )

        if not user:
            flash(f'Account not found: {email}', 'error')
            return render_template('login.html')

        if not check_password_hash(user['PasswordHash'], password):
            flash('Incorrect password', 'error')
            return render_template('login.html')

        session['user_id'] = user['CustomerId']
        flash('Login successful!', 'success')
        return redirect(url_for('index'))

    return render_template('login.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    if 'user_id' in session:
        return redirect(url_for('index'))

    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')

        existing = query_db(
            "SELECT CustomerId FROM CustomerInfo WHERE CusEmail = %s",
            (email,),
            one=True
        )

        if existing:
            flash('Email already registered', 'error')
            return render_template('register.html')

        password_hash = generate_password_hash(password)
        execute_db(
            "INSERT INTO CustomerInfo (CusFirstName, CusLastName, CusEmail, PasswordHash) "
            "VALUES (%s, %s, %s, %s)",
            (first_name, last_name, email, password_hash)
        )

        flash('Registration successful! Please login.', 'success')
        return redirect(url_for('login'))

    return render_template('register.html')


@app.route('/logout')
def logout():
    if 'user_id' in session:
        # End behavior tracking session
        behavior_tracker.end_session(session['user_id'])

    session.pop('user_id', None)
    flash('Logged out.', 'info')
    return redirect(url_for('index'))


# ============================================================================
# ROUTES - PRODUCTS (with behavior tracking)
# ============================================================================

@app.route('/products')
def products():
    page = request.args.get('page', 1, type=int)
    per_page = 8
    offset = (page - 1) * per_page

    items = query_db(
        """SELECT p.ProductId as id, p.ProductName as name, p.Price as price, 
                  p.ProductDesc as `desc`, p.CategoryId as category,
                  c.CategoryImage as image
           FROM ProductInfo p
           LEFT JOIN ProductCategory c ON p.CategoryId = c.CategoryId
           WHERE p.PublishStatus = 1 
           LIMIT %s OFFSET %s""",
        (per_page, offset)
    )

    total_result = query_db("SELECT COUNT(*) as cnt FROM ProductInfo WHERE PublishStatus = 1", one=True)
    total = total_result['cnt'] if total_result else 0
    total_pages = (total + per_page - 1) // per_page

    class Pagination:
        def __init__(self):
            self.items = items
            self.page = page
            self.pages = total_pages
            self.has_prev = page > 1
            self.has_next = page < total_pages
            self.prev_num = page - 1
            self.next_num = page + 1

    return render_template('products.html', products=Pagination())


@app.route('/product/<int:product_id>')
def product_detail(product_id):
    product = query_db(
        """SELECT p.ProductId as id, p.ProductName as name, p.Price as price, 
                  p.ProductDesc as `desc`, p.CategoryId as category,
                  c.CategoryImage as image
           FROM ProductInfo p
           LEFT JOIN ProductCategory c ON p.CategoryId = c.CategoryId
           WHERE p.ProductId = %s""",
        (product_id,),
        one=True
    )

    if not product:
        flash('Product not found', 'error')
        return redirect(url_for('products'))

    # Track View behavior
    if 'user_id' in session:
        behavior_tracker.track_event(
            customer_id=session['user_id'],
            event_type='View',
            product_id=product_id,
            duration=30  # Default duration, can be updated via JS
        )

    related = query_db(
        "SELECT ProductId as id, ProductName as name, Price as price, "
        "ProductDesc as `desc`, CategoryId as category "
        "FROM ProductInfo "
        "WHERE CategoryId = %s AND ProductId != %s AND PublishStatus = 1 "
        "LIMIT 4",
        (product['category'], product_id)
    )

    return render_template('product_detail.html', product=product, related=related)


# ============================================================================
# ROUTES - SEARCH (with behavior tracking)
# ============================================================================

@app.route('/search')
def search():
    query = request.args.get('q', '').strip()

    if not query:
        return redirect(url_for('products'))

    # Search products
    results = query_db(
        """SELECT p.ProductId as id, p.ProductName as name, p.Price as price, 
                  p.ProductDesc as `desc`, p.CategoryId as category,
                  c.CategoryImage as image
           FROM ProductInfo p
           LEFT JOIN ProductCategory c ON p.CategoryId = c.CategoryId
           WHERE p.PublishStatus = 1 AND (p.ProductName LIKE %s OR p.ProductDesc LIKE %s)
           LIMIT 20""",
        (f'%{query}%', f'%{query}%')
    )

    # Track search behavior
    if 'user_id' in session:
        behavior_tracker.track_search(
            customer_id=session['user_id'],
            query=query,
            clicked_products=[],  # Clicks will be recorded later
            result_count=len(results)
        )

    return render_template('search_results.html', query=query, products=results)


# ============================================================================
# ROUTES - SHOPPING CART (with behavior tracking)
# ============================================================================

@app.route('/cart')
@login_required
def cart():
    user_id = session['user_id']

    cart_items = query_db(
        """
        SELECT c.CartId, c.ProductId, c.ProductNum as quantity, c.Price,
               p.ProductName as name, p.ProductDesc as `desc`,
               cat.CategoryImage as image
        FROM ShopCart c
        JOIN ProductInfo p ON c.ProductId = p.ProductId
        LEFT JOIN ProductCategory cat ON p.CategoryId = cat.CategoryId
        WHERE c.CustomerId = %s
        """,
        (user_id,)
    )

    items_with_products = []
    total = 0
    for item in cart_items:
        subtotal = float(item['Price']) * item['quantity']
        items_with_products.append({
            'item': {
                'id': item['CartId'],
                'product_id': item['ProductId'],
                'quantity': item['quantity'],
                'price': float(item['Price'])
            },
            'product': {
                'id': item['ProductId'],
                'name': item['name'],
                'desc': item['desc'],
                'image': item['image']
            },
            'subtotal': subtotal
        })
        total += subtotal

    return render_template('cart.html', cart_items=items_with_products, total=total)


@app.route('/cart/add/<int:product_id>', methods=['POST'])
@login_required
def add_to_cart(product_id):
    user_id = session['user_id']

    product = query_db(
        "SELECT ProductId, ProductName, Price FROM ProductInfo WHERE ProductId = %s",
        (product_id,),
        one=True
    )

    if not product:
        flash('Product not found', 'error')
        return redirect(url_for('products'))

    # Track AddToCart behavior
    behavior_tracker.track_event(
        customer_id=user_id,
        event_type='AddToCart',
        product_id=product_id
    )

    existing = query_db(
        "SELECT CartId, ProductNum FROM ShopCart WHERE CustomerId = %s AND ProductId = %s",
        (user_id, product_id),
        one=True
    )

    if existing:
        execute_db(
            "UPDATE ShopCart SET ProductNum = ProductNum + 1 WHERE CartId = %s",
            (existing['CartId'],)
        )
        flash('Cart updated!', 'success')
    else:
        execute_db(
            "INSERT INTO ShopCart (CustomerId, ProductId, ProductNum, Price) VALUES (%s, %s, %s, %s)",
            (user_id, product_id, 1, product['Price'])
        )
        flash(f'Added {product["ProductName"]} to cart!', 'success')

    return redirect(request.referrer or url_for('index'))


@app.route('/cart/remove/<int:item_index>', methods=['POST'])
@login_required
def remove_from_cart(item_index):
    user_id = session['user_id']

    cart_items = query_db(
        "SELECT CartId, ProductId FROM ShopCart WHERE CustomerId = %s ORDER BY CartId",
        (user_id,)
    )

    if 0 <= item_index < len(cart_items):
        cart_id = cart_items[item_index]['CartId']
        product_id = cart_items[item_index]['ProductId']

        # Track RemoveFromCart behavior
        behavior_tracker.track_event(
            customer_id=user_id,
            event_type='RemoveFromCart',
            product_id=product_id
        )

        execute_db("DELETE FROM ShopCart WHERE CartId = %s", (cart_id,))
        flash('Item removed', 'info')

    return redirect(url_for('cart'))


# ============================================================================
# ROUTES - ORDERS (with behavior tracking)
# ============================================================================

@app.route('/checkout', methods=['POST'])
@login_required
def checkout():
    user_id = session['user_id']

    cart_items = query_db(
        """
        SELECT c.CartId, c.ProductId, c.ProductNum, c.Price, p.ProductName
        FROM ShopCart c
        JOIN ProductInfo p ON c.ProductId = p.ProductId
        WHERE c.CustomerId = %s
        """,
        (user_id,)
    )

    if not cart_items:
        flash('Cart is empty', 'error')
        return redirect(url_for('cart'))

    total = sum(float(item['Price']) * item['ProductNum'] for item in cart_items)

    conn = get_db()
    try:
        with conn.cursor() as cursor:
            # Create payment record
            cursor.execute(
                "INSERT INTO PaymentInfo (CustomerId, PaymentMethod, PaymentAmount, PaymentStatus) "
                "VALUES (%s, %s, %s, %s)",
                (user_id, 'credit_card', total, 'completed')
            )
            payment_id = cursor.lastrowid

            # Get or create address
            cursor.execute(
                "SELECT AddressId FROM CustomerAddress WHERE CustomerId = %s AND IsDefault = TRUE LIMIT 1",
                (user_id,)
            )
            address = cursor.fetchone()

            if not address:
                cursor.execute(
                    "INSERT INTO CustomerAddress (CustomerId, Street, City, State, Zipcode, IsDefault) "
                    "VALUES (%s, %s, %s, %s, %s, TRUE)",
                    (user_id, '123 Main St', 'New York', 'NY', '10001')
                )
                address_id = cursor.lastrowid
            else:
                address_id = address['AddressId']

            # Create order
            cursor.execute(
                "INSERT INTO OrderInfo (CustomerId, AddressId, TotalAmount, PaymentId, OrderStatus) "
                "VALUES (%s, %s, %s, %s, %s)",
                (user_id, address_id, total, payment_id, 'pending')
            )
            order_id = cursor.lastrowid

            # Create order details + track purchase behavior
            for item in cart_items:
                cursor.execute(
                    "INSERT INTO OrderDetail (OrderId, ProductId, ProductName, ProductCount, TotalPrice) "
                    "VALUES (%s, %s, %s, %s, %s)",
                    (order_id, item['ProductId'], item['ProductName'],
                     item['ProductNum'], float(item['Price']) * item['ProductNum'])
                )

                # Track Purchase behavior
                behavior_tracker.track_event(
                    customer_id=user_id,
                    event_type='Purchase',
                    product_id=item['ProductId']
                )

            # Clear cart
            cursor.execute("DELETE FROM ShopCart WHERE CustomerId = %s", (user_id,))

            conn.commit()
    finally:
        conn.close()

    flash('Order placed successfully!', 'success')
    return redirect(url_for('orders'))


@app.route('/orders')
@login_required
def orders():
    user_id = session['user_id']

    user_orders = query_db(
        """
        SELECT 
            o.OrderId as id, 
            o.TotalAmount as total, 
            o.OrderStatus as status, 
            o.CreatedAt as date,
            (SELECT COUNT(*) FROM OrderDetail d WHERE d.OrderId = o.OrderId) as item_count
        FROM OrderInfo o
        WHERE o.CustomerId = %s
        ORDER BY o.CreatedAt DESC
        """,
        (user_id,)
    )

    orders_list = []
    for order in user_orders:
        orders_list.append({
            'id': order['id'],
            'total': float(order['total']),
            'status': order['status'],
            'date': order['date'],
            'item_count': order['item_count']
        })

    return render_template('orders.html', orders=orders_list)


# ============================================================================
# API - BEHAVIOR DATA STATISTICS
# ============================================================================

@app.route('/api/behavior/stats')
def behavior_stats():
    """Get behavior data statistics"""
    stats = query_db("""
        SELECT RefType, DataPeriod, RecordCount, FileSize, CreatedAt
        FROM UnstructuredDataRef
        ORDER BY DataPeriod DESC
        LIMIT 10
    """)

    return {
        'status': 'success',
        'data': [
            {
                'type': s['RefType'],
                'period': s['DataPeriod'],
                'records': s['RecordCount'],
                'size_mb': round(s['FileSize'] / 1024 / 1024, 2) if s['FileSize'] else 0
            }
            for s in stats
        ]
    }


# ============================================================================
# RUN APPLICATION
# ============================================================================

if __name__ == '__main__':
    print("=" * 60)
    print("E-Commerce App - MySQL + Behavior Tracking")
    print("=" * 60)
    print(f"Database: {DB_CONFIG['database']}")
    print(f"Behavior Data Directory: {BEHAVIOR_DATA_DIR}")
    print(f"Search Data Directory: {SEARCH_DATA_DIR}")
    print("=" * 60)
    print("Open: http://localhost:8000")
    print("=" * 60)
    app.run(debug=True, port=8000)
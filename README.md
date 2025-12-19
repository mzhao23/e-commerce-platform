# E-Commerce Web Application with ML Recommendation System

A Flask-based e-commerce web application featuring user behavior tracking and a hybrid machine learning recommendation system.

## Features

- **User Authentication**: Register, login, and logout functionality
- **Product Catalog**: Browse products with search
- **Shopping Cart**: Add, remove items and checkout
- **Order Management**: View order history and status
- **User Behavior Tracking**: Automatically tracks views, cart actions, purchases, and searches
- **ML Recommendation System**: Hybrid product recommendation system combining collaborative filtering with supervised machine learning models

## Project Structure

```
ecommerce_webapp/
├── app.py                      # Main Flask application
├── db_config.py                # Database configuration
├── recommendation_system.py    # ML recommendation engine
├── database/                   # Database script directory.
├── data/                       # User behavior data (auto-generated)
│   ├── behavior/               
│   └── searches/               
├── static/                   
│   └── images/                 # Storage for product and category images (e.g., category_10.jpeg).
├── templates/                  # Presentation Layer: Jinja2 HTML templates[cite: 46].
│   ├── base.html               
│   ├── index.html             
│   ├── login.html              
│   ├── register.html           
│   ├── products.html           
│   ├── product_detail.html     
│   ├── cart.html               
│   ├── orders.html             
│   └── search_results.html     
└── requirements.txt            # Python dependencies
```

## Installation

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

Or install manually:

```bash
pip install flask pymysql werkzeug pandas numpy scikit-learn
```

### 2. Configure Database Connection

Edit `db_config.py` and update with your MySQL credentials:

```python
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'your_password_here',  # ← Change this
    'database': 'ecommerce_db',
    'charset': 'utf8mb4',
}
```

### 3. Set Up MySQL Database

Make sure MySQL is running, then create the database and import the schema:

**For macOS:**

```bash
/usr/local/mysql/bin/mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS ecommerce_db;"
/usr/local/mysql/bin/mysql -u root -p ecommerce_db < ecommerce_db.sql
```

### 4. Start the Web Server

```bash
python3 app.py
```

The application will be available at: **http://localhost:8000**

### 5. Login

Use the default test account to login:

| Field    | Value           |
|----------|-----------------|
| Email    | test@test.com   |
| Password | 123456          |

## Running the Recommendation System

> **Note**: Before running the recommendation system, the "Recommended For You" section on the homepage displays **random products**. After running the recommendation system, it will show **personalized recommendations** based on user behavior and ML algorithms.

To generate personalized recommendations:

```bash
python3 recommendation_system.py
```

After running, refresh the webpage to see the updated recommendations.

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Homepage with featured products and recommendations |
| `/login` | GET, POST | User login |
| `/register` | GET, POST | User registration |
| `/logout` | GET | User logout |
| `/products` | GET | Product listing with pagination |
| `/product/<id>` | GET | Product detail page |
| `/search?q=` | GET | Search products |
| `/cart` | GET | View shopping cart |
| `/cart/add/<id>` | POST | Add product to cart |
| `/cart/remove/<index>` | POST | Remove product from cart |
| `/checkout` | POST | Process checkout |
| `/orders` | GET | View order history |
| `/api/behavior/stats` | GET | Get behavior tracking statistics |

## Configuration Options

In `db_config.py`:

```python
# Recommendation settings
RECOMMENDATION_EXPIRE_HOURS = 24  # How long recommendations remain valid
RECOMMENDATIONS_PER_USER = 10    # Number of recommendations per user

# Data storage paths
BEHAVIOR_DATA_DIR = './data/behavior'
SEARCH_DATA_DIR = './data/searches'
```

"""
Database Configuration
"""

# MySQL database configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'root1234',
    'database': 'ecommerce_db',
    'charset': 'utf8mb4',
}

BEHAVIOR_DATA_DIR = './data/behavior'
SEARCH_DATA_DIR = './data/searches'

RECOMMENDATION_EXPIRE_HOURS = 24 #hours
RECOMMENDATIONS_PER_USER = 10
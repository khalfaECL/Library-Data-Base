"""
config.py
Configuration de l'application Flask et de la base de données
"""

import os

class Config:
    """Configuration de base"""
    
    # Flask
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'votre_cle_secrete_bibliotheque_ecl_2025'
    DEBUG = True
    
    # Database
    DB_CONFIG = {
        'host': os.environ.get('DB_HOST', 'localhost'),
        'user': os.environ.get('DB_USER', 'biblio_user'),
        'password': os.environ.get('DB_PASSWORD', 'biblio2025'),
        'database': os.environ.get('DB_NAME', 'bibliotheque_ecl')
    }
    
    # Alternative : Unix socket pour sudo mysql
    DB_SOCKET_CONFIG = {
        'unix_socket': '/var/run/mysqld/mysqld.sock',
        'user': 'root',
        'database': 'bibliotheque_ecl'
    }
    
    # Application
    ITEMS_PER_PAGE = 20
    MAX_SEARCH_RESULTS = 100

class DevelopmentConfig(Config):
    """Configuration de développement"""
    DEBUG = True

class ProductionConfig(Config):
    """Configuration de production"""
    DEBUG = False
    SECRET_KEY = os.environ.get('SECRET_KEY')  # Obligatoire en prod

# Configuration par défaut
config = DevelopmentConfig()
"""
models/database.py
Gestion de la connexion MySQL
"""

import mysql.connector
from mysql.connector import Error
import sys
import os

# Ajouter le dossier parent au path pour importer config
parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, parent_dir)

from config import config

def get_connection():
    """Créer et retourner une connexion à la base de données"""
    try:
        # Option 1 : Connexion standard
        conn = mysql.connector.connect(**config.DB_CONFIG)
        return conn
    except Error as e:
        print(f"Erreur de connexion standard : {e}")
        # Option 2 : Connexion Unix socket (pour sudo mysql)
        try:
            conn = mysql.connector.connect(**config.DB_SOCKET_CONFIG)
            return conn
        except Error as e2:
            print(f"Erreur de connexion socket : {e2}")
            return None

def execute_query(query, params=None, fetchone=False, fetchall=False):
    """
    Exécuter une requête SQL
    Args:
        query: Requête SQL
        params: Paramètres (tuple)
        fetchone: Retourner une seule ligne
        fetchall: Retourner toutes les lignes
    """
    conn = get_connection()
    if not conn:
        return None
    
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query, params or ())
        
        if fetchone:
            result = cursor.fetchone()
        elif fetchall:
            result = cursor.fetchall()
        else:
            conn.commit()
            result = cursor.lastrowid
        
        cursor.close()
        conn.close()
        return result
    except Error as e:
        print(f"Erreur SQL : {e}")
        return None
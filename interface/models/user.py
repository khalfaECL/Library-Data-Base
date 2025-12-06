"""
models/user.py
Gestion des utilisateurs
"""

from .database import get_connection, execute_query

# ============================================================================
# AUTHENTIFICATION
# ============================================================================

def get_user_by_email(email):
    """Récupérer un utilisateur par son email (gère @ecl.fr et @ec-lyon.fr)"""
    query = """
        SELECT email, prenom, nom, role
        FROM UTILISATEUR
        WHERE email = %s 
           OR email = REPLACE(%s, '@ecl.fr', '@ec-lyon.fr')
           OR email = REPLACE(%s, '@ec-lyon.fr', '@ecl.fr')
    """
    return execute_query(query, params=(email, email, email), fetchone=True)

def get_all_users():
    """Liste de tous les utilisateurs (sauf admin)"""
    query = """
        SELECT 
            email, 
            CONCAT(prenom, ' ', nom) AS nom_complet, 
            prenom, 
            nom, 
            role
        FROM UTILISATEUR
        WHERE email != 'admin@ecl.fr'
        ORDER BY nom
    """
    return execute_query(query, fetchall=True)

def get_all_users_with_stats():
    """Récupérer tous les utilisateurs avec statistiques"""
    query = """
        SELECT 
            u.email,
            u.prenom,
            u.nom,
            u.role,
            COUNT(DISTINCT ada.id_labo) AS nb_labos,
            COUNT(DISTINCT p.id_publication) AS nb_emprunts
        FROM UTILISATEUR u
        LEFT JOIN A_DROIT_ACCES ada ON u.email = ada.email
        LEFT JOIN PUBLICATION p ON u.email = p.email_emprunteur
        GROUP BY u.email, u.prenom, u.nom, u.role
        ORDER BY u.role DESC, u.nom
    """
    return execute_query(query, fetchall=True)

# ============================================================================
# GESTION DES UTILISATEURS (Admin)
# ============================================================================

def add_user(email, prenom, nom, role='utilisateur'):
    """Ajouter un nouvel utilisateur"""
    conn = get_connection()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        query = """
            INSERT INTO UTILISATEUR (email, prenom, nom, role)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(query, (email, prenom, nom, role))
        conn.commit()
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"Erreur add_user: {e}")
        if conn:
            conn.close()
        return False

def delete_user(email):
    """Supprimer un utilisateur"""
    conn = get_connection()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        
        # Vérifier que ce n'est pas l'admin
        if email == 'admin@ecl.fr':
            return False
        
        # Supprimer l'utilisateur
        query = "DELETE FROM UTILISATEUR WHERE email = %s"
        cursor.execute(query, (email,))
        rows_affected = cursor.rowcount
        
        conn.commit()
        cursor.close()
        conn.close()
        return rows_affected > 0
    except Exception as e:
        print(f"Erreur delete_user: {e}")
        if conn:
            conn.close()
        return False

def give_lab_access(email, id_labo):
    """Donner accès à un laboratoire"""
    conn = get_connection()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        query = "INSERT IGNORE INTO A_DROIT_ACCES (email, id_labo) VALUES (%s, %s)"
        cursor.execute(query, (email, id_labo))
        conn.commit()
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"Erreur give_lab_access: {e}")
        if conn:
            conn.close()
        return False

def get_all_labs():
    """Récupérer tous les laboratoires"""
    query = "SELECT id_labo, nom_labo FROM LABORATOIRE ORDER BY nom_labo"
    return execute_query(query, fetchall=True)
"""
models/proposal.py
Gestion des propositions d'achat
"""

from .database import get_connection, execute_query

def add_purchase_proposal(data):
    """Ajouter une proposition d'achat"""
    conn = get_connection()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        query = """
            INSERT INTO PROPOSITION_ACHAT 
            (date_proposition, titre, auteurs, editeur, annee, type_publication, 
             informations_complementaires, email_utilisateur)
            VALUES (CURDATE(), %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(query, (
            data.get('titre'),
            data.get('auteurs'),
            data.get('editeur'),
            data.get('annee'),
            data.get('type_publication'),
            data.get('informations_complementaires'),
            data.get('email_utilisateur')
        ))
        conn.commit()
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"Erreur add_purchase_proposal: {e}")
        if conn:
            conn.close()
        return False

def get_all_proposals():
    """Récupérer toutes les propositions d'achat"""
    query = """
        SELECT 
            pa.*,
            CONCAT(u.prenom, ' ', u.nom) AS nom_proposeur
        FROM PROPOSITION_ACHAT pa
        JOIN UTILISATEUR u ON pa.email_utilisateur = u.email
        ORDER BY pa.date_proposition DESC
    """
    return execute_query(query, fetchall=True)

def get_user_proposals(email):
    """Récupérer les propositions d'un utilisateur"""
    query = """
        SELECT *
        FROM PROPOSITION_ACHAT
        WHERE email_utilisateur = %s
        ORDER BY date_proposition DESC
    """
    return execute_query(query, params=(email,), fetchall=True)

def delete_proposal(id_proposition):
    """Supprimer une proposition"""
    conn = get_connection()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        query = "DELETE FROM PROPOSITION_ACHAT WHERE id_proposition = %s"
        cursor.execute(query, (id_proposition,))
        conn.commit()
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"Erreur delete_proposal: {e}")
        if conn:
            conn.close()
        return False
"""
models/loss.py
Gestion des déclarations de perte
"""

from .database import get_connection, execute_query

def get_all_losses():
    """Récupérer toutes les déclarations de perte avec statut de résolution"""
    query = """
        SELECT 
            dl.id_declaration,
            dl.id_publication,
            dl.email_admin,
            dl.email_responsable,
            dl.date_declaration,
            dl.motif,
            dl.cout_remplacement,
            dl.statut_resolution,
            dl.date_resolution,
            dl.commentaire_resolution,
            COALESCE(p.titre, 'Publication inconnue') AS titre,
            COALESCE(p.editeur, 'N/A') AS editeur,
            COALESCE(p.prix, 0) AS prix,
            COALESCE(p.code_devise, '€') AS code_devise,
            COALESCE(p.statut, 'inconnu') AS statut_actuel,
            COALESCE(l.nom_labo, 'Labo inconnu') AS nom_labo,
            COALESCE(CONCAT(u1.prenom, ' ', u1.nom), dl.email_admin) AS nom_admin,
            COALESCE(CONCAT(u2.prenom, ' ', u2.nom), dl.email_responsable) AS nom_responsable
        FROM DECLARATION_PERTE dl
        LEFT JOIN PUBLICATION p ON dl.id_publication = p.id_publication
        LEFT JOIN LABORATOIRE l ON p.id_labo = l.id_labo
        LEFT JOIN UTILISATEUR u1 ON 
            dl.email_admin COLLATE utf8mb4_0900_ai_ci = u1.email COLLATE utf8mb4_0900_ai_ci
        LEFT JOIN UTILISATEUR u2 ON 
            dl.email_responsable COLLATE utf8mb4_0900_ai_ci = u2.email COLLATE utf8mb4_0900_ai_ci
        ORDER BY 
            CASE dl.statut_resolution
                WHEN 'perdu' THEN 1
                WHEN 'retrouvé' THEN 2
                WHEN 'remplacé' THEN 3
            END,
            dl.date_declaration DESC
    """
    return execute_query(query, fetchall=True)

def declare_loss_with_date(id_publication, email_admin, email_responsable, date_decouverte, motif, cout):
    """Déclarer une publication comme perdue avec date de découverte"""
    conn = get_connection()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        
        query_insert = """
            INSERT INTO DECLARATION_PERTE 
            (id_publication, email_admin, email_responsable, date_declaration, 
             motif, cout_remplacement, statut_resolution)
            VALUES (%s, %s, %s, %s, %s, %s, 'perdu')
        """
        cursor.execute(query_insert, (id_publication, email_admin, email_responsable, 
                                      date_decouverte, motif, cout))
        
        query_update = """
            UPDATE PUBLICATION 
            SET statut = 'perdu', email_emprunteur = NULL
            WHERE id_publication = %s
        """
        cursor.execute(query_update, (id_publication,))
        
        conn.commit()
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"Erreur declare_loss_with_date: {e}")
        if conn:
            conn.close()
        return False

def mark_as_found(id_publication, commentaire=None):
    """Marquer une publication perdue comme retrouvée"""
    conn = get_connection()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        
        query_pub = """
            UPDATE PUBLICATION 
            SET statut = 'sur étagère'
            WHERE id_publication = %s AND statut = 'perdu'
        """
        cursor.execute(query_pub, (id_publication,))
        
        query_decl = """
            UPDATE DECLARATION_PERTE
            SET statut_resolution = 'retrouvé',
                date_resolution = CURDATE(),
                commentaire_resolution = %s
            WHERE id_publication = %s 
            AND statut_resolution = 'perdu'
        """
        cursor.execute(query_decl, (commentaire, id_publication))
        
        rows_affected = cursor.rowcount
        conn.commit()
        cursor.close()
        conn.close()
        return rows_affected > 0
    except Exception as e:
        print(f"Erreur mark_as_found: {e}")
        if conn:
            conn.close()
        return False

def get_all_publications_for_loss():
    """Récupérer toutes les publications (sauf déjà perdues) pour déclaration de perte"""
    query = """
        SELECT 
            p.id_publication,
            p.titre,
            p.editeur,
            p.annee_publication,
            p.statut,
            p.prix,
            p.code_devise,
            l.nom_labo,
            CONCAT(u.prenom, ' ', u.nom) AS nom_emprunteur,
            u.email AS email_emprunteur
        FROM PUBLICATION p
        JOIN LABORATOIRE l ON p.id_labo = l.id_labo
        LEFT JOIN UTILISATEUR u ON p.email_emprunteur = u.email
        WHERE p.statut != 'perdu'
        ORDER BY p.titre
    """
    return execute_query(query, fetchall=True)
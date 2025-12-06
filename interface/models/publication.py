"""
models/publication.py
Gestion des publications (livres, périodiques, rapports)
"""

from .database import get_connection, execute_query

# ============================================================================
# REQUÊTES PUBLICATIONS
# ============================================================================

def get_all_publications():
    """Liste de toutes les publications avec auteurs agrégés"""
    query = """
        SELECT DISTINCT
            p.id_publication,
            p.titre,
            p.editeur,
            p.annee_publication,
            p.type_publication,
            p.statut,
            p.prix,
            p.code_devise,
            l.nom_labo,
            CASE 
                WHEN liv.isbn IS NOT NULL THEN liv.isbn
                WHEN per.numero_volume IS NOT NULL THEN per.numero_volume
                WHEN r.numero_identification IS NOT NULL THEN r.numero_identification
                ELSE NULL
            END AS identification,
            GROUP_CONCAT(DISTINCT CONCAT(a.prenom, ' ', a.nom) ORDER BY a.nom SEPARATOR ', ') AS auteurs
        FROM PUBLICATION p
        JOIN LABORATOIRE l ON p.id_labo = l.id_labo
        LEFT JOIN LIVRE liv ON p.id_publication = liv.id_publication
        LEFT JOIN PERIODIQUE per ON p.id_publication = per.id_publication
        LEFT JOIN RAPPORT_INTERNE r ON p.id_publication = r.id_publication
        LEFT JOIN ECRIT e ON p.id_publication = e.id_publication
        LEFT JOIN AUTEUR a ON e.id_auteur = a.id_auteur
        GROUP BY p.id_publication, p.titre, p.editeur, p.annee_publication, p.type_publication, 
                 p.statut, p.prix, p.code_devise, l.nom_labo, liv.isbn, per.numero_volume, r.numero_identification
        ORDER BY p.titre
    """
    return execute_query(query, fetchall=True)

def get_publication_details(id_publication):
    """Récupérer les détails d'une publication"""
    query = """
        SELECT 
            p.*,
            l.nom_labo,
            CONCAT(u.prenom, ' ', u.nom) AS nom_emprunteur
        FROM PUBLICATION p
        JOIN LABORATOIRE l ON p.id_labo = l.id_labo
        LEFT JOIN UTILISATEUR u ON p.email_emprunteur = u.email
        WHERE p.id_publication = %s
    """
    return execute_query(query, params=(id_publication,), fetchone=True)

def get_publication_availability(id_publication):
    """Obtenir les détails de disponibilité d'une publication"""
    query = """
        SELECT 
            p.id_publication,
            p.titre,
            p.statut,
            p.email_emprunteur,
            CONCAT(u.prenom, ' ', u.nom) AS nom_emprunteur,
            l.nom_labo,
            (SELECT COUNT(*) 
             FROM PUBLICATION p2 
             LEFT JOIN LIVRE liv2 ON p2.id_publication = liv2.id_publication
             LEFT JOIN LIVRE liv1 ON p.id_publication = liv1.id_publication
             WHERE (liv1.isbn IS NOT NULL AND liv2.isbn = liv1.isbn)
                OR (liv1.isbn IS NULL AND p2.titre = p.titre)
            ) AS total_exemplaires,
            (SELECT COUNT(*) 
             FROM PUBLICATION p2 
             LEFT JOIN LIVRE liv2 ON p2.id_publication = liv2.id_publication
             LEFT JOIN LIVRE liv1 ON p.id_publication = liv1.id_publication
             WHERE ((liv1.isbn IS NOT NULL AND liv2.isbn = liv1.isbn)
                OR (liv1.isbn IS NULL AND p2.titre = p.titre))
               AND p2.statut = 'sur étagère'
            ) AS exemplaires_disponibles
        FROM PUBLICATION p
        JOIN LABORATOIRE l ON p.id_labo = l.id_labo
        LEFT JOIN UTILISATEUR u ON p.email_emprunteur = u.email
        WHERE p.id_publication = %s
    """
    return execute_query(query, params=(id_publication,), fetchone=True)

def get_all_borrowers_of_title(titre):
    """Obtenir tous ceux qui ont emprunté un titre donné"""
    query = """
        SELECT 
            p.id_publication,
            CONCAT(u.prenom, ' ', u.nom) AS nom_emprunteur,
            u.email,
            l.nom_labo
        FROM PUBLICATION p
        JOIN UTILISATEUR u ON p.email_emprunteur = u.email
        JOIN LABORATOIRE l ON p.id_labo = l.id_labo
        WHERE p.titre = %s AND p.statut = 'emprunté'
        ORDER BY l.nom_labo
    """
    return execute_query(query, params=(titre,), fetchall=True)

def add_publication(data):
    """Ajouter une nouvelle publication"""
    query = """
        INSERT INTO PUBLICATION 
        (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, 
         statut, type_publication, id_labo)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    params = (
        data['titre'], data['editeur'], data['edition'], data['annee'],
        data['librairie'], data['prix'], data['devise'], data['statut'],
        data['type'], data['id_labo']
    )
    return execute_query(query, params=params)

# ============================================================================
# EMPRUNTS
# ============================================================================

def get_user_loans(email):
    """Publications empruntées par un utilisateur"""
    query = """
        SELECT 
            p.id_publication,
            p.titre,
            p.editeur,
            p.annee_publication,
            l.nom_labo,
            CASE 
                WHEN liv.isbn IS NOT NULL THEN liv.isbn
                WHEN per.numero_volume IS NOT NULL THEN per.numero_volume
                WHEN r.numero_identification IS NOT NULL THEN r.numero_identification
            END AS identification
        FROM PUBLICATION p
        JOIN LABORATOIRE l ON p.id_labo = l.id_labo
        LEFT JOIN LIVRE liv ON p.id_publication = liv.id_publication
        LEFT JOIN PERIODIQUE per ON p.id_publication = per.id_publication
        LEFT JOIN RAPPORT_INTERNE r ON p.id_publication = r.id_publication
        WHERE p.email_emprunteur = %s
        ORDER BY p.titre
    """
    return execute_query(query, params=(email,), fetchall=True)

def can_user_borrow(email, id_publication):
    """Vérifier si un utilisateur peut emprunter une publication"""
    query = """
        SELECT COUNT(*) as can_borrow
        FROM PUBLICATION p
        JOIN LABORATOIRE l ON p.id_labo = l.id_labo
        JOIN A_DROIT_ACCES ada ON l.id_labo = ada.id_labo
        WHERE p.id_publication = %s
          AND p.statut = 'sur étagère'
          AND (
              ada.email = %s 
              OR ada.email = REPLACE(%s, '@ecl.fr', '@ec-lyon.fr')
              OR ada.email = REPLACE(%s, '@ec-lyon.fr', '@ecl.fr')
          )
    """
    result = execute_query(query, params=(id_publication, email, email, email), fetchone=True)
    return result['can_borrow'] > 0 if result else False

def borrow_publication(id_publication, email):
    """Emprunter une publication"""
    conn = get_connection()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        
        # Normaliser l'email
        query_check = """
            SELECT email FROM UTILISATEUR 
            WHERE email = %s 
               OR email = REPLACE(%s, '@ecl.fr', '@ec-lyon.fr')
               OR email = REPLACE(%s, '@ec-lyon.fr', '@ecl.fr')
            LIMIT 1
        """
        cursor.execute(query_check, (email, email, email))
        user = cursor.fetchone()
        
        if not user:
            cursor.close()
            conn.close()
            return False
        
        real_email = user[0]
        
        query = """
            UPDATE PUBLICATION 
            SET statut = 'emprunté', email_emprunteur = %s
            WHERE id_publication = %s AND statut = 'sur étagère'
        """
        cursor.execute(query, (real_email, id_publication))
        rows_affected = cursor.rowcount
        conn.commit()
        cursor.close()
        conn.close()
        return rows_affected > 0
    except Exception as e:
        print(f"Erreur borrow_publication: {e}")
        if conn:
            conn.close()
        return False

def return_publication(id_publication):
    """Retourner une publication"""
    conn = get_connection()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        query = """
            UPDATE PUBLICATION 
            SET statut = 'sur étagère', email_emprunteur = NULL
            WHERE id_publication = %s AND statut = 'emprunté'
        """
        cursor.execute(query, (id_publication,))
        rows_affected = cursor.rowcount
        conn.commit()
        cursor.close()
        conn.close()
        return rows_affected > 0
    except Exception as e:
        print(f"Erreur return_publication: {e}")
        return False

# ============================================================================
# RECHERCHE
# ============================================================================

def search_by_category_price(categorie, prix_max):
    """Rechercher des livres par catégorie et prix maximum en euros"""
    query = """
        SELECT 
            p.id_publication,
            p.titre,
            GROUP_CONCAT(DISTINCT CONCAT(a.prenom, ' ', a.nom) SEPARATOR ', ') AS auteurs,
            p.prix,
            d.code_devise,
            ROUND(p.prix * d.taux_vers_euro, 2) AS prix_euros,
            l.nom_labo
        FROM PUBLICATION p
        JOIN LIVRE liv ON p.id_publication = liv.id_publication
        JOIN APPARTIENT_A ap ON liv.id_publication = ap.id_publication
        JOIN CATEGORIE c ON ap.id_categorie = c.id_categorie
        JOIN DEVISE d ON p.code_devise = d.code_devise
        JOIN LABORATOIRE l ON p.id_labo = l.id_labo
        LEFT JOIN ECRIT e ON p.id_publication = e.id_publication
        LEFT JOIN AUTEUR a ON e.id_auteur = a.id_auteur
        WHERE c.nom_categorie = %s
          AND (p.prix * d.taux_vers_euro) < %s
        GROUP BY p.id_publication, p.titre, p.prix, d.code_devise, l.nom_labo
        ORDER BY prix_euros ASC
    """
    return execute_query(query, params=(categorie, prix_max), fetchall=True)

def search_by_author_year(nom, prenom, annee_min):
    """Rechercher les publications d'un auteur après une année donnée"""
    query = """
        SELECT 
            p.id_publication,
            p.titre,
            p.editeur,
            p.annee_publication,
            p.type_publication,
            GROUP_CONCAT(DISTINCT CONCAT(a2.prenom, ' ', a2.nom) SEPARATOR ', ') AS tous_auteurs
        FROM PUBLICATION p
        JOIN ECRIT e ON p.id_publication = e.id_publication
        JOIN AUTEUR a ON e.id_auteur = a.id_auteur
        LEFT JOIN ECRIT e2 ON p.id_publication = e2.id_publication
        LEFT JOIN AUTEUR a2 ON e2.id_auteur = a2.id_auteur
        WHERE a.nom = %s
          AND a.prenom = %s
          AND p.annee_publication > %s
        GROUP BY p.id_publication, p.titre, p.editeur, p.annee_publication, p.type_publication
        ORDER BY p.annee_publication DESC
    """
    return execute_query(query, params=(nom, prenom, annee_min), fetchall=True)

def get_books_by_publisher(editeur):
    """Liste chronologique des livres d'un éditeur"""
    query = """
        SELECT 
            l.isbn,
            p.titre,
            p.edition,
            p.annee_publication,
            GROUP_CONCAT(DISTINCT CONCAT(a.prenom, ' ', a.nom) ORDER BY a.nom SEPARATOR ', ') AS auteurs,
            p.prix,
            d.code_devise
        FROM PUBLICATION p
        JOIN LIVRE l ON p.id_publication = l.id_publication
        JOIN DEVISE d ON p.code_devise = d.code_devise
        LEFT JOIN ECRIT e ON p.id_publication = e.id_publication
        LEFT JOIN AUTEUR a ON e.id_auteur = a.id_auteur
        WHERE p.editeur = %s
        GROUP BY p.id_publication, l.isbn, p.titre, p.edition, p.annee_publication, p.prix, d.code_devise
        ORDER BY p.annee_publication ASC, p.titre
    """
    return execute_query(query, params=(editeur,), fetchall=True)

def get_all_categories():
    """Liste de toutes les catégories"""
    query = "SELECT id_categorie, nom_categorie FROM CATEGORIE ORDER BY nom_categorie"
    return execute_query(query, fetchall=True)

def get_all_publishers():
    """Liste de tous les éditeurs distincts"""
    query = "SELECT DISTINCT editeur FROM PUBLICATION WHERE editeur IS NOT NULL ORDER BY editeur"
    return execute_query(query, fetchall=True)

# ============================================================================
# VUES SQL
# ============================================================================

def get_available_publications():
    """Vue des publications disponibles"""
    query = "SELECT * FROM vue_publications_disponibles ORDER BY titre"
    return execute_query(query, fetchall=True)

def get_complete_books():
    """Vue des livres complets avec auteurs"""
    query = "SELECT * FROM vue_livres_complets ORDER BY titre"
    return execute_query(query, fetchall=True)

def get_prices_in_euros():
    """Vue des prix en euros"""
    query = "SELECT * FROM vue_prix_euros ORDER BY titre"
    return execute_query(query, fetchall=True)

def get_lab_statistics():
    """Vue des statistiques par laboratoire"""
    query = "SELECT * FROM vue_stats_labos ORDER BY total_publications DESC"
    return execute_query(query, fetchall=True)

# ============================================================================
# STATISTIQUES ADMIN
# ============================================================================

def get_lab_stats():
    """Statistiques et prix total par laboratoire"""
    query = """
        SELECT 
            l.id_labo,
            l.nom_labo,
            COUNT(p.id_publication) AS nombre_publications,
            ROUND(SUM(p.prix * d.taux_vers_euro), 2) AS prix_total_euros
        FROM LABORATOIRE l
        LEFT JOIN PUBLICATION p ON l.id_labo = p.id_labo
        LEFT JOIN DEVISE d ON p.code_devise = d.code_devise
        GROUP BY l.id_labo, l.nom_labo
        ORDER BY prix_total_euros DESC
    """
    return execute_query(query, fetchall=True)

def get_lost_books():
    """Liste des livres perdus avec leurs informations"""
    query = """
        SELECT 
            p.titre,
            p.editeur,
            l.isbn,
            lab.nom_labo AS proprietaire,
            p.prix,
            d.code_devise,
            ROUND(p.prix * d.taux_vers_euro, 2) AS prix_euros,
            GROUP_CONCAT(DISTINCT CONCAT(a.prenom, ' ', a.nom) ORDER BY a.nom SEPARATOR ', ') AS auteurs
        FROM PUBLICATION p
        JOIN LIVRE l ON p.id_publication = l.id_publication
        JOIN LABORATOIRE lab ON p.id_labo = lab.id_labo
        JOIN DEVISE d ON p.code_devise = d.code_devise
        LEFT JOIN ECRIT e ON p.id_publication = e.id_publication
        LEFT JOIN AUTEUR a ON e.id_auteur = a.id_auteur
        WHERE p.statut = 'perdu'
        GROUP BY p.titre, p.editeur, l.isbn, lab.nom_labo, p.prix, d.code_devise
        ORDER BY lab.nom_labo ASC, l.isbn ASC
    """
    return execute_query(query, fetchall=True)

def get_borrowed_publications():
    """Récupérer toutes les publications empruntées"""
    query = """
        SELECT 
            p.id_publication,
            p.titre,
            p.editeur,
            p.prix,
            p.code_devise,
            l.nom_labo,
            CONCAT(u.prenom, ' ', u.nom) AS nom_emprunteur,
            u.email AS email_emprunteur
        FROM PUBLICATION p
        JOIN LABORATOIRE l ON p.id_labo = l.id_labo
        LEFT JOIN UTILISATEUR u ON p.email_emprunteur = u.email
        WHERE p.statut = 'emprunté'
        ORDER BY p.titre
    """
    return execute_query(query, fetchall=True)
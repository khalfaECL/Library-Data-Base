"""
controllers/publications.py
Gestion des publications et emprunts
"""

from flask import Blueprint, render_template, request, redirect, url_for, flash, session
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from models import publication, user
from .auth import require_login

# Créer le blueprint
publications_bp = Blueprint('publications', __name__)

# ============================================================================
# PAGE D'ACCUEIL
# ============================================================================

@publications_bp.route('/')
@require_login
def index():
    """Page d'accueil : liste de toutes les publications"""
    publications_list = publication.get_all_publications() or []
    users = user.get_all_users() or []
    
    # Enrichir avec disponibilité
    for pub in publications_list:
        availability = publication.get_publication_availability(pub['id_publication'])
        if availability:
            pub['total_exemplaires'] = availability['total_exemplaires']
            pub['exemplaires_disponibles'] = availability['exemplaires_disponibles']
            pub['nom_emprunteur'] = availability['nom_emprunteur']
            
            if pub['statut'] == 'emprunté':
                borrowers = publication.get_all_borrowers_of_title(pub['titre'])
                pub['tous_emprunteurs'] = borrowers
    
    return render_template('publications/index.html', publications=publications_list, users=users)

# ============================================================================
# RECHERCHE
# ============================================================================

@publications_bp.route('/recherche', methods=['GET', 'POST'])
@require_login
def recherche():
    """Page de recherche avancée"""
    results = None
    search_type = None
    
    if request.method == 'POST':
        search_type = request.form.get('search_type')
        
        if search_type == 'categorie':
            categorie = request.form.get('categorie')
            prix_max = float(request.form.get('prix_max', 1000))
            results = publication.search_by_category_price(categorie, prix_max)
            
        elif search_type == 'auteur':
            nom = request.form.get('nom')
            prenom = request.form.get('prenom')
            annee_min = int(request.form.get('annee_min', 1900))
            results = publication.search_by_author_year(nom, prenom, annee_min)
            
        elif search_type == 'editeur':
            editeur = request.form.get('editeur')
            results = publication.get_books_by_publisher(editeur)
    
    categories = publication.get_all_categories()
    publishers = publication.get_all_publishers()
    
    return render_template('publications/recherche.html', 
                         results=results, 
                         search_type=search_type,
                         categories=categories,
                         publishers=publishers)

# ============================================================================
# MES EMPRUNTS
# ============================================================================

@publications_bp.route('/mes_emprunts', methods=['GET', 'POST'])
@require_login
def mes_emprunts():
    """Afficher les emprunts d'un utilisateur"""
    emprunts = None
    selected_user = None
    
    if request.method == 'POST':
        selected_user = request.form.get('email')
        emprunts = publication.get_user_loans(selected_user)
    
    users = user.get_all_users()
    return render_template('publications/mes_emprunts.html', 
                         emprunts=emprunts, 
                         users=users,
                         selected_user=selected_user)

# ============================================================================
# EMPRUNTER / RETOURNER
# ============================================================================

@publications_bp.route('/emprunter', methods=['POST'])
@require_login
def emprunter():
    """Emprunter une publication"""
    id_publication = request.form.get('id_publication')
    email = request.form.get('email')

    if not id_publication or not email:
        flash(' Données manquantes', 'error')
        return redirect(url_for('publications.index'))
    
    # Vérifier si l'emprunt est possible
    can_borrow = publication.can_user_borrow(email, id_publication)
    
    if not can_borrow:
        flash(' Vous ne pouvez pas emprunter cette publication', 'error')
        return redirect(url_for('publications.index'))
    
    # Effectuer l'emprunt
    success = publication.borrow_publication(id_publication, email)
    
    if success:
        pub = publication.get_publication_details(id_publication)
        titre = pub['titre'] if pub else "la publication"
        flash(f' Publication "{titre}" empruntée avec succès !', 'success')
    else:
        flash(' Erreur lors de l\'emprunt', 'error')
    
    return redirect(url_for('publications.index'))

@publications_bp.route('/retourner', methods=['POST'])
@require_login
def retourner():
    """Retourner une publication"""
    id_publication = request.form.get('id_publication')
    
    success = publication.return_publication(id_publication)
    
    if success:
        flash(' Publication retournée avec succès !', 'success')
    else:
        flash(' Erreur lors du retour', 'error')
    
    return redirect(request.referrer or url_for('publications.index'))

# ============================================================================
# VUES SQL
# ============================================================================

@publications_bp.route('/vues')
@require_login
def vues():
    """Afficher toutes les vues SQL"""
    disponibles = publication.get_available_publications()
    livres_complets = publication.get_complete_books()
    prix_euros = publication.get_prices_in_euros()
    stats_labos = publication.get_lab_statistics()
    
    return render_template('publications/vues.html',
                         disponibles=disponibles,
                         livres_complets=livres_complets,
                         prix_euros=prix_euros,
                         stats_labos=stats_labos)
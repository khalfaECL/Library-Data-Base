"""
controllers/admin.py
Administration du système
"""

from flask import Blueprint, render_template, request, redirect, url_for, flash, session
import sys
import os
from datetime import date

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from models import publication, user, loss, proposal
from models.database import get_connection
from .auth import require_admin

# Créer le blueprint
admin_bp = Blueprint('admin', __name__, url_prefix='/admin')

# ============================================================================
# PAGE PRINCIPALE ADMIN
# ============================================================================

@admin_bp.route('/')
@require_admin
def index():
    """Interface d'administration"""
    conn = get_connection()
    if not conn:
        flash(' Base de données indisponible. Affichage limité des données.', 'error')
        return render_template('admin/admin.html',
                             lab_stats=[],
                             lost_books=[],
                             available_pubs=[],
                             lab_statistics=[],
                             borrowed_pubs=[])

    conn.close()

    lab_stats = publication.get_lab_stats() or []
    lost_books = publication.get_lost_books() or []
    available_pubs = publication.get_available_publications() or []
    lab_statistics = publication.get_lab_statistics() or []
    borrowed_pubs = publication.get_borrowed_publications() or []
    
    return render_template('admin/admin.html',
                         lab_stats=lab_stats,
                         lost_books=lost_books,
                         available_pubs=available_pubs,
                         lab_statistics=lab_statistics,
                         borrowed_pubs=borrowed_pubs)

# ============================================================================
# GESTION DES PUBLICATIONS
# ============================================================================

@admin_bp.route('/ajouter_publication', methods=['GET', 'POST'])
@require_admin
def ajouter_publication():
    """Formulaire d'ajout d'une publication"""
    if request.method == 'POST':
        data = {
            'titre': request.form.get('titre'),
            'editeur': request.form.get('editeur'),
            'edition': request.form.get('edition'),
            'annee': request.form.get('annee'),
            'librairie': request.form.get('librairie'),
            'prix': request.form.get('prix'),
            'devise': request.form.get('devise'),
            'statut': request.form.get('statut'),
            'type': request.form.get('type'),
            'id_labo': request.form.get('id_labo')
        }
        
        success = publication.add_publication(data)
        
        if success:
            flash(' Publication ajoutée avec succès !', 'success')
            return redirect(url_for('admin.index'))
        else:
            flash(' Erreur lors de l\'ajout', 'error')
    
    return render_template('admin/ajouter_publication.html')

# ============================================================================
# GESTION DES UTILISATEURS
# ============================================================================

@admin_bp.route('/utilisateurs')
@require_admin
def gerer_utilisateurs():
    """Interface de gestion des utilisateurs"""
    users = user.get_all_users_with_stats() or []
    return render_template('admin/gerer_utilisateurs.html', users=users)

@admin_bp.route('/utilisateurs/ajouter', methods=['GET', 'POST'])
@require_admin
def ajouter_utilisateur():
    """Formulaire d'ajout d'utilisateur"""
    if request.method == 'POST':
        email = request.form.get('email')
        prenom = request.form.get('prenom')
        nom = request.form.get('nom')
        role = request.form.get('role', 'utilisateur')
        labos = request.form.getlist('labos')
        
        success = user.add_user(email, prenom, nom, role)
        
        if success:
            for id_labo in labos:
                user.give_lab_access(email, id_labo)
            
            flash(f' Utilisateur {prenom} {nom} ajouté avec succès !', 'success')
            return redirect(url_for('admin.gerer_utilisateurs'))
        else:
            flash(' Erreur lors de l\'ajout (email déjà existant ?)', 'error')
    
    labos = user.get_all_labs() or []
    return render_template('admin/ajouter_utilisateur.html', labos=labos)

@admin_bp.route('/utilisateurs/supprimer', methods=['POST'])
@require_admin
def supprimer_utilisateur():
    """Supprimer un utilisateur"""
    email = request.form.get('email')
    
    if email == 'admin@ecl.fr':
        flash(' Impossible de supprimer le compte admin !', 'error')
        return redirect(url_for('admin.gerer_utilisateurs'))
    
    success = user.delete_user(email)
    
    if success:
        flash(f' Utilisateur supprimé avec succès !', 'success')
    else:
        flash(' Erreur lors de la suppression', 'error')
    
    return redirect(url_for('admin.gerer_utilisateurs'))

# ============================================================================
# GESTION DES PERTES
# ============================================================================

@admin_bp.route('/pertes')
@require_admin
def historique_pertes():
    """Historique de toutes les pertes"""
    pertes = loss.get_all_losses() or []
    return render_template('losses/historique_pertes.html', pertes=pertes)

@admin_bp.route('/pertes/declarer', methods=['GET', 'POST'])
@require_admin
def formulaire_declaration_perte():
    """Formulaire pour déclarer n'importe quelle publication comme perdue"""
    if request.method == 'POST':
        id_publication = request.form.get('id_publication')
        date_decouverte = request.form.get('date_decouverte')
        motif = request.form.get('motif')
        cout = request.form.get('cout_remplacement')
        email_admin = session.get('user_email')
        
        pub = publication.get_publication_details(id_publication)
        email_responsable = pub.get('email_emprunteur') if pub else None
        
        success = loss.declare_loss_with_date(id_publication, email_admin, email_responsable, 
                                            date_decouverte, motif, cout)
        
        if success:
            flash(f' Publication déclarée comme perdue', 'success')
            return redirect(url_for('admin.index'))
        else:
            flash(' Erreur lors de la déclaration', 'error')
    
    all_publications = loss.get_all_publications_for_loss() or []
    return render_template('losses/formulaire_declaration_perte.html',
                            publications=all_publications,
                            today=date.today().isoformat())

@admin_bp.route('/pertes/marquer_retrouvee', methods=['POST'])
@require_admin
def marquer_retrouvee():
    """Marquer une publication perdue comme retrouvée"""
    id_publication = request.form.get('id_publication')
    success = loss.mark_as_found(id_publication)
    
    if success:
        flash(' Publication marquée comme retrouvée et remise sur étagère !', 'success')
    else:
        flash(' Erreur : publication non trouvée ou déjà sur étagère', 'error')
    
    return redirect(url_for('admin.historique_pertes'))

# ============================================================================
# GESTION DES PROPOSITIONS
# ============================================================================

@admin_bp.route('/propositions')
@require_admin
def gerer_propositions():
    """Interface admin pour gérer les propositions"""
    propositions = proposal.get_all_proposals() or []
    return render_template('admin/gerer_propositions.html', propositions=propositions)

@admin_bp.route('/propositions/supprimer', methods=['POST'])
@require_admin
def supprimer_proposition():
    """Supprimer une proposition"""
    id_proposition = request.form.get('id_proposition')
    success = proposal.delete_proposal(id_proposition)
    
    if success:
        flash(' Proposition supprimée avec succès !', 'success')
    else:
        flash(' Erreur lors de la suppression', 'error')
    
    return redirect(url_for('admin.gerer_propositions'))
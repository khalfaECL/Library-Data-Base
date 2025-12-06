"""
controllers/users.py
Fonctionnalités utilisateurs (propositions d'achat)
"""

from flask import Blueprint, render_template, request, redirect, url_for, flash
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from models import user, proposal
from .auth import require_login

# Créer le blueprint
users_bp = Blueprint('users', __name__, url_prefix='/utilisateur')

# ============================================================================
# PROPOSITIONS D'ACHAT
# ============================================================================

@users_bp.route('/proposer_achat', methods=['GET', 'POST'])
@require_login
def proposer_achat():
    """Formulaire de proposition d'achat"""
    if request.method == 'POST':
        data = {
            'email_utilisateur': request.form.get('email_utilisateur'),
            'titre': request.form.get('titre'),
            'auteurs': request.form.get('auteurs'),
            'editeur': request.form.get('editeur'),
            'annee': request.form.get('annee'),
            'type_publication': request.form.get('type_publication'),
            'informations_complementaires': request.form.get('informations_complementaires')
        }
        
        try:
            success = proposal.add_purchase_proposal(data)
            if success:
                flash(' Proposition envoyée avec succès !', 'success')
                return redirect(url_for('users.mes_propositions'))
            else:
                flash(' Erreur lors de l\'envoi de la proposition', 'error')
        except Exception as e:
            print(f"Erreur: {e}")
            flash(' Erreur lors de l\'envoi de la proposition', 'error')
    
    users = user.get_all_users() or []
    return render_template('users/proposer_achat.html', users=users)

@users_bp.route('/mes_propositions', methods=['GET', 'POST'])
@require_login
def mes_propositions():
    """Voir les propositions d'un utilisateur"""
    propositions = None
    selected_user = None
    
    if request.method == 'POST':
        selected_user = request.form.get('email')
        propositions = proposal.get_user_proposals(selected_user)
    
    users = user.get_all_users() or []
    return render_template('users/mes_propositions.html', 
                         propositions=propositions,
                         users=users,
                         selected_user=selected_user)
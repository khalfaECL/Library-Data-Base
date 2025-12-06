"""
controllers/auth.py
Gestion de l'authentification (login/logout)
"""

from flask import Blueprint, render_template, request, redirect, url_for, flash, session
import sys
import os

# Ajouter le dossier parent au path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from models import user

# Créer le blueprint
auth_bp = Blueprint('auth', __name__)

# ============================================================================
# ROUTES D'AUTHENTIFICATION
# ============================================================================

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    """Page de connexion"""
    if request.method == 'POST':
        email = (request.form.get('email') or '').strip().lower()

        # Assurer la connexion admin même si l'entrée n'existe pas en base
        if email == 'admin@ecl.fr':
            user_data = user.get_user_by_email(email) or {
                'email': 'admin@ecl.fr',
                'prenom': 'Admin',
                'nom': '',
                'role': 'admin'
            }
        else:
            user_data = user.get_user_by_email(email)
        
        if user_data:
            session['user_email'] = user_data['email']
            session['user_name'] = f"{user_data['prenom']} {user_data['nom']}"
            session['user_role'] = user_data.get('role', 'utilisateur')
            flash(f" Bienvenue {session['user_name']} !", 'success')

            # Rediriger automatiquement les administrateurs vers le panneau admin
            if session['user_role'] == 'admin':
                return redirect(url_for('admin.index'))

            return redirect(url_for('publications.index'))
        else:
            flash(' Utilisateur non trouvé', 'error')
    
    users = user.get_all_users() or []
    return render_template('login.html', users=users)

@auth_bp.route('/logout')
def logout():
    """Déconnexion"""
    user_name = session.get('user_name', 'Utilisateur')
    session.clear()
    flash(f' Au revoir {user_name} ! Vous êtes déconnecté.', 'success')
    return redirect(url_for('auth.login'))

# ============================================================================
# FONCTIONS UTILITAIRES
# ============================================================================

def is_admin():
    """Vérifier si l'utilisateur connecté est admin"""
    return session.get('user_role') == 'admin'

def is_logged_in():
    """Vérifier si un utilisateur est connecté"""
    return 'user_email' in session

def require_login(f):
    """Décorateur pour protéger les routes"""
    from functools import wraps
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not is_logged_in():
            flash(' Vous devez être connecté', 'error')
            return redirect(url_for('auth.login'))
        return f(*args, **kwargs)
    return decorated_function

def require_admin(f):
    """Décorateur pour les routes admin uniquement"""
    from functools import wraps
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not is_logged_in():
            flash(' Vous devez être connecté', 'error')
            return redirect(url_for('auth.login'))
        if not is_admin():
            flash(' Accès refusé : réservé aux administrateurs', 'error')
            return redirect(url_for('publications.index'))
        return f(*args, **kwargs)
    return decorated_function
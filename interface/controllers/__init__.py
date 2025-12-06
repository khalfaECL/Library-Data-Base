"""
controllers/__init__.py
Import des blueprints
"""

# Import absolu au lieu de relatif
from controllers.auth import auth_bp, is_admin, is_logged_in, require_login, require_admin
from controllers.publications import publications_bp
from controllers.admin import admin_bp
from controllers.users import users_bp

__all__ = [
    'auth_bp', 
    'publications_bp', 
    'admin_bp', 
    'users_bp',
    'is_admin',
    'is_logged_in',
    'require_login',
    'require_admin'
]
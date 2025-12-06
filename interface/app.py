"""
app.py
Application Flask - Point d'entrée principal
Architecture MVC avec blueprints
"""

from flask import Flask, redirect, url_for
from config import config

# Créer l'application
app = Flask(__name__)
app.config.from_object(config)

# Importer les blueprints directement
from controllers.auth import auth_bp
from controllers.publications import publications_bp
from controllers.admin import admin_bp
from controllers.users import users_bp

# Enregistrer les blueprints
app.register_blueprint(auth_bp)
app.register_blueprint(publications_bp)
app.register_blueprint(admin_bp)
app.register_blueprint(users_bp)

# Route par défaut (redirection)
@app.route('/')
def root():
    """Redirection vers la page de login"""
    return redirect(url_for('auth.login'))

# ============================================================================
# LANCEMENT DE L'APPLICATION
# ============================================================================

if __name__ == '__main__':
    print("🚀 Démarrage de l'application Bibliothèque ECL")
    print("📁 Architecture MVC activée")
    print("🌐 Accédez à : http://localhost:5000")
    print("👤 Compte admin : admin@ecl.fr")
    print("")
    print("📋 Routes disponibles :")
    print("  Auth:         /login, /logout")
    print("  Publications: /, /recherche, /mes_emprunts, /vues")
    print("  Admin:        /admin, /admin/utilisateurs, /admin/pertes")
    print("  Utilisateur:  /utilisateur/proposer_achat")
    print("")
    app.run(debug=True, host='0.0.0.0', port=5000)
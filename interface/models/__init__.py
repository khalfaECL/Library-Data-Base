"""
models/__init__.py
Import simplifié des modèles
"""

from .database import get_connection, execute_query
from . import user
from . import publication
from . import loss
from . import proposal

__all__ = ['user', 'publication', 'loss', 'proposal', 'get_connection', 'execute_query']
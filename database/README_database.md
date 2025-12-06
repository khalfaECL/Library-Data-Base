# 📊 Scripts SQL - Bibliothèque ECL

## 📁 Organisation des fichiers

### Ordre d'exécution

1. **01_create_database.sql** - Création de la structure complète
   - Création de la base `bibliotheque_ecl`
   - Création de toutes les tables
   - Création des contraintes et index

2. **02_create_views.sql** - Création des vues SQL
   - `vue_publications_disponibles`
   - `vue_livres_complets`
   - `vue_prix_euros`
   - `vue_stats_labos`

3. **03_insert_data.sql** - Insertion des données de test
   - Devises et taux de change
   - Laboratoires
   - Utilisateurs
   - Publications (livres, périodiques, rapports)
   - Catégories et mots-clés
   - Propositions d'achat

4. **04_add_features.sql** - Ajout des fonctionnalités
   - Système d'authentification (rôle admin/utilisateur)
   - Table DECLARATION_PERTE
   - Compte administrateur

5. **05_dump_final.sql** - Dump complet de la base
   - Snapshot complet de la base de données
   - Inclut structure + données + vues

---

## 🚀 Utilisation

### Installation complète (première fois)

```bash
# 1. Créer la base et la structure
mysql -u root -p < 01_create_database.sql

# 2. Créer les vues
mysql -u root -p < 02_create_views.sql

# 3. Insérer les données
mysql -u root -p < 03_insert_data.sql

# 4. Ajouter les fonctionnalités
mysql -u root -p < 04_add_features.sql
```

### Restauration depuis le dump

```bash
# Restaurer depuis le dump complet
mysql -u root -p < 05_dump_final.sql
```

---

## 📋 Contenu de la base

### Tables principales

- **PUBLICATION** - Publications (livres, périodiques, rapports)
- **LIVRE** - Informations spécifiques aux livres (ISBN)
- **PERIODIQUE** - Informations spécifiques aux périodiques
- **RAPPORT_INTERNE** - Rapports internes (thèses, etc.)
- **UTILISATEUR** - Utilisateurs du système
- **LABORATOIRE** - Laboratoires de l'école
- **AUTEUR** - Auteurs des publications
- **CATEGORIE** - Catégories de livres
- **MOT_CLE** - Mots-clés
- **DEVISE** - Devises avec taux de change

### Tables de liaison

- **ECRIT** - Liaison Auteur ↔ Publication
- **APPARTIENT_A** - Liaison Livre ↔ Catégorie
- **A_DROIT_ACCES** - Droits d'accès Utilisateur ↔ Laboratoire
- **COMPORTE** - Liaison Publication ↔ Mot-clé

### Tables fonctionnelles

- **PROPOSITION_ACHAT** - Propositions d'achat des utilisateurs
- **DECLARATION_PERTE** - Déclarations de publications perdues

### Vues SQL

- **vue_publications_disponibles** - Publications disponibles à l'emprunt
- **vue_livres_complets** - Livres avec tous leurs auteurs
- **vue_prix_euros** - Prix convertis en euros
- **vue_stats_labos** - Statistiques par laboratoire

---

## 🔐 Utilisateurs

### Compte administrateur

```
Email : admin@ecl.fr
Nom : Admin Bibliothèque
Rôle : admin
```

### Comptes utilisateurs de test

- alice.dupont@ec-lyon.fr
- bob.martin@ec-lyon.fr
- claire.bernard@ec-lyon.fr
- david.petit@ec-lyon.fr
- emma.rousseau@ec-lyon.fr

---

## 📊 Données de test

### Publications

- **22 livres** (Computer Science, Mathematics, Physics)
- **4 périodiques** (IEEE, ACM, Nature, Science)
- **4 rapports internes** (thèses)

### Statistiques

- 4 laboratoires
- 6 utilisateurs (dont 1 admin)
- ~30 publications
- 3 propositions d'achat

---

## 🔧 Maintenance

### Créer un nouveau dump

```bash
mysqldump -h localhost -u root -p \
  --databases bibliotheque_ecl \
  --routines --triggers --events \
  --add-drop-database \
  --complete-insert \
  > 05_dump_final_$(date +%Y%m%d).sql
```

### Vérifier l'intégrité

```bash
mysql -u root -p bibliotheque_ecl -e "
SELECT 
    'Utilisateurs' AS table_name, COUNT(*) AS count FROM UTILISATEUR
UNION ALL
SELECT 'Publications', COUNT(*) FROM PUBLICATION
UNION ALL
SELECT 'Emprunts actifs', COUNT(*) FROM PUBLICATION WHERE statut = 'emprunté'
UNION ALL
SELECT 'Pertes déclarées', COUNT(*) FROM DECLARATION_PERTE;
"
```

---

## 📝 Notes

- Les emails sont au format `@ec-lyon.fr`
- Le statut des publications : `'sur étagère'`, `'emprunté'`, `'perdu'`, `'à racheter'`
- Les devises supportées : EUR (€), USD ($), GBP (£)
- Collation : `utf8mb4_0900_ai_ci` pour compatibilité
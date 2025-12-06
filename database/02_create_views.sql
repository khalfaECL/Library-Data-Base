-- ============================================================================
-- PROJET 2 - LIBRARY DATABASE
-- Script de création des vues
-- Auteurs:  Amani KRID, Youssef KHALFA
-- ============================================================================

-- Suppression des vues existantes
DROP VIEW IF EXISTS vue_publications_disponibles;
DROP VIEW IF EXISTS vue_publications_empruntes;
DROP VIEW IF EXISTS vue_livres_complets;
DROP VIEW IF EXISTS vue_prix_euros;
DROP VIEW IF EXISTS vue_stats_labos;

-- ============================================================================
-- VUE 1 : Publications disponibles à l'emprunt
-- Objectif : Voir rapidement toutes les publications sur étagère
-- ============================================================================

CREATE VIEW vue_publications_disponibles AS
SELECT 
    p.id_publication,
    p.titre,
    p.editeur,
    p.annee_publication,
    p.type_publication,
    l.nom_labo AS laboratoire,
    p.prix,
    p.code_devise
FROM PUBLICATION p
JOIN LABORATOIRE l ON p.id_labo = l.id_labo
WHERE p.statut = 'sur étagère';

-- Utilisation : SELECT * FROM vue_publications_disponibles;

-- ============================================================================
-- VUE 2 : Publications actuellement empruntées
-- Objectif : Voir qui a emprunté quoi
-- ============================================================================

CREATE VIEW vue_publications_empruntes AS
SELECT 
    p.titre,
    p.type_publication,
    CONCAT(u.prenom, ' ', u.nom) AS emprunteur,
    u.email,
    l.nom_labo AS laboratoire
FROM PUBLICATION p
JOIN UTILISATEUR u ON p.email_emprunteur = u.email
JOIN LABORATOIRE l ON p.id_labo = l.id_labo
WHERE p.statut = 'emprunté';

-- Utilisation : SELECT * FROM vue_publications_empruntes;

-- ============================================================================
-- VUE 3 : Livres avec leurs auteurs
-- Objectif : Voir les livres avec tous leurs auteurs en une seule ligne
-- ============================================================================

CREATE VIEW vue_livres_complets AS
SELECT 
    p.id_publication,
    p.titre,
    p.editeur,
    p.annee_publication,
    liv.isbn,
    GROUP_CONCAT(CONCAT(a.prenom, ' ', a.nom) ORDER BY a.nom SEPARATOR ', ') AS auteurs,
    p.statut,
    l.nom_labo AS laboratoire
FROM PUBLICATION p
JOIN LIVRE liv ON p.id_publication = liv.id_publication
JOIN LABORATOIRE l ON p.id_labo = l.id_labo
LEFT JOIN ECRIT e ON p.id_publication = e.id_publication
LEFT JOIN AUTEUR a ON e.id_auteur = a.id_auteur
GROUP BY p.id_publication, p.titre, p.editeur, p.annee_publication, liv.isbn, p.statut, l.nom_labo;

-- Utilisation : SELECT * FROM vue_livres_complets WHERE annee_publication > 2000;

-- ============================================================================
-- VUE 4 : Tous les prix convertis en euros
-- Objectif : Voir tous les prix dans une devise unique (euro)
-- ============================================================================

CREATE VIEW vue_prix_euros AS
SELECT 
    p.id_publication,
    p.titre,
    p.type_publication,
    p.prix AS prix_original,
    p.code_devise,
    ROUND(p.prix * d.taux_vers_euro, 2) AS prix_euros,
    l.nom_labo AS laboratoire
FROM PUBLICATION p
JOIN DEVISE d ON p.code_devise = d.code_devise
JOIN LABORATOIRE l ON p.id_labo = l.id_labo;

-- Utilisation : SELECT * FROM vue_prix_euros WHERE prix_euros < 50;

-- ============================================================================
-- VUE 5 : Statistiques par laboratoire
-- Objectif : Vue d'ensemble de l'état des publications par labo
-- ============================================================================

CREATE VIEW vue_stats_labos AS
SELECT 
    l.nom_labo,
    COUNT(p.id_publication) AS total_publications,
    SUM(CASE WHEN p.statut = 'sur étagère' THEN 1 ELSE 0 END) AS disponibles,
    SUM(CASE WHEN p.statut = 'emprunté' THEN 1 ELSE 0 END) AS empruntes,
    SUM(CASE WHEN p.statut = 'perdu' THEN 1 ELSE 0 END) AS perdus,
    ROUND(SUM(p.prix * d.taux_vers_euro), 2) AS valeur_totale_euros
FROM LABORATOIRE l
LEFT JOIN PUBLICATION p ON l.id_labo = p.id_labo
LEFT JOIN DEVISE d ON p.code_devise = d.code_devise
GROUP BY l.id_labo, l.nom_labo;

-- Utilisation : SELECT * FROM vue_stats_labos ORDER BY total_publications DESC;

-- ============================================================================

-- Vérifier que les vues ont été créées
SHOW FULL TABLES WHERE Table_type = 'VIEW';

SELECT 'Vues créées avec succès!' AS Message;
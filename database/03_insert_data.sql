-- ============================================================================
-- PROJET 2 - LIBRARY DATABASE
-- Script d'alimentation de la base de données (DML)
-- Auteurs: Amani KRID, Youssef KHALFA
-- ============================================================================

-- ============================================================================
-- INSERTION DES DONNÉES DE RÉFÉRENCE
-- ============================================================================

-- Insertion des 3 devises avec leurs taux de change vers l'euro
INSERT INTO DEVISE (code_devise, nom_devise, taux_vers_euro) VALUES
('€', 'Euro', 1.0000),
('$', 'Dollar US', 0.9200),
('£', 'Livre Sterling', 1.1500);

-- Insertion des 4 laboratoires de l'ECL
INSERT INTO LABORATOIRE (nom_labo, adresse) VALUES
('Laboratoire de Mécanique', '36 Avenue Guy de Collongue, 69134 Écully'),
('Laboratoire d\'Informatique', '36 Avenue Guy de Collongue, 69134 Écully'),
('Laboratoire de Chimie', '36 Avenue Guy de Collongue, 69134 Écully'),
('Laboratoire de Mathématiques', '36 Avenue Guy de Collongue, 69134 Écully');

-- Insertion des 5 utilisateurs
INSERT INTO UTILISATEUR (email, nom, prenom) VALUES
('alice.dupont@ec-lyon.fr', 'Dupont', 'Alice'),
('bob.martin@ec-lyon.fr', 'Martin', 'Bob'),
('claire.bernard@ec-lyon.fr', 'Bernard', 'Claire'),
('david.petit@ec-lyon.fr', 'Petit', 'David'),
('emma.rousseau@ec-lyon.fr', 'Rousseau', 'Emma');

-- Insertion des droits d'accès par laboratoire
-- Alice : accès Mécanique + Informatique
-- Bob : accès TOUS les labos
-- Claire : accès Chimie uniquement
-- David : accès Informatique + Mathématiques
-- Emma : accès Mécanique
INSERT INTO A_DROIT_ACCES (email, id_labo) VALUES
('alice.dupont@ec-lyon.fr', 1),
('alice.dupont@ec-lyon.fr', 2),
('bob.martin@ec-lyon.fr', 1),
('bob.martin@ec-lyon.fr', 2),
('bob.martin@ec-lyon.fr', 3),
('bob.martin@ec-lyon.fr', 4),
('claire.bernard@ec-lyon.fr', 3),
('david.petit@ec-lyon.fr', 2),
('david.petit@ec-lyon.fr', 4),
('emma.rousseau@ec-lyon.fr', 1);

-- ============================================================================
-- INSERTION DES AUTEURS
-- ============================================================================

INSERT INTO AUTEUR (nom, prenom) VALUES
('Knuth', 'Donald'),
('Cormen', 'Thomas'),
('Leiserson', 'Charles'),
('Rivest', 'Ronald'),
('Stein', 'Clifford'),
('Tanenbaum', 'Andrew'),
('Silberschatz', 'Abraham'),
('Galvin', 'Peter'),
('Newton', 'Isaac'),
('Einstein', 'Albert'),
('Feynman', 'Richard'),
('Hawking', 'Stephen'),
('Curie', 'Marie'),
('Darwin', 'Charles'),
('Turing', 'Alan');

-- ============================================================================
-- INSERTION DES CATÉGORIES
-- ============================================================================

INSERT INTO CATEGORIE (nom_categorie) VALUES
('Algorithmique'),
('Programmation'),
('Systèmes d\'exploitation'),
('Base de données'),
('Intelligence artificielle'),
('Physique'),
('Mathématiques'),
('Chimie'),
('Biologie'),
('Informatique théorique');

-- ============================================================================
-- INSERTION DES MOTS-CLÉS
-- ============================================================================

INSERT INTO MOT_CLE (mot_cle) VALUES
('algorithme'),
('structure de données'),
('complexité'),
('système'),
('réseau'),
('concurrent'),
('physique quantique'),
('relativité'),
('chimie organique'),
('base de données'),
('SQL'),
('machine learning'),
('deep learning'),
('cryptographie'),
('compilation');

-- Insertion des centres d'intérêt des utilisateurs
INSERT INTO INTERESSE_PAR (email, id_mot_cle) VALUES
-- Alice intéressée par : algorithme, base de données, SQL
('alice.dupont@ec-lyon.fr', 1),
('alice.dupont@ec-lyon.fr', 10),
('alice.dupont@ec-lyon.fr', 11),
-- Bob intéressé par : machine learning, deep learning, algorithme
('bob.martin@ec-lyon.fr', 1),
('bob.martin@ec-lyon.fr', 12),
('bob.martin@ec-lyon.fr', 13),
-- Claire intéressée par : chimie organique
('claire.bernard@ec-lyon.fr', 9),
-- David intéressé par : physique quantique, relativité, compilation
('david.petit@ec-lyon.fr', 7),
('david.petit@ec-lyon.fr', 8),
('david.petit@ec-lyon.fr', 15);

-- ============================================================================
-- INSERTION DES PUBLICATIONS - LIVRES
-- ============================================================================

-- Livre 1: The Art of Computer Programming (Labo Informatique, disponible)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo)
VALUES ('The Art of Computer Programming Vol. 1', 'Addison-Wesley', '3rd Edition', 1997, 'Amazon', 65.00, '$', 'sur étagère', 'livre', 2);

INSERT INTO LIVRE (id_publication, isbn) VALUES (LAST_INSERT_ID(), '978-0-201-89683-1');

INSERT INTO ECRIT (id_auteur, id_publication) VALUES (1, LAST_INSERT_ID());

INSERT INTO APPARTIENT_A (id_publication, id_categorie) VALUES 
(LAST_INSERT_ID(), 1),  -- Algorithmique
(LAST_INSERT_ID(), 2);  -- Programmation

INSERT INTO DECRIT_PAR (id_publication, id_mot_cle) VALUES
(LAST_INSERT_ID(), 1),  -- algorithme
(LAST_INSERT_ID(), 2);  -- structure de données

-- Livre 2: Introduction to Algorithms (Labo Informatique, emprunté par Alice)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo, email_emprunteur)
VALUES ('Introduction to Algorithms', 'MIT Press', '3rd Edition', 2009, 'MIT Press Store', 85.00, '$', 'emprunté', 'livre', 2, 'alice.dupont@ec-lyon.fr');

INSERT INTO LIVRE (id_publication, isbn) VALUES (LAST_INSERT_ID(), '978-0-262-03384-8');

-- 4 auteurs pour ce livre (maximum permis)
INSERT INTO ECRIT (id_auteur, id_publication) VALUES 
(2, LAST_INSERT_ID()),
(3, LAST_INSERT_ID()),
(4, LAST_INSERT_ID()),
(5, LAST_INSERT_ID());

INSERT INTO APPARTIENT_A (id_publication, id_categorie) VALUES 
(LAST_INSERT_ID(), 1),  -- Algorithmique
(LAST_INSERT_ID(), 2),  -- Programmation
(LAST_INSERT_ID(), 10); -- Informatique théorique

INSERT INTO DECRIT_PAR (id_publication, id_mot_cle) VALUES
(LAST_INSERT_ID(), 1),  -- algorithme
(LAST_INSERT_ID(), 2),  -- structure de données
(LAST_INSERT_ID(), 3);  -- complexité

-- Livre 3: Operating Systems Concepts (Labo Informatique, disponible)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo)
VALUES ('Operating Systems Concepts', 'Wiley', '10th Edition', 2018, 'Wiley Direct', 120.00, '€', 'sur étagère', 'livre', 2);

INSERT INTO LIVRE (id_publication, isbn) VALUES (LAST_INSERT_ID(), '978-1-119-32091-3');

INSERT INTO ECRIT (id_auteur, id_publication) VALUES 
(7, LAST_INSERT_ID()),
(8, LAST_INSERT_ID());

INSERT INTO APPARTIENT_A (id_publication, id_categorie) VALUES 
(LAST_INSERT_ID(), 3);  -- Systèmes d'exploitation

INSERT INTO DECRIT_PAR (id_publication, id_mot_cle) VALUES
(LAST_INSERT_ID(), 4),  -- système
(LAST_INSERT_ID(), 6);  -- concurrent

-- Livre 4: Principia Mathematica (Labo Mécanique, disponible, prix en livres sterling)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo)
VALUES ('Philosophiæ Naturalis Principia Mathematica', 'Cambridge University Press', 'Reprint', 1687, 'Cambridge Store', 45.00, '£', 'sur étagère', 'livre', 1);

INSERT INTO LIVRE (id_publication, isbn) VALUES (LAST_INSERT_ID(), '978-0-521-07647-6');

INSERT INTO ECRIT (id_auteur, id_publication) VALUES (9, LAST_INSERT_ID());

INSERT INTO APPARTIENT_A (id_publication, id_categorie) VALUES 
(LAST_INSERT_ID(), 6),  -- Physique
(LAST_INSERT_ID(), 7);  -- Mathématiques

INSERT INTO DECRIT_PAR (id_publication, id_mot_cle) VALUES
(LAST_INSERT_ID(), 7);  -- physique quantique

-- Livre 5: A Brief History of Time (Labo Mécanique, PERDU)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo)
VALUES ('A Brief History of Time', 'Bantam Books', '1st Edition', 1988, 'Fnac', 25.00, '€', 'perdu', 'livre', 1);

INSERT INTO LIVRE (id_publication, isbn) VALUES (LAST_INSERT_ID(), '978-0-553-10953-5');

INSERT INTO ECRIT (id_auteur, id_publication) VALUES (12, LAST_INSERT_ID());

INSERT INTO APPARTIENT_A (id_publication, id_categorie) VALUES 
(LAST_INSERT_ID(), 6);  -- Physique

INSERT INTO DECRIT_PAR (id_publication, id_mot_cle) VALUES
(LAST_INSERT_ID(), 7),  -- physique quantique
(LAST_INSERT_ID(), 8);  -- relativité

-- Livre 6: Modern Operating Systems (Labo Mathématiques, disponible)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo)
VALUES ('Modern Operating Systems', 'Pearson', '4th Edition', 2014, 'Pearson Store', 95.00, '$', 'sur étagère', 'livre', 4);

INSERT INTO LIVRE (id_publication, isbn) VALUES (LAST_INSERT_ID(), '978-0-13-359162-0');

INSERT INTO ECRIT (id_auteur, id_publication) VALUES (6, LAST_INSERT_ID());

INSERT INTO APPARTIENT_A (id_publication, id_categorie) VALUES 
(LAST_INSERT_ID(), 3),  -- Systèmes d'exploitation
(LAST_INSERT_ID(), 2);  -- Programmation

INSERT INTO DECRIT_PAR (id_publication, id_mot_cle) VALUES
(LAST_INSERT_ID(), 4),  -- système
(LAST_INSERT_ID(), 5);  -- réseau

-- ============================================================================
-- INSERTION DES PUBLICATIONS - PÉRIODIQUES
-- ============================================================================

-- Périodique 1: Nature (Labo Chimie)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo)
VALUES ('Nature', 'Nature Publishing Group', 'Vol. 580', 2020, 'Nature Direct', 45.00, '€', 'sur étagère', 'périodique', 3);

INSERT INTO PERIODIQUE (id_publication, numero_volume) VALUES (LAST_INSERT_ID(), 'Vol. 580, Issue 7801');

INSERT INTO ECRIT (id_auteur, id_publication) VALUES (13, LAST_INSERT_ID());

INSERT INTO DECRIT_PAR (id_publication, id_mot_cle) VALUES
(LAST_INSERT_ID(), 9);  -- chimie organique

-- Périodique 2: Communications of the ACM (Labo Informatique)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo)
VALUES ('Communications of the ACM', 'ACM', 'Vol. 65, No. 3', 2022, 'ACM Digital Library', 30.00, '$', 'sur étagère', 'périodique', 2);

INSERT INTO PERIODIQUE (id_publication, numero_volume) VALUES (LAST_INSERT_ID(), 'Vol. 65, No. 3');

INSERT INTO ECRIT (id_auteur, id_publication) VALUES (1, LAST_INSERT_ID());

INSERT INTO DECRIT_PAR (id_publication, id_mot_cle) VALUES
(LAST_INSERT_ID(), 12),  -- machine learning
(LAST_INSERT_ID(), 13);  -- deep learning

-- ============================================================================
-- INSERTION DES PUBLICATIONS - RAPPORTS INTERNES
-- ============================================================================

-- Rapport 1: Thèse ECL (Labo Informatique, exactement 1 auteur)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo)
VALUES ('Optimisation des algorithmes de tri distribués', 'ECL', NULL, 2021, NULL, 0.00, '€', 'sur étagère', 'rapport', 2);

INSERT INTO RAPPORT_INTERNE (id_publication, type_rapport, numero_identification) 
VALUES (LAST_INSERT_ID(), 'thèse ECL', 'TH-2021-001');

-- Une thèse a exactement 1 auteur
INSERT INTO ECRIT (id_auteur, id_publication) VALUES (15, LAST_INSERT_ID());

INSERT INTO DECRIT_PAR (id_publication, id_mot_cle) VALUES
(LAST_INSERT_ID(), 1),  -- algorithme
(LAST_INSERT_ID(), 3);  -- complexité

-- Rapport 2: Rapport scientifique (Labo Mécanique, plusieurs auteurs possibles)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo)
VALUES ('Étude de la mécanique des fluides dans les turbines', 'ECL', NULL, 2023, NULL, 0.00, '€', 'sur étagère', 'rapport', 1);

INSERT INTO RAPPORT_INTERNE (id_publication, type_rapport, numero_identification) 
VALUES (LAST_INSERT_ID(), 'rapport scientifique', 'RS-2023-005');

-- Un rapport scientifique peut avoir plusieurs auteurs
INSERT INTO ECRIT (id_auteur, id_publication) VALUES 
(9, LAST_INSERT_ID()),
(11, LAST_INSERT_ID());

-- Rapport 3: Thèse ECL (Labo Chimie, exactement 1 auteur)
INSERT INTO PUBLICATION (titre, editeur, edition, annee_publication, nom_librairie, prix, code_devise, statut, type_publication, id_labo)
VALUES ('Synthèse de nouveaux polymères biodégradables', 'ECL', NULL, 2022, NULL, 0.00, '€', 'sur étagère', 'rapport', 3);

INSERT INTO RAPPORT_INTERNE (id_publication, type_rapport, numero_identification) 
VALUES (LAST_INSERT_ID(), 'thèse ECL', 'TH-2022-003');

INSERT INTO ECRIT (id_auteur, id_publication) VALUES (13, LAST_INSERT_ID());

INSERT INTO DECRIT_PAR (id_publication, id_mot_cle) VALUES
(LAST_INSERT_ID(), 9);  -- chimie organique

-- ============================================================================
-- INSERTION DES PROPOSITIONS D'ACHAT
-- ============================================================================

INSERT INTO PROPOSITION_ACHAT (date_proposition, titre, auteurs, editeur, annee, type_publication, informations_complementaires, email_utilisateur)
VALUES 
('2024-01-15', 'Deep Learning', 'Ian Goodfellow, Yoshua Bengio, Aaron Courville', 'MIT Press', 2016, 'livre', 
'Livre de référence en deep learning, très utile pour nos recherches', 'bob.martin@ec-lyon.fr'),

('2024-02-20', 'The Feynman Lectures on Physics', 'Richard Feynman', 'Addison-Wesley', 2011, 'livre', 
'Collection complète des cours de Feynman', 'david.petit@ec-lyon.fr'),

('2024-03-10', 'Science', 'AAAS', 'AAAS', 2024, 'périodique', 
'Abonnement au journal Science, vol. 383', 'claire.bernard@ec-lyon.fr');


-- ============================================================================

-- Affichage des statistiques après insertion
SELECT 'Données insérées avec succès!' AS Message;

SELECT 
    (SELECT COUNT(*) FROM DEVISE) AS Devises,
    (SELECT COUNT(*) FROM LABORATOIRE) AS Laboratoires,
    (SELECT COUNT(*) FROM UTILISATEUR) AS Utilisateurs,
    (SELECT COUNT(*) FROM PUBLICATION) AS Publications,
    (SELECT COUNT(*) FROM LIVRE) AS Livres,
    (SELECT COUNT(*) FROM PERIODIQUE) AS Periodiques,
    (SELECT COUNT(*) FROM RAPPORT_INTERNE) AS Rapports,
    (SELECT COUNT(*) FROM AUTEUR) AS Auteurs,
    (SELECT COUNT(*) FROM CATEGORIE) AS Categories,
    (SELECT COUNT(*) FROM MOT_CLE) AS MotsCles,
    (SELECT COUNT(*) FROM PROPOSITION_ACHAT) AS Propositions;
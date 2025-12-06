-- ============================================================================
-- PROJET 2 - LIBRARY DATABASE
-- Script de création de la base de données (DDL)
-- Auteurs:  Amani KRID , Youssef KHALFA
-- ============================================================================

-- Suppression des tables existantes (ordre inverse des dépendances)
DROP TABLE IF EXISTS DECRIT_PAR;
DROP TABLE IF EXISTS INTERESSE_PAR;
DROP TABLE IF EXISTS A_DROIT_ACCES;
DROP TABLE IF EXISTS APPARTIENT_A;
DROP TABLE IF EXISTS ECRIT;
DROP TABLE IF EXISTS PROPOSITION_ACHAT;
DROP TABLE IF EXISTS RAPPORT_INTERNE;
DROP TABLE IF EXISTS PERIODIQUE;
DROP TABLE IF EXISTS LIVRE;
DROP TABLE IF EXISTS PUBLICATION;
DROP TABLE IF EXISTS MOT_CLE;
DROP TABLE IF EXISTS CATEGORIE;
DROP TABLE IF EXISTS AUTEUR;
DROP TABLE IF EXISTS UTILISATEUR;
DROP TABLE IF EXISTS LABORATOIRE;
DROP TABLE IF EXISTS DEVISE;

-- ============================================================================
-- TABLES DE RÉFÉRENCE
-- ============================================================================

-- Table DEVISE : gestion des devises et taux de change vers l'euro
CREATE TABLE DEVISE (
    code_devise VARCHAR(3) PRIMARY KEY,
    nom_devise VARCHAR(20) NOT NULL,
    taux_vers_euro DECIMAL(10,4) NOT NULL,
    CONSTRAINT chk_devise_code CHECK (code_devise IN ('£', '$', '€')),
    CONSTRAINT chk_taux_positif CHECK (taux_vers_euro > 0)
);

-- Table LABORATOIRE : laboratoires de l'ECL
CREATE TABLE LABORATOIRE (
    id_labo INT PRIMARY KEY AUTO_INCREMENT,
    nom_labo VARCHAR(100) NOT NULL UNIQUE,
    adresse VARCHAR(200)
);

-- Table UTILISATEUR : utilisateurs du système (identifiés par email)
CREATE TABLE UTILISATEUR (
    email VARCHAR(100) PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    CONSTRAINT chk_email_format CHECK (email LIKE '%@%')
);

-- ============================================================================
-- TABLES PUBLICATIONS (HIÉRARCHIE ISA)
-- ============================================================================

-- Table PUBLICATION : super-type pour toutes les publications
CREATE TABLE PUBLICATION (
    id_publication INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(200) NOT NULL,
    editeur VARCHAR(100),
    edition VARCHAR(50),
    annee_publication INT,
    nom_librairie VARCHAR(100),
    prix DECIMAL(10,2) NOT NULL,
    statut VARCHAR(20) NOT NULL DEFAULT 'sur étagère',
    type_publication VARCHAR(20) NOT NULL,
    id_labo INT NOT NULL,
    code_devise VARCHAR(3) NOT NULL,
    email_emprunteur VARCHAR(100) NULL,
    
    -- Clés étrangères
    CONSTRAINT fk_pub_labo FOREIGN KEY (id_labo) 
        REFERENCES LABORATOIRE(id_labo) ON DELETE RESTRICT,
    CONSTRAINT fk_pub_devise FOREIGN KEY (code_devise) 
        REFERENCES DEVISE(code_devise) ON DELETE RESTRICT,
    CONSTRAINT fk_pub_emprunteur FOREIGN KEY (email_emprunteur) 
        REFERENCES UTILISATEUR(email) ON DELETE SET NULL,
    
    -- Contraintes métier
    CONSTRAINT chk_prix_positif CHECK (prix >= 0),
    CONSTRAINT chk_statut CHECK (statut IN ('sur étagère', 'emprunté', 'perdu', 'à acheter')),
    CONSTRAINT chk_type_pub CHECK (type_publication IN ('livre', 'périodique', 'rapport')),
    CONSTRAINT chk_annee CHECK (annee_publication BETWEEN 1000 AND 2100)
);

-- Table LIVRE : spécialisation pour les livres réguliers
CREATE TABLE LIVRE (
    id_publication INT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL,
    
    CONSTRAINT fk_livre_pub FOREIGN KEY (id_publication) 
        REFERENCES PUBLICATION(id_publication) ON DELETE CASCADE
);

-- Table PERIODIQUE : spécialisation pour les périodiques
CREATE TABLE PERIODIQUE (
    id_publication INT PRIMARY KEY,
    numero_volume VARCHAR(20) NOT NULL,
    
    CONSTRAINT fk_periodique_pub FOREIGN KEY (id_publication) 
        REFERENCES PUBLICATION(id_publication) ON DELETE CASCADE
);

-- Table RAPPORT_INTERNE : spécialisation pour les rapports internes (thèses ECL et rapports scientifiques)
CREATE TABLE RAPPORT_INTERNE (
    id_publication INT PRIMARY KEY,
    type_rapport VARCHAR(20) NOT NULL,
    numero_identification VARCHAR(50) NOT NULL,
    
    CONSTRAINT fk_rapport_pub FOREIGN KEY (id_publication) 
        REFERENCES PUBLICATION(id_publication) ON DELETE CASCADE,
    CONSTRAINT chk_type_rapport CHECK (type_rapport IN ('thèse ECL', 'rapport scientifique'))
);

-- ============================================================================
-- TABLES ENTITÉS MÉTIER
-- ============================================================================

-- Table AUTEUR : auteurs des publications
CREATE TABLE AUTEUR (
    id_auteur INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL
);

-- Table CATEGORIE : catégories thématiques des livres (max 4 par livre)
CREATE TABLE CATEGORIE (
    id_categorie INT PRIMARY KEY AUTO_INCREMENT,
    nom_categorie VARCHAR(100) NOT NULL UNIQUE
);

-- Table MOT_CLE : mots-clés pour publications ET utilisateurs (centres d'intérêt)
CREATE TABLE MOT_CLE (
    id_mot_cle INT PRIMARY KEY AUTO_INCREMENT,
    mot_cle VARCHAR(50) NOT NULL UNIQUE
);

-- Table PROPOSITION_ACHAT : propositions d'achat par les utilisateurs
CREATE TABLE PROPOSITION_ACHAT (
    id_proposition INT PRIMARY KEY AUTO_INCREMENT,
    date_proposition DATE NOT NULL,
    titre VARCHAR(200) NOT NULL,
    auteurs VARCHAR(200),
    editeur VARCHAR(100),
    annee INT,
    type_publication VARCHAR(20),
    informations_complementaires TEXT,
    email_utilisateur VARCHAR(100) NOT NULL,
    
    CONSTRAINT fk_prop_utilisateur FOREIGN KEY (email_utilisateur) 
        REFERENCES UTILISATEUR(email) ON DELETE CASCADE
);

-- ============================================================================
-- TABLES D'ASSOCIATION (RELATIONS N-N)
-- ============================================================================

-- Table ECRIT : relation AUTEUR - PUBLICATION (1-4 auteurs par livre, 1 auteur par thèse)
CREATE TABLE ECRIT (
    id_auteur INT,
    id_publication INT,
    
    PRIMARY KEY (id_auteur, id_publication),
    CONSTRAINT fk_ecrit_auteur FOREIGN KEY (id_auteur) 
        REFERENCES AUTEUR(id_auteur) ON DELETE CASCADE,
    CONSTRAINT fk_ecrit_pub FOREIGN KEY (id_publication) 
        REFERENCES PUBLICATION(id_publication) ON DELETE CASCADE
);

-- Table APPARTIENT_A : relation LIVRE - CATEGORIE (max 4 catégories par livre)
CREATE TABLE APPARTIENT_A (
    id_publication INT,
    id_categorie INT,
    
    PRIMARY KEY (id_publication, id_categorie),
    CONSTRAINT fk_appartient_livre FOREIGN KEY (id_publication) 
        REFERENCES LIVRE(id_publication) ON DELETE CASCADE,
    CONSTRAINT fk_appartient_cat FOREIGN KEY (id_categorie) 
        REFERENCES CATEGORIE(id_categorie) ON DELETE CASCADE
);

-- Table A_DROIT_ACCES : relation UTILISATEUR - LABORATOIRE (droits d'accès par labo)
CREATE TABLE A_DROIT_ACCES (
    email VARCHAR(100),
    id_labo INT,
    
    PRIMARY KEY (email, id_labo),
    CONSTRAINT fk_acces_user FOREIGN KEY (email) 
        REFERENCES UTILISATEUR(email) ON DELETE CASCADE,
    CONSTRAINT fk_acces_labo FOREIGN KEY (id_labo) 
        REFERENCES LABORATOIRE(id_labo) ON DELETE CASCADE
);

-- Table INTERESSE_PAR : relation UTILISATEUR - MOT_CLE (centres d'intérêt pour notifications)
CREATE TABLE INTERESSE_PAR (
    email VARCHAR(100),
    id_mot_cle INT,
    
    PRIMARY KEY (email, id_mot_cle),
    CONSTRAINT fk_interesse_user FOREIGN KEY (email) 
        REFERENCES UTILISATEUR(email) ON DELETE CASCADE,
    CONSTRAINT fk_interesse_mc FOREIGN KEY (id_mot_cle) 
        REFERENCES MOT_CLE(id_mot_cle) ON DELETE CASCADE
);

-- Table DECRIT_PAR : relation PUBLICATION - MOT_CLE (mots-clés descriptifs)
CREATE TABLE DECRIT_PAR (
    id_publication INT,
    id_mot_cle INT,
    
    PRIMARY KEY (id_publication, id_mot_cle),
    CONSTRAINT fk_decrit_pub FOREIGN KEY (id_publication) 
        REFERENCES PUBLICATION(id_publication) ON DELETE CASCADE,
    CONSTRAINT fk_decrit_mc FOREIGN KEY (id_mot_cle) 
        REFERENCES MOT_CLE(id_mot_cle) ON DELETE CASCADE
);

-- ============================================================================
-- INDEX POUR OPTIMISATION DES REQUÊTES
-- ============================================================================

-- Index sur colonnes fréquemment utilisées dans les recherches
CREATE INDEX idx_pub_titre ON PUBLICATION(titre);
CREATE INDEX idx_pub_annee ON PUBLICATION(annee_publication);
CREATE INDEX idx_pub_statut ON PUBLICATION(statut);
CREATE INDEX idx_pub_labo ON PUBLICATION(id_labo);
CREATE INDEX idx_livre_isbn ON LIVRE(isbn);
CREATE INDEX idx_auteur_nom ON AUTEUR(nom, prenom);
CREATE INDEX idx_cat_nom ON CATEGORIE(nom_categorie);
CREATE INDEX idx_mc_mot ON MOT_CLE(mot_cle);

-- ============================================================================
-- TRIGGERS POUR CONTRAINTES MÉTIER COMPLEXES
-- ============================================================================

-- Trigger 1: Cohérence statut-emprunteur lors de l'insertion
-- Si statut='emprunté' alors email_emprunteur doit être renseigné, et inversement
DELIMITER //
CREATE TRIGGER trg_check_emprunt_coherence 
BEFORE INSERT ON PUBLICATION
FOR EACH ROW
BEGIN
    IF NEW.statut = 'emprunté' AND NEW.email_emprunteur IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Si statut=emprunté, email_emprunteur doit être renseigné';
    END IF;
    IF NEW.statut != 'emprunté' AND NEW.email_emprunteur IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Si statut!=emprunté, email_emprunteur doit être NULL';
    END IF;
END//

-- Trigger 2: Cohérence statut-emprunteur lors de la mise à jour
CREATE TRIGGER trg_check_emprunt_coherence_update 
BEFORE UPDATE ON PUBLICATION
FOR EACH ROW
BEGIN
    IF NEW.statut = 'emprunté' AND NEW.email_emprunteur IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Si statut=emprunté, email_emprunteur doit être renseigné';
    END IF;
    IF NEW.statut != 'emprunté' AND NEW.email_emprunteur IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Si statut!=emprunté, email_emprunteur doit être NULL';
    END IF;
END//
DELIMITER ;

-- Trigger 3: Vérifier que l'emprunteur a les droits d'accès au laboratoire propriétaire
DELIMITER //
CREATE TRIGGER trg_check_droits_emprunt 
BEFORE UPDATE ON PUBLICATION
FOR EACH ROW
BEGIN
    DECLARE nb_droits INT;
    IF NEW.email_emprunteur IS NOT NULL THEN
        SELECT COUNT(*) INTO nb_droits 
        FROM A_DROIT_ACCES 
        WHERE email = NEW.email_emprunteur AND id_labo = NEW.id_labo;
        
        IF nb_droits = 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Utilisateur n\'a pas les droits sur ce laboratoire';
        END IF;
    END IF;
END//
DELIMITER ;

-- Trigger 4: Vérifier le nombre maximum d'auteurs pour un livre (4 auteurs max)
DELIMITER //
CREATE TRIGGER trg_check_max_auteurs_livre 
BEFORE INSERT ON ECRIT
FOR EACH ROW
BEGIN
    DECLARE nb_auteurs INT;
    DECLARE est_livre BOOLEAN;
    
    -- Compter le nombre d'auteurs existants pour cette publication
    SELECT COUNT(*) INTO nb_auteurs 
    FROM ECRIT 
    WHERE id_publication = NEW.id_publication;
    
    -- Vérifier si c'est un livre
    SELECT EXISTS(SELECT 1 FROM LIVRE WHERE id_publication = NEW.id_publication) 
    INTO est_livre;
    
    -- Un livre ne peut avoir plus de 4 auteurs
    IF est_livre AND nb_auteurs >= 4 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Un livre ne peut avoir plus de 4 auteurs';
    END IF;
END//
DELIMITER ;

-- Trigger 5: Vérifier qu'une thèse ECL a exactement 1 auteur
DELIMITER //
CREATE TRIGGER trg_check_these_un_auteur 
BEFORE INSERT ON ECRIT
FOR EACH ROW
BEGIN
    DECLARE nb_auteurs INT;
    DECLARE est_these BOOLEAN;
    
    -- Compter le nombre d'auteurs existants
    SELECT COUNT(*) INTO nb_auteurs 
    FROM ECRIT 
    WHERE id_publication = NEW.id_publication;
    
    -- Vérifier si c'est une thèse ECL
    SELECT EXISTS(
        SELECT 1 FROM RAPPORT_INTERNE 
        WHERE id_publication = NEW.id_publication 
        AND type_rapport = 'thèse ECL'
    ) INTO est_these;
    
    -- Une thèse ne peut avoir qu'un seul auteur
    IF est_these AND nb_auteurs >= 1 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Une thèse ne peut avoir qu\'un seul auteur';
    END IF;
END//
DELIMITER ;

-- Trigger 6: Vérifier le nombre maximum de catégories pour un livre (4 catégories max)
DELIMITER //
CREATE TRIGGER trg_check_max_categories 
BEFORE INSERT ON APPARTIENT_A
FOR EACH ROW
BEGIN
    DECLARE nb_categories INT;
    
    -- Compter le nombre de catégories existantes pour ce livre
    SELECT COUNT(*) INTO nb_categories 
    FROM APPARTIENT_A 
    WHERE id_publication = NEW.id_publication;
    
    -- Un livre ne peut appartenir à plus de 4 catégories
    IF nb_categories >= 4 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Un livre ne peut appartenir à plus de 4 catégories';
    END IF;
END//
DELIMITER ;

-- ============================================================================

SELECT 'Base de données créée avec succès!' AS Message;
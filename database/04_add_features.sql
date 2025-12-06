-- ============================================================================
-- 04_add_features.sql
-- Ajout des fonctionnalités : Admin, Gestion des pertes, Propositions
-- ============================================================================

USE bibliotheque_ecl;

-- ============================================================================
-- 1. AJOUT COLONNE ROLE DANS UTILISATEUR
-- ============================================================================

ALTER TABLE UTILISATEUR 
ADD COLUMN IF NOT EXISTS role ENUM('utilisateur', 'admin') DEFAULT 'utilisateur';

-- Mettre tous les utilisateurs existants en "utilisateur"
UPDATE UTILISATEUR SET role = 'utilisateur' WHERE role IS NULL;

-- ============================================================================
-- 2. CRÉATION COMPTE ADMIN
-- ============================================================================

INSERT INTO UTILISATEUR (email, prenom, nom, role) 
VALUES ('admin@ecl.fr', 'Admin', 'Bibliothèque', 'admin')
ON DUPLICATE KEY UPDATE 
    prenom = 'Admin', 
    nom = 'Bibliothèque', 
    role = 'admin';

-- Donner les droits d'accès à tous les labos pour l'admin
INSERT IGNORE INTO A_DROIT_ACCES (email, id_labo)
SELECT 'admin@ecl.fr', id_labo FROM LABORATOIRE;

-- ============================================================================
-- 3. CRÉATION TABLE DECLARATION_PERTE
-- ============================================================================

CREATE TABLE IF NOT EXISTS DECLARATION_PERTE (
    id_declaration INT AUTO_INCREMENT PRIMARY KEY,
    id_publication INT NOT NULL,
    email_admin VARCHAR(100) COLLATE utf8mb4_0900_ai_ci NOT NULL,
    email_responsable VARCHAR(100) COLLATE utf8mb4_0900_ai_ci,
    date_declaration DATE NOT NULL,
    motif TEXT,
    cout_remplacement DECIMAL(10,2),
    statut_resolution ENUM('perdu', 'retrouvé', 'remplacé') DEFAULT 'perdu',
    date_resolution DATE,
    commentaire_resolution TEXT,
    
    FOREIGN KEY (id_publication) REFERENCES PUBLICATION(id_publication) ON DELETE CASCADE,
    INDEX idx_publication (id_publication),
    INDEX idx_statut (statut_resolution)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================================
-- 4. VÉRIFICATIONS FINALES
-- ============================================================================

-- Vérifier la structure de UTILISATEUR
SELECT 'Structure UTILISATEUR :' AS info;
DESCRIBE UTILISATEUR;

-- Vérifier la structure de DECLARATION_PERTE
SELECT 'Structure DECLARATION_PERTE :' AS info;
DESCRIBE DECLARATION_PERTE;

-- Vérifier l'admin
SELECT 'Compte admin :' AS info;
SELECT email, CONCAT(prenom, ' ', nom) AS nom, role 
FROM UTILISATEUR 
WHERE role = 'admin';

-- Statistiques
SELECT 'Statistiques :' AS info;
SELECT 
    (SELECT COUNT(*) FROM UTILISATEUR) AS total_utilisateurs,
    (SELECT COUNT(*) FROM UTILISATEUR WHERE role = 'admin') AS total_admins,
    (SELECT COUNT(*) FROM DECLARATION_PERTE) AS total_pertes,
    (SELECT COUNT(*) FROM PROPOSITION_ACHAT) AS total_propositions;
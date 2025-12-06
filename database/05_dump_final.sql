-- MySQL dump 10.13  Distrib 8.0.44, for Linux (x86_64)
--
-- Host: localhost    Database: bibliotheque_ecl
-- ------------------------------------------------------
-- Server version	8.0.44-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `bibliotheque_ecl`
--

/*!40000 DROP DATABASE IF EXISTS `bibliotheque_ecl`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `bibliotheque_ecl` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `bibliotheque_ecl`;

--
-- Table structure for table `APPARTIENT_A`
--

DROP TABLE IF EXISTS `APPARTIENT_A`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `APPARTIENT_A` (
  `id_publication` int NOT NULL,
  `id_categorie` int NOT NULL,
  PRIMARY KEY (`id_publication`,`id_categorie`),
  KEY `fk_appartient_cat` (`id_categorie`),
  CONSTRAINT `fk_appartient_cat` FOREIGN KEY (`id_categorie`) REFERENCES `CATEGORIE` (`id_categorie`) ON DELETE CASCADE,
  CONSTRAINT `fk_appartient_livre` FOREIGN KEY (`id_publication`) REFERENCES `LIVRE` (`id_publication`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `APPARTIENT_A`
--

LOCK TABLES `APPARTIENT_A` WRITE;
/*!40000 ALTER TABLE `APPARTIENT_A` DISABLE KEYS */;
INSERT INTO `APPARTIENT_A` (`id_publication`, `id_categorie`) VALUES (1,1),(2,1),(1,2),(2,2),(6,2),(3,3),(6,3),(4,6),(5,6),(4,7),(2,10);
/*!40000 ALTER TABLE `APPARTIENT_A` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_max_categories` BEFORE INSERT ON `APPARTIENT_A` FOR EACH ROW BEGIN
    DECLARE nb_categories INT;
    
    
    SELECT COUNT(*) INTO nb_categories 
    FROM APPARTIENT_A 
    WHERE id_publication = NEW.id_publication;
    
    
    IF nb_categories >= 4 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Un livre ne peut appartenir à plus de 4 catégories';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `AUTEUR`
--

DROP TABLE IF EXISTS `AUTEUR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AUTEUR` (
  `id_auteur` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prenom` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_auteur`),
  KEY `idx_auteur_nom` (`nom`,`prenom`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTEUR`
--

LOCK TABLES `AUTEUR` WRITE;
/*!40000 ALTER TABLE `AUTEUR` DISABLE KEYS */;
INSERT INTO `AUTEUR` (`id_auteur`, `nom`, `prenom`) VALUES (2,'Cormen','Thomas'),(13,'Curie','Marie'),(14,'Darwin','Charles'),(10,'Einstein','Albert'),(11,'Feynman','Richard'),(8,'Galvin','Peter'),(16,'Gamma','Erich'),(12,'Hawking','Stephen'),(17,'Helm','Richard'),(18,'Johnson','Ralph'),(1,'Knuth','Donald'),(3,'Leiserson','Charles'),(9,'Newton','Isaac'),(4,'Rivest','Ronald'),(7,'Silberschatz','Abraham'),(5,'Stein','Clifford'),(6,'Tanenbaum','Andrew'),(15,'Turing','Alan'),(19,'Vlissides','John');
/*!40000 ALTER TABLE `AUTEUR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `A_DROIT_ACCES`
--

DROP TABLE IF EXISTS `A_DROIT_ACCES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `A_DROIT_ACCES` (
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_labo` int NOT NULL,
  PRIMARY KEY (`email`,`id_labo`),
  KEY `fk_acces_labo` (`id_labo`),
  CONSTRAINT `fk_acces_labo` FOREIGN KEY (`id_labo`) REFERENCES `LABORATOIRE` (`id_labo`) ON DELETE CASCADE,
  CONSTRAINT `fk_acces_user` FOREIGN KEY (`email`) REFERENCES `UTILISATEUR` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `A_DROIT_ACCES`
--

LOCK TABLES `A_DROIT_ACCES` WRITE;
/*!40000 ALTER TABLE `A_DROIT_ACCES` DISABLE KEYS */;
INSERT INTO `A_DROIT_ACCES` (`email`, `id_labo`) VALUES ('admin@ecl.fr',1),('alice.dupont@ec-lyon.fr',1),('bob.martin@ec-lyon.fr',1),('emma.rousseau@ec-lyon.fr',1),('admin@ecl.fr',2),('alice.dupont@ec-lyon.fr',2),('amani.krid@ec-lyon.fr',2),('bob.martin@ec-lyon.fr',2),('david.petit@ec-lyon.fr',2),('youssef.khalfa@ec-lyon.fr',2),('admin@ecl.fr',3),('bob.martin@ec-lyon.fr',3),('claire.bernard@ec-lyon.fr',3),('admin@ecl.fr',4),('bob.martin@ec-lyon.fr',4),('david.petit@ec-lyon.fr',4),('youssef.khalfa@ec-lyon.fr',4);
/*!40000 ALTER TABLE `A_DROIT_ACCES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CATEGORIE`
--

DROP TABLE IF EXISTS `CATEGORIE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CATEGORIE` (
  `id_categorie` int NOT NULL AUTO_INCREMENT,
  `nom_categorie` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_categorie`),
  UNIQUE KEY `nom_categorie` (`nom_categorie`),
  KEY `idx_cat_nom` (`nom_categorie`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CATEGORIE`
--

LOCK TABLES `CATEGORIE` WRITE;
/*!40000 ALTER TABLE `CATEGORIE` DISABLE KEYS */;
INSERT INTO `CATEGORIE` (`id_categorie`, `nom_categorie`) VALUES (1,'Algorithmique'),(4,'Base de données'),(9,'Biologie'),(8,'Chimie'),(10,'Informatique théorique'),(5,'Intelligence artificielle'),(7,'Mathématiques'),(6,'Physique'),(2,'Programmation'),(3,'Systèmes d\'exploitation');
/*!40000 ALTER TABLE `CATEGORIE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DECLARATION_PERTE`
--

DROP TABLE IF EXISTS `DECLARATION_PERTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DECLARATION_PERTE` (
  `id_declaration` int NOT NULL AUTO_INCREMENT,
  `id_publication` int NOT NULL,
  `email_admin` varchar(100) NOT NULL,
  `email_responsable` varchar(100) DEFAULT NULL,
  `date_declaration` date NOT NULL,
  `motif` text,
  `cout_remplacement` decimal(10,2) DEFAULT NULL,
  `statut_resolution` enum('perdu','retrouvé','remplacé') DEFAULT 'perdu',
  `date_resolution` date DEFAULT NULL,
  `commentaire_resolution` text,
  PRIMARY KEY (`id_declaration`),
  KEY `idx_publication` (`id_publication`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DECLARATION_PERTE`
--

LOCK TABLES `DECLARATION_PERTE` WRITE;
/*!40000 ALTER TABLE `DECLARATION_PERTE` DISABLE KEYS */;
INSERT INTO `DECLARATION_PERTE` (`id_declaration`, `id_publication`, `email_admin`, `email_responsable`, `date_declaration`, `motif`, `cout_remplacement`, `statut_resolution`, `date_resolution`, `commentaire_resolution`) VALUES (1,11,'admin@ecl.fr','claire.bernard@ec-lyon.fr','2025-12-04','perdue',0.00,'retrouvé','2025-12-05',NULL),(2,8,'admin@ecl.fr','alice.dupont@ec-lyon.fr','2025-12-05','no rendue ',30.00,'retrouvé','2025-12-05',NULL),(3,16,'admin@ecl.fr','bob.martin@ec-lyon.fr','2025-12-05','n\'a pas était retourner depuis 3 mois',54.99,'retrouvé','2025-12-05',NULL);
/*!40000 ALTER TABLE `DECLARATION_PERTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DECRIT_PAR`
--

DROP TABLE IF EXISTS `DECRIT_PAR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DECRIT_PAR` (
  `id_publication` int NOT NULL,
  `id_mot_cle` int NOT NULL,
  PRIMARY KEY (`id_publication`,`id_mot_cle`),
  KEY `fk_decrit_mc` (`id_mot_cle`),
  CONSTRAINT `fk_decrit_mc` FOREIGN KEY (`id_mot_cle`) REFERENCES `MOT_CLE` (`id_mot_cle`) ON DELETE CASCADE,
  CONSTRAINT `fk_decrit_pub` FOREIGN KEY (`id_publication`) REFERENCES `PUBLICATION` (`id_publication`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DECRIT_PAR`
--

LOCK TABLES `DECRIT_PAR` WRITE;
/*!40000 ALTER TABLE `DECRIT_PAR` DISABLE KEYS */;
INSERT INTO `DECRIT_PAR` (`id_publication`, `id_mot_cle`) VALUES (1,1),(2,1),(9,1),(1,2),(2,2),(2,3),(9,3),(3,4),(6,4),(6,5),(3,6),(4,7),(5,7),(5,8),(7,9),(11,9),(8,12),(8,13);
/*!40000 ALTER TABLE `DECRIT_PAR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DEVISE`
--

DROP TABLE IF EXISTS `DEVISE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DEVISE` (
  `code_devise` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nom_devise` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `taux_vers_euro` decimal(10,4) NOT NULL,
  PRIMARY KEY (`code_devise`),
  CONSTRAINT `chk_devise_code` CHECK ((`code_devise` in (_utf8mb4'£',_utf8mb4'$',_utf8mb4'€'))),
  CONSTRAINT `chk_taux_positif` CHECK ((`taux_vers_euro` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DEVISE`
--

LOCK TABLES `DEVISE` WRITE;
/*!40000 ALTER TABLE `DEVISE` DISABLE KEYS */;
INSERT INTO `DEVISE` (`code_devise`, `nom_devise`, `taux_vers_euro`) VALUES ('$','Dollar US',0.9200),('£','Livre Sterling',1.1500),('€','Euro',1.0000);
/*!40000 ALTER TABLE `DEVISE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ECRIT`
--

DROP TABLE IF EXISTS `ECRIT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ECRIT` (
  `id_auteur` int NOT NULL,
  `id_publication` int NOT NULL,
  PRIMARY KEY (`id_auteur`,`id_publication`),
  KEY `fk_ecrit_pub` (`id_publication`),
  CONSTRAINT `fk_ecrit_auteur` FOREIGN KEY (`id_auteur`) REFERENCES `AUTEUR` (`id_auteur`) ON DELETE CASCADE,
  CONSTRAINT `fk_ecrit_pub` FOREIGN KEY (`id_publication`) REFERENCES `PUBLICATION` (`id_publication`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ECRIT`
--

LOCK TABLES `ECRIT` WRITE;
/*!40000 ALTER TABLE `ECRIT` DISABLE KEYS */;
INSERT INTO `ECRIT` (`id_auteur`, `id_publication`) VALUES (1,1),(2,2),(3,2),(4,2),(5,2),(7,3),(8,3),(9,4),(12,5),(6,6),(13,7),(1,8),(15,9),(9,10),(11,10),(13,11),(16,16),(17,16),(18,16),(19,16);
/*!40000 ALTER TABLE `ECRIT` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_max_auteurs_livre` BEFORE INSERT ON `ECRIT` FOR EACH ROW BEGIN
    DECLARE nb_auteurs INT;
    DECLARE est_livre BOOLEAN;
    
    
    SELECT COUNT(*) INTO nb_auteurs 
    FROM ECRIT 
    WHERE id_publication = NEW.id_publication;
    
    
    SELECT EXISTS(SELECT 1 FROM LIVRE WHERE id_publication = NEW.id_publication) 
    INTO est_livre;
    
    
    IF est_livre AND nb_auteurs >= 4 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Un livre ne peut avoir plus de 4 auteurs';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_these_un_auteur` BEFORE INSERT ON `ECRIT` FOR EACH ROW BEGIN
    DECLARE nb_auteurs INT;
    DECLARE est_these BOOLEAN;
    
    
    SELECT COUNT(*) INTO nb_auteurs 
    FROM ECRIT 
    WHERE id_publication = NEW.id_publication;
    
    
    SELECT EXISTS(
        SELECT 1 FROM RAPPORT_INTERNE 
        WHERE id_publication = NEW.id_publication 
        AND type_rapport = 'thèse ECL'
    ) INTO est_these;
    
    
    IF est_these AND nb_auteurs >= 1 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Une thèse ne peut avoir qu\'un seul auteur';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `INTERESSE_PAR`
--

DROP TABLE IF EXISTS `INTERESSE_PAR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INTERESSE_PAR` (
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_mot_cle` int NOT NULL,
  PRIMARY KEY (`email`,`id_mot_cle`),
  KEY `fk_interesse_mc` (`id_mot_cle`),
  CONSTRAINT `fk_interesse_mc` FOREIGN KEY (`id_mot_cle`) REFERENCES `MOT_CLE` (`id_mot_cle`) ON DELETE CASCADE,
  CONSTRAINT `fk_interesse_user` FOREIGN KEY (`email`) REFERENCES `UTILISATEUR` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `INTERESSE_PAR`
--

LOCK TABLES `INTERESSE_PAR` WRITE;
/*!40000 ALTER TABLE `INTERESSE_PAR` DISABLE KEYS */;
INSERT INTO `INTERESSE_PAR` (`email`, `id_mot_cle`) VALUES ('alice.dupont@ec-lyon.fr',1),('bob.martin@ec-lyon.fr',1),('david.petit@ec-lyon.fr',7),('david.petit@ec-lyon.fr',8),('claire.bernard@ec-lyon.fr',9),('alice.dupont@ec-lyon.fr',10),('alice.dupont@ec-lyon.fr',11),('bob.martin@ec-lyon.fr',12),('bob.martin@ec-lyon.fr',13),('david.petit@ec-lyon.fr',15);
/*!40000 ALTER TABLE `INTERESSE_PAR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LABORATOIRE`
--

DROP TABLE IF EXISTS `LABORATOIRE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LABORATOIRE` (
  `id_labo` int NOT NULL AUTO_INCREMENT,
  `nom_labo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `adresse` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_labo`),
  UNIQUE KEY `nom_labo` (`nom_labo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LABORATOIRE`
--

LOCK TABLES `LABORATOIRE` WRITE;
/*!40000 ALTER TABLE `LABORATOIRE` DISABLE KEYS */;
INSERT INTO `LABORATOIRE` (`id_labo`, `nom_labo`, `adresse`) VALUES (1,'Laboratoire de Mécanique','36 Avenue Guy de Collongue, 69134 Écully'),(2,'Laboratoire d\'Informatique','36 Avenue Guy de Collongue, 69134 Écully'),(3,'Laboratoire de Chimie','36 Avenue Guy de Collongue, 69134 Écully'),(4,'Laboratoire de Mathématiques','36 Avenue Guy de Collongue, 69134 Écully');
/*!40000 ALTER TABLE `LABORATOIRE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LIVRE`
--

DROP TABLE IF EXISTS `LIVRE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LIVRE` (
  `id_publication` int NOT NULL,
  `isbn` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_publication`),
  KEY `idx_livre_isbn` (`isbn`),
  CONSTRAINT `fk_livre_pub` FOREIGN KEY (`id_publication`) REFERENCES `PUBLICATION` (`id_publication`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LIVRE`
--

LOCK TABLES `LIVRE` WRITE;
/*!40000 ALTER TABLE `LIVRE` DISABLE KEYS */;
INSERT INTO `LIVRE` (`id_publication`, `isbn`) VALUES (6,'978-0-13-359162-0'),(16,'978-0-201-63361-0'),(1,'978-0-201-89683-1'),(2,'978-0-262-03384-8'),(4,'978-0-521-07647-6'),(5,'978-0-553-10953-5'),(3,'978-1-119-32091-3');
/*!40000 ALTER TABLE `LIVRE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MOT_CLE`
--

DROP TABLE IF EXISTS `MOT_CLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MOT_CLE` (
  `id_mot_cle` int NOT NULL AUTO_INCREMENT,
  `mot_cle` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_mot_cle`),
  UNIQUE KEY `mot_cle` (`mot_cle`),
  KEY `idx_mc_mot` (`mot_cle`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MOT_CLE`
--

LOCK TABLES `MOT_CLE` WRITE;
/*!40000 ALTER TABLE `MOT_CLE` DISABLE KEYS */;
INSERT INTO `MOT_CLE` (`id_mot_cle`, `mot_cle`) VALUES (1,'algorithme'),(10,'base de données'),(9,'chimie organique'),(15,'compilation'),(3,'complexité'),(6,'concurrent'),(14,'cryptographie'),(13,'deep learning'),(12,'machine learning'),(7,'physique quantique'),(8,'relativité'),(5,'réseau'),(11,'SQL'),(2,'structure de données'),(4,'système');
/*!40000 ALTER TABLE `MOT_CLE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PERIODIQUE`
--

DROP TABLE IF EXISTS `PERIODIQUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PERIODIQUE` (
  `id_publication` int NOT NULL,
  `numero_volume` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_publication`),
  CONSTRAINT `fk_periodique_pub` FOREIGN KEY (`id_publication`) REFERENCES `PUBLICATION` (`id_publication`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PERIODIQUE`
--

LOCK TABLES `PERIODIQUE` WRITE;
/*!40000 ALTER TABLE `PERIODIQUE` DISABLE KEYS */;
INSERT INTO `PERIODIQUE` (`id_publication`, `numero_volume`) VALUES (7,'Vol. 580, Issue 7801'),(8,'Vol. 65, No. 3');
/*!40000 ALTER TABLE `PERIODIQUE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROPOSITION_ACHAT`
--

DROP TABLE IF EXISTS `PROPOSITION_ACHAT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROPOSITION_ACHAT` (
  `id_proposition` int NOT NULL AUTO_INCREMENT,
  `date_proposition` date NOT NULL,
  `titre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `auteurs` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `editeur` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `annee` int DEFAULT NULL,
  `type_publication` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `informations_complementaires` text COLLATE utf8mb4_unicode_ci,
  `email_utilisateur` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_proposition`),
  KEY `fk_prop_utilisateur` (`email_utilisateur`),
  CONSTRAINT `fk_prop_utilisateur` FOREIGN KEY (`email_utilisateur`) REFERENCES `UTILISATEUR` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROPOSITION_ACHAT`
--

LOCK TABLES `PROPOSITION_ACHAT` WRITE;
/*!40000 ALTER TABLE `PROPOSITION_ACHAT` DISABLE KEYS */;
INSERT INTO `PROPOSITION_ACHAT` (`id_proposition`, `date_proposition`, `titre`, `auteurs`, `editeur`, `annee`, `type_publication`, `informations_complementaires`, `email_utilisateur`) VALUES (1,'2024-01-15','Deep Learning','Ian Goodfellow, Yoshua Bengio, Aaron Courville','MIT Press',2016,'livre','Livre de référence en deep learning, très utile pour nos recherches','bob.martin@ec-lyon.fr'),(2,'2024-02-20','The Feynman Lectures on Physics','Richard Feynman','Addison-Wesley',2011,'livre','Collection complète des cours de Feynman','david.petit@ec-lyon.fr'),(3,'2024-03-10','Science','AAAS','AAAS',2024,'périodique','Abonnement au journal Science, vol. 383','claire.bernard@ec-lyon.fr');
/*!40000 ALTER TABLE `PROPOSITION_ACHAT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PUBLICATION`
--

DROP TABLE IF EXISTS `PUBLICATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PUBLICATION` (
  `id_publication` int NOT NULL AUTO_INCREMENT,
  `titre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `editeur` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `edition` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `annee_publication` int DEFAULT NULL,
  `nom_librairie` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prix` decimal(10,2) NOT NULL,
  `statut` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'sur étagère',
  `type_publication` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_labo` int NOT NULL,
  `code_devise` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_emprunteur` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_publication`),
  KEY `fk_pub_devise` (`code_devise`),
  KEY `fk_pub_emprunteur` (`email_emprunteur`),
  KEY `idx_pub_titre` (`titre`),
  KEY `idx_pub_annee` (`annee_publication`),
  KEY `idx_pub_statut` (`statut`),
  KEY `idx_pub_labo` (`id_labo`),
  CONSTRAINT `fk_pub_devise` FOREIGN KEY (`code_devise`) REFERENCES `DEVISE` (`code_devise`) ON DELETE RESTRICT,
  CONSTRAINT `fk_pub_emprunteur` FOREIGN KEY (`email_emprunteur`) REFERENCES `UTILISATEUR` (`email`) ON DELETE SET NULL,
  CONSTRAINT `fk_pub_labo` FOREIGN KEY (`id_labo`) REFERENCES `LABORATOIRE` (`id_labo`) ON DELETE RESTRICT,
  CONSTRAINT `chk_annee` CHECK ((`annee_publication` between 1000 and 2100)),
  CONSTRAINT `chk_prix_positif` CHECK ((`prix` >= 0)),
  CONSTRAINT `chk_statut` CHECK ((`statut` in (_utf8mb4'sur étagère',_utf8mb4'emprunté',_utf8mb4'perdu',_utf8mb4'à acheter'))),
  CONSTRAINT `chk_type_pub` CHECK ((`type_publication` in (_utf8mb4'livre',_utf8mb4'périodique',_utf8mb4'rapport')))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PUBLICATION`
--

LOCK TABLES `PUBLICATION` WRITE;
/*!40000 ALTER TABLE `PUBLICATION` DISABLE KEYS */;
INSERT INTO `PUBLICATION` (`id_publication`, `titre`, `editeur`, `edition`, `annee_publication`, `nom_librairie`, `prix`, `statut`, `type_publication`, `id_labo`, `code_devise`, `email_emprunteur`) VALUES (1,'The Art of Computer Programming Vol. 1','Addison-Wesley','3rd Edition',1997,'Amazon',65.00,'sur étagère','livre',2,'$',NULL),(2,'Introduction to Algorithms','MIT Press','3rd Edition',2009,'MIT Press Store',85.00,'sur étagère','livre',2,'$',NULL),(3,'Operating Systems Concepts','Wiley','10th Edition',2018,'Wiley Direct',120.00,'emprunté','livre',2,'€','bob.martin@ec-lyon.fr'),(4,'Philosophiæ Naturalis Principia Mathematica','Cambridge University Press','Reprint',1687,'Cambridge Store',45.00,'sur étagère','livre',1,'£',NULL),(5,'A Brief History of Time','Bantam Books','1st Edition',1988,'Fnac',25.00,'perdu','livre',1,'€',NULL),(6,'Modern Operating Systems','Pearson','4th Edition',2014,'Pearson Store',95.00,'sur étagère','livre',4,'$',NULL),(7,'Nature','Nature Publishing Group','Vol. 580',2020,'Nature Direct',45.00,'sur étagère','périodique',3,'€',NULL),(8,'Communications of the ACM','ACM','Vol. 65, No. 3',2022,'ACM Digital Library',30.00,'emprunté','périodique',2,'$','amani.krid@ec-lyon.fr'),(9,'Optimisation des algorithmes de tri distribués','ECL',NULL,2021,NULL,0.00,'sur étagère','rapport',2,'€',NULL),(10,'Étude de la mécanique des fluides dans les turbines','ECL',NULL,2023,NULL,0.00,'sur étagère','rapport',1,'€',NULL),(11,'Synthèse de nouveaux polymères biodégradables','ECL',NULL,2022,NULL,0.00,'sur étagère','rapport',3,'€',NULL),(15,'Life of Youssef','Youssef KHALFA','1ère édition',2025,'ECL',30.00,'sur étagère','livre',2,'€',NULL),(16,'Design Patterns: Elements of Reusable Object-Oriented Software','Addison-Wesley','1ère édition',1994,'Amazon',54.99,'emprunté','livre',2,'$','amani.krid@ec-lyon.fr');
/*!40000 ALTER TABLE `PUBLICATION` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_emprunt_coherence` BEFORE INSERT ON `PUBLICATION` FOR EACH ROW BEGIN
    IF NEW.statut = 'emprunté' AND NEW.email_emprunteur IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Si statut=emprunté, email_emprunteur doit être renseigné';
    END IF;
    IF NEW.statut != 'emprunté' AND NEW.email_emprunteur IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Si statut!=emprunté, email_emprunteur doit être NULL';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_emprunt_coherence_update` BEFORE UPDATE ON `PUBLICATION` FOR EACH ROW BEGIN
    IF NEW.statut = 'emprunté' AND NEW.email_emprunteur IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Si statut=emprunté, email_emprunteur doit être renseigné';
    END IF;
    IF NEW.statut != 'emprunté' AND NEW.email_emprunteur IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Si statut!=emprunté, email_emprunteur doit être NULL';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_droits_emprunt` BEFORE UPDATE ON `PUBLICATION` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `RAPPORT_INTERNE`
--

DROP TABLE IF EXISTS `RAPPORT_INTERNE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RAPPORT_INTERNE` (
  `id_publication` int NOT NULL,
  `type_rapport` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_identification` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_publication`),
  CONSTRAINT `fk_rapport_pub` FOREIGN KEY (`id_publication`) REFERENCES `PUBLICATION` (`id_publication`) ON DELETE CASCADE,
  CONSTRAINT `chk_type_rapport` CHECK ((`type_rapport` in (_utf8mb4'thèse ECL',_utf8mb4'rapport scientifique')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RAPPORT_INTERNE`
--

LOCK TABLES `RAPPORT_INTERNE` WRITE;
/*!40000 ALTER TABLE `RAPPORT_INTERNE` DISABLE KEYS */;
INSERT INTO `RAPPORT_INTERNE` (`id_publication`, `type_rapport`, `numero_identification`) VALUES (9,'thèse ECL','TH-2021-001'),(10,'rapport scientifique','RS-2023-005'),(11,'thèse ECL','TH-2022-003');
/*!40000 ALTER TABLE `RAPPORT_INTERNE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UTILISATEUR`
--

DROP TABLE IF EXISTS `UTILISATEUR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UTILISATEUR` (
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nom` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prenom` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('utilisateur','admin') COLLATE utf8mb4_unicode_ci DEFAULT 'utilisateur',
  PRIMARY KEY (`email`),
  CONSTRAINT `chk_email_format` CHECK ((`email` like _utf8mb4'%@%'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UTILISATEUR`
--

LOCK TABLES `UTILISATEUR` WRITE;
/*!40000 ALTER TABLE `UTILISATEUR` DISABLE KEYS */;
INSERT INTO `UTILISATEUR` (`email`, `nom`, `prenom`, `role`) VALUES ('admin@ecl.fr','Bibliothèque','Admin','admin'),('alice.dupont@ec-lyon.fr','Dupont','Alice','utilisateur'),('amani.krid@ec-lyon.fr','KRID','Amani','utilisateur'),('bob.martin@ec-lyon.fr','Martin','Bob','utilisateur'),('claire.bernard@ec-lyon.fr','Bernard','Claire','utilisateur'),('david.petit@ec-lyon.fr','Petit','David','utilisateur'),('emma.rousseau@ec-lyon.fr','Rousseau','Emma','utilisateur'),('youssef.khalfa@ec-lyon.fr','khalfa','Youssef','utilisateur');
/*!40000 ALTER TABLE `UTILISATEUR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vue_livres_complets`
--

DROP TABLE IF EXISTS `vue_livres_complets`;
/*!50001 DROP VIEW IF EXISTS `vue_livres_complets`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vue_livres_complets` AS SELECT 
 1 AS `id_publication`,
 1 AS `titre`,
 1 AS `editeur`,
 1 AS `annee_publication`,
 1 AS `isbn`,
 1 AS `auteurs`,
 1 AS `statut`,
 1 AS `laboratoire`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vue_prix_euros`
--

DROP TABLE IF EXISTS `vue_prix_euros`;
/*!50001 DROP VIEW IF EXISTS `vue_prix_euros`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vue_prix_euros` AS SELECT 
 1 AS `id_publication`,
 1 AS `titre`,
 1 AS `type_publication`,
 1 AS `prix_original`,
 1 AS `code_devise`,
 1 AS `prix_euros`,
 1 AS `laboratoire`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vue_publications_disponibles`
--

DROP TABLE IF EXISTS `vue_publications_disponibles`;
/*!50001 DROP VIEW IF EXISTS `vue_publications_disponibles`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vue_publications_disponibles` AS SELECT 
 1 AS `id_publication`,
 1 AS `titre`,
 1 AS `editeur`,
 1 AS `annee_publication`,
 1 AS `type_publication`,
 1 AS `laboratoire`,
 1 AS `prix`,
 1 AS `code_devise`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vue_publications_empruntes`
--

DROP TABLE IF EXISTS `vue_publications_empruntes`;
/*!50001 DROP VIEW IF EXISTS `vue_publications_empruntes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vue_publications_empruntes` AS SELECT 
 1 AS `titre`,
 1 AS `type_publication`,
 1 AS `emprunteur`,
 1 AS `email`,
 1 AS `laboratoire`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vue_stats_labos`
--

DROP TABLE IF EXISTS `vue_stats_labos`;
/*!50001 DROP VIEW IF EXISTS `vue_stats_labos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vue_stats_labos` AS SELECT 
 1 AS `nom_labo`,
 1 AS `total_publications`,
 1 AS `disponibles`,
 1 AS `empruntes`,
 1 AS `perdus`,
 1 AS `valeur_totale_euros`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'bibliotheque_ecl'
--

--
-- Dumping routines for database 'bibliotheque_ecl'
--

--
-- Current Database: `bibliotheque_ecl`
--

USE `bibliotheque_ecl`;

--
-- Final view structure for view `vue_livres_complets`
--

/*!50001 DROP VIEW IF EXISTS `vue_livres_complets`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vue_livres_complets` AS select `p`.`id_publication` AS `id_publication`,`p`.`titre` AS `titre`,`p`.`editeur` AS `editeur`,`p`.`annee_publication` AS `annee_publication`,`liv`.`isbn` AS `isbn`,group_concat(concat(`a`.`prenom`,' ',`a`.`nom`) order by `a`.`nom` ASC separator ', ') AS `auteurs`,`p`.`statut` AS `statut`,`l`.`nom_labo` AS `laboratoire` from ((((`PUBLICATION` `p` join `LIVRE` `liv` on((`p`.`id_publication` = `liv`.`id_publication`))) join `LABORATOIRE` `l` on((`p`.`id_labo` = `l`.`id_labo`))) left join `ECRIT` `e` on((`p`.`id_publication` = `e`.`id_publication`))) left join `AUTEUR` `a` on((`e`.`id_auteur` = `a`.`id_auteur`))) group by `p`.`id_publication`,`p`.`titre`,`p`.`editeur`,`p`.`annee_publication`,`liv`.`isbn`,`p`.`statut`,`l`.`nom_labo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vue_prix_euros`
--

/*!50001 DROP VIEW IF EXISTS `vue_prix_euros`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vue_prix_euros` AS select `p`.`id_publication` AS `id_publication`,`p`.`titre` AS `titre`,`p`.`type_publication` AS `type_publication`,`p`.`prix` AS `prix_original`,`p`.`code_devise` AS `code_devise`,round((`p`.`prix` * `d`.`taux_vers_euro`),2) AS `prix_euros`,`l`.`nom_labo` AS `laboratoire` from ((`PUBLICATION` `p` join `DEVISE` `d` on((`p`.`code_devise` = `d`.`code_devise`))) join `LABORATOIRE` `l` on((`p`.`id_labo` = `l`.`id_labo`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vue_publications_disponibles`
--

/*!50001 DROP VIEW IF EXISTS `vue_publications_disponibles`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vue_publications_disponibles` AS select `p`.`id_publication` AS `id_publication`,`p`.`titre` AS `titre`,`p`.`editeur` AS `editeur`,`p`.`annee_publication` AS `annee_publication`,`p`.`type_publication` AS `type_publication`,`l`.`nom_labo` AS `laboratoire`,`p`.`prix` AS `prix`,`p`.`code_devise` AS `code_devise` from (`PUBLICATION` `p` join `LABORATOIRE` `l` on((`p`.`id_labo` = `l`.`id_labo`))) where (`p`.`statut` = 'sur étagère') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vue_publications_empruntes`
--

/*!50001 DROP VIEW IF EXISTS `vue_publications_empruntes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vue_publications_empruntes` AS select `p`.`titre` AS `titre`,`p`.`type_publication` AS `type_publication`,concat(`u`.`prenom`,' ',`u`.`nom`) AS `emprunteur`,`u`.`email` AS `email`,`l`.`nom_labo` AS `laboratoire` from ((`PUBLICATION` `p` join `UTILISATEUR` `u` on((`p`.`email_emprunteur` = `u`.`email`))) join `LABORATOIRE` `l` on((`p`.`id_labo` = `l`.`id_labo`))) where (`p`.`statut` = 'emprunté') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vue_stats_labos`
--

/*!50001 DROP VIEW IF EXISTS `vue_stats_labos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vue_stats_labos` AS select `l`.`nom_labo` AS `nom_labo`,count(`p`.`id_publication`) AS `total_publications`,sum((case when (`p`.`statut` = 'sur étagère') then 1 else 0 end)) AS `disponibles`,sum((case when (`p`.`statut` = 'emprunté') then 1 else 0 end)) AS `empruntes`,sum((case when (`p`.`statut` = 'perdu') then 1 else 0 end)) AS `perdus`,round(sum((`p`.`prix` * `d`.`taux_vers_euro`)),2) AS `valeur_totale_euros` from ((`LABORATOIRE` `l` left join `PUBLICATION` `p` on((`l`.`id_labo` = `p`.`id_labo`))) left join `DEVISE` `d` on((`p`.`code_devise` = `d`.`code_devise`))) group by `l`.`id_labo`,`l`.`nom_labo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-05 15:20:43

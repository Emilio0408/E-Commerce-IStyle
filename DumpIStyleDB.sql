CREATE DATABASE  IF NOT EXISTS `istyledb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `istyledb`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: istyledb
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appartiene`
--

DROP TABLE IF EXISTS `appartiene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appartiene` (
  `IDProdotto` int NOT NULL,
  `IDListaPreferiti` int NOT NULL,
  PRIMARY KEY (`IDProdotto`,`IDListaPreferiti`),
  KEY `fk_appartiene_preferiti` (`IDListaPreferiti`),
  CONSTRAINT `fk_appartiene_preferiti` FOREIGN KEY (`IDListaPreferiti`) REFERENCES `preferiti` (`IDListaPreferiti`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_appartiene_prodotto` FOREIGN KEY (`IDProdotto`) REFERENCES `prodotto` (`IDProdotto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appartiene`
--

LOCK TABLES `appartiene` WRITE;
/*!40000 ALTER TABLE `appartiene` DISABLE KEYS */;
/*!40000 ALTER TABLE `appartiene` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contiene`
--

DROP TABLE IF EXISTS `contiene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contiene` (
  `IDProdotto` int NOT NULL,
  `IDOrdine` int NOT NULL,
  `Quantita` int NOT NULL DEFAULT '1',
  `colore` varchar(50) NOT NULL,
  `modello` varchar(50) NOT NULL,
  PRIMARY KEY (`IDProdotto`,`IDOrdine`,`colore`,`modello`),
  KEY `fk_contiene_varianti` (`colore`,`modello`),
  KEY `fk_contiene_ordine` (`IDOrdine`),
  CONSTRAINT `fk_contiene_ordine` FOREIGN KEY (`IDOrdine`) REFERENCES `ordine` (`IDOrdine`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_contiene_prodotto` FOREIGN KEY (`IDProdotto`) REFERENCES `prodotto` (`IDProdotto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contiene`
--

LOCK TABLES `contiene` WRITE;
/*!40000 ALTER TABLE `contiene` DISABLE KEYS */;
INSERT INTO `contiene` VALUES (18,2,1,'Grey','iPhone 16 PRO MAX'),(18,3,1,'Grey','iPhone 15'),(18,6,1,'Grey','iPhone 16'),(18,6,1,'White','iPhone 15 PRO'),(18,9,1,'Grey','iPhone 15'),(18,10,1,'Grey','iPhone 16'),(18,12,1,'Grey','iPhone 16'),(18,13,2,'Grey','iPhone 15 PRO'),(18,13,2,'White','iPhone 14 PRO MAX'),(19,4,2,'White','iPhone 15 PRO'),(19,10,1,'White','iPhone 13 mini'),(19,11,1,'White','iPhone 13 mini'),(19,12,1,'White','iPhone 13'),(19,13,1,'White','iPhone 15 PRO MAX'),(20,1,1,'Bordeaux','iPhone 15 PRO MAX'),(23,1,1,'Black','iPhone 16 PRO MAX'),(25,1,1,'Black','iPhone 15 PRO MAX'),(25,8,1,'Black','iPhone 16'),(26,8,2,'White','iPhone 13'),(26,8,1,'White','iPhone 13 mini'),(28,8,1,'Red','iPhone 15 PRO'),(30,5,2,'Black','iPhone 15 PRO MAX'),(30,5,1,'Grey','iPhone 16 PRO'),(30,6,1,'Grey','iPhone 16 PRO'),(30,11,1,'Grey','iPhone 14 PRO MAX'),(30,13,1,'Grey','iPhone 14');
/*!40000 ALTER TABLE `contiene` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disponibilità`
--

DROP TABLE IF EXISTS `disponibilità`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disponibilità` (
  `IDProdotto` int NOT NULL,
  `colore` varchar(30) NOT NULL,
  `modello` varchar(30) NOT NULL,
  `QuantitàDisponibile` int DEFAULT NULL,
  `codiceColore` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IDProdotto`,`colore`,`modello`),
  KEY `colore` (`colore`,`modello`),
  CONSTRAINT `disponibilità_ibfk_1` FOREIGN KEY (`IDProdotto`) REFERENCES `prodotto` (`IDProdotto`),
  CONSTRAINT `disponibilità_ibfk_2` FOREIGN KEY (`colore`, `modello`) REFERENCES `varianti` (`colore`, `modello`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disponibilità`
--

LOCK TABLES `disponibilità` WRITE;
/*!40000 ALTER TABLE `disponibilità` DISABLE KEYS */;
INSERT INTO `disponibilità` VALUES (18,'Grey','iPhone 15',3,'#808080'),(18,'Grey','iPhone 15 PRO',1,'#808080'),(18,'Grey','iPhone 15 PRO MAX',19,'#808080'),(18,'Grey','iPhone 16',14,'#808080'),(18,'Grey','iPhone 16 PRO',8,'#808080'),(18,'Grey','iPhone 16 PRO MAX',2,'#808080'),(18,'White','iPhone 14',7,'#FFFFFF'),(18,'White','iPhone 14 PRO',13,'#FFFFFF'),(18,'White','iPhone 14 PRO MAX',-4,'#FFFFFF'),(18,'White','iPhone 15',11,'#FFFFFF'),(18,'White','iPhone 15 PRO',2,'#FFFFFF'),(18,'White','iPhone 15 PRO MAX',19,'#FFFFFF'),(18,'White','iPhone 16',17,'#FFFFFF'),(18,'White','iPhone 16 PRO',9,'#FFFFFF'),(18,'White','iPhone 16 PRO MAX',4,'#FFFFFF'),(19,'White','iPhone 13',9,'#FFFFFF'),(19,'White','iPhone 13 mini',1,'#FFFFFF'),(19,'White','iPhone 14',17,'#FFFFFF'),(19,'White','iPhone 14 PRO',9,'#FFFFFF'),(19,'White','iPhone 14 PRO MAX',4,'#FFFFFF'),(19,'White','iPhone 15',11,'#FFFFFF'),(19,'White','iPhone 15 PRO',1,'#FFFFFF'),(19,'White','iPhone 15 PRO MAX',18,'#FFFFFF'),(19,'White','iPhone 16',17,'#FFFFFF'),(19,'White','iPhone 16 PRO',9,'#FFFFFF'),(19,'White','iPhone 16 PRO MAX',4,'#FFFFFF'),(20,'Bordeaux','iPhone 14',17,'#800020'),(20,'Bordeaux','iPhone 15',11,'#800020'),(20,'Bordeaux','iPhone 15 PRO',3,'#800020'),(20,'Bordeaux','iPhone 15 PRO MAX',18,'#800020'),(20,'Bordeaux','iPhone 16',17,'#800020'),(20,'Bordeaux','iPhone 16 PRO',9,'#800020'),(20,'Bordeaux','iPhone 16 PRO MAX',4,'#800020'),(21,'Black','iPhone 15',11,'#000000'),(21,'Black','iPhone 15 PRO',3,'#000000'),(21,'Black','iPhone 15 PRO MAX',19,'#000000'),(21,'Black','iPhone 16',17,'#000000'),(21,'Black','iPhone 16 PRO',9,'#000000'),(21,'Black','iPhone 16 PRO MAX',4,'#000000'),(22,'White','iPhone 13',11,'#FFFFFF'),(22,'White','iPhone 13 mini',3,'#FFFFFF'),(22,'White','iPhone 14',17,'#FFFFFF'),(22,'White','iPhone 14 PRO',9,'#FFFFFF'),(22,'White','iPhone 14 PRO MAX',4,'#FFFFFF'),(23,'Black','iPhone 16',17,'#000000'),(23,'Black','iPhone 16 PRO',9,'#000000'),(23,'Black','iPhone 16 PRO MAX',3,'#000000'),(24,'Black','iPhone 15',11,'#000000'),(24,'Black','iPhone 15 PRO',3,'#000000'),(24,'Black','iPhone 16',17,'#000000'),(24,'Black','iPhone 16 PRO',9,'#000000'),(24,'Black','iPhone 16 PRO MAX',4,'#000000'),(25,'Black','iPhone 15',11,'#000000'),(25,'Black','iPhone 15 PRO',3,'#000000'),(25,'Black','iPhone 15 PRO MAX',18,'#000000'),(25,'Black','iPhone 16',16,'#000000'),(25,'Black','iPhone 16 PRO',9,'#000000'),(25,'Black','iPhone 16 PRO MAX',4,'#000000'),(26,'Fucsia','iPhone 12',3,'#f400a1'),(26,'Fucsia','iPhone 12 mini',3,'#f400a1'),(26,'Fucsia','iPhone 12 PRO',3,'#f400a1'),(26,'Fucsia','iPhone 12 PRO MAX',3,'#f400a1'),(26,'Fucsia','iPhone 13',11,'#f400a1'),(26,'Fucsia','iPhone 13 mini',3,'#f400a1'),(26,'Fucsia','iPhone 13 PRO',3,'#f400a1'),(26,'Fucsia','iPhone 13 PRO MAX',3,'#f400a1'),(26,'Fucsia','iPhone 14',17,'#f400a1'),(26,'Fucsia','iPhone 14 PRO',9,'#f400a1'),(26,'Fucsia','iPhone 14 PRO MAX',4,'#f400a1'),(26,'Fucsia','iPhone 15',11,'#f400a1'),(26,'Fucsia','iPhone 15 PRO',3,'#f400a1'),(26,'Fucsia','iPhone 15 PRO MAX',19,'#f400a1'),(26,'Fucsia','iPhone 16',17,'#f400a1'),(26,'Fucsia','iPhone 16 PRO',9,'#f400a1'),(26,'Fucsia','iPhone 16 PRO MAX',4,'#f400a1'),(26,'Green','iPhone 14',17,'#00FF00'),(26,'Green','iPhone 14 PRO',9,'#00FF00'),(26,'Green','iPhone 15',11,'#00FF00'),(26,'Green','iPhone 15 PRO',3,'#00FF00'),(26,'Green','iPhone 15 PRO MAX',19,'#00FF00'),(26,'Green','iPhone 16',17,'#00FF00'),(26,'Green','iPhone 16 PRO',9,'#00FF00'),(26,'Green','iPhone 16 PRO MAX',4,'#00FF00'),(26,'LightBlue','iPhone 12',3,'#add8e6'),(26,'LightBlue','iPhone 12 mini',3,'#add8e6'),(26,'LightBlue','iPhone 12 PRO',3,'#add8e6'),(26,'LightBlue','iPhone 12 PRO MAX',3,'#add8e6'),(26,'LightBlue','iPhone 13',11,'#add8e6'),(26,'LightBlue','iPhone 13 mini',3,'#add8e6'),(26,'LightBlue','iPhone 13 PRO',3,'#add8e6'),(26,'LightBlue','iPhone 13 PRO MAX',3,'#add8e6'),(26,'LightBlue','iPhone 14',17,'#add8e6'),(26,'LightBlue','iPhone 14 PRO',9,'#add8e6'),(26,'LightBlue','iPhone 14 PRO MAX',4,'#add8e6'),(26,'LightBlue','iPhone 15',11,'#add8e6'),(26,'LightBlue','iPhone 15 PRO',3,'#add8e6'),(26,'LightBlue','iPhone 15 PRO MAX',19,'#add8e6'),(26,'LightBlue','iPhone 16',17,'#add8e6'),(26,'LightBlue','iPhone 16 PRO',9,'#add8e6'),(26,'LightBlue','iPhone 16 PRO MAX',4,'#add8e6'),(26,'White','iPhone 13',9,'#FFFFFF'),(26,'White','iPhone 13 mini',2,'#FFFFFF'),(26,'White','iPhone 14',17,'#FFFFFF'),(26,'White','iPhone 14 PRO',9,'#FFFFFF'),(26,'White','iPhone 14 PRO MAX',4,'#FFFFFF'),(26,'White','iPhone 15',11,'#FFFFFF'),(26,'White','iPhone 15 PRO',3,'#FFFFFF'),(26,'White','iPhone 15 PRO MAX',19,'#FFFFFF'),(26,'White','iPhone 16',17,'#FFFFFF'),(26,'White','iPhone 16 PRO',9,'#FFFFFF'),(26,'White','iPhone 16 PRO MAX',4,'#FFFFFF'),(27,'Black','iPhone 15',11,'#000000'),(27,'Black','iPhone 16',17,'#000000'),(27,'Black','iPhone 16 PRO',9,'#000000'),(27,'Black','iPhone 16 PRO MAX',4,'#000000'),(27,'Blue','iPhone 12',3,'#0000FF'),(27,'Blue','iPhone 12 mini',3,'#0000FF'),(27,'Blue','iPhone 12 PRO',3,'#0000FF'),(27,'Blue','iPhone 12 PRO MAX',3,'#0000FF'),(27,'Blue','iPhone 13',11,'#0000FF'),(27,'Blue','iPhone 13 mini',3,'#0000FF'),(27,'Blue','iPhone 13 PRO',3,'#0000FF'),(27,'Blue','iPhone 13 PRO MAX',3,'#0000FF'),(27,'Blue','iPhone 14',17,'#0000FF'),(27,'Blue','iPhone 14 PRO',9,'#0000FF'),(27,'Blue','iPhone 14 PRO MAX',4,'#0000FF'),(27,'Blue','iPhone 15',11,'#0000FF'),(27,'Blue','iPhone 15 PRO',3,'#0000FF'),(27,'Blue','iPhone 15 PRO MAX',19,'#0000FF'),(27,'Blue','iPhone 16',17,'#0000FF'),(27,'Blue','iPhone 16 PRO',9,'#0000FF'),(27,'Blue','iPhone 16 PRO MAX',4,'#0000FF'),(27,'Red','iPhone 14',17,'#FF0000'),(27,'Red','iPhone 14 PRO',9,'#FF0000'),(27,'Red','iPhone 15',11,'#FF0000'),(27,'Red','iPhone 15 PRO',3,'#FF0000'),(27,'Red','iPhone 15 PRO MAX',19,'#FF0000'),(27,'Red','iPhone 16',17,'#FF0000'),(27,'Red','iPhone 16 PRO',9,'#FF0000'),(27,'Red','iPhone 16 PRO MAX',4,'#FF0000'),(28,'Black','iPhone 15',11,'#000000'),(28,'Black','iPhone 15 PRO',3,'#000000'),(28,'Black','iPhone 16',17,'#000000'),(28,'Black','iPhone 16 PRO',9,'#000000'),(28,'Black','iPhone 16 PRO MAX',4,'#000000'),(28,'Blue','iPhone 14',17,'#0000FF'),(28,'Blue','iPhone 15',11,'#0000FF'),(28,'Blue','iPhone 15 PRO',3,'#0000FF'),(28,'Blue','iPhone 15 PRO MAX',19,'#0000FF'),(28,'Blue','iPhone 16',17,'#0000FF'),(28,'Blue','iPhone 16 PRO',9,'#0000FF'),(28,'Blue','iPhone 16 PRO MAX',4,'#0000FF'),(28,'Red','iPhone 14',17,'#FF0000'),(28,'Red','iPhone 15',11,'#FF0000'),(28,'Red','iPhone 15 PRO',2,'#FF0000'),(28,'Red','iPhone 15 PRO MAX',17,'#FF0000'),(28,'Red','iPhone 16',17,'#FF0000'),(28,'Red','iPhone 16 PRO',9,'#FF0000'),(28,'Red','iPhone 16 PRO MAX',4,'#FF0000'),(29,'Blue','iPhone 14',17,'#0000FF'),(29,'Blue','iPhone 15',11,'#0000FF'),(29,'Blue','iPhone 15 PRO',3,'#0000FF'),(29,'Blue','iPhone 15 PRO MAX',19,'#0000FF'),(29,'Blue','iPhone 16',17,'#0000FF'),(29,'Blue','iPhone 16 PRO',9,'#0000FF'),(29,'Blue','iPhone 16 PRO MAX',4,'#0000FF'),(29,'Red','iPhone 14',17,'#FF0000'),(29,'Red','iPhone 15',11,'#FF0000'),(29,'Red','iPhone 15 PRO',3,'#FF0000'),(29,'Red','iPhone 15 PRO MAX',19,'#FF0000'),(29,'Red','iPhone 16',17,'#FF0000'),(29,'Red','iPhone 16 PRO',9,'#FF0000'),(29,'Red','iPhone 16 PRO MAX',4,'#FF0000'),(30,'Black','iPhone 14',11,'#000000'),(30,'Black','iPhone 14 PRO',26,'#000000'),(30,'Black','iPhone 14 PRO MAX',9,'#000000'),(30,'Black','iPhone 15',22,'#000000'),(30,'Black','iPhone 15 PRO',5,'#000000'),(30,'Black','iPhone 15 PRO MAX',16,'#000000'),(30,'Black','iPhone 16',14,'#000000'),(30,'Black','iPhone 16 PRO',27,'#000000'),(30,'Black','iPhone 16 PRO MAX',3,'#000000'),(30,'Grey','iPhone 14',10,'#808080'),(30,'Grey','iPhone 14 PRO',26,'#808080'),(30,'Grey','iPhone 14 PRO MAX',8,'#808080'),(30,'Grey','iPhone 15',22,'#808080'),(30,'Grey','iPhone 15 PRO',5,'#808080'),(30,'Grey','iPhone 15 PRO MAX',18,'#808080'),(30,'Grey','iPhone 16',14,'#808080'),(30,'Grey','iPhone 16 PRO',25,'#808080'),(30,'Grey','iPhone 16 PRO MAX',3,'#808080');
/*!40000 ALTER TABLE `disponibilità` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `effettua`
--

DROP TABLE IF EXISTS `effettua`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `effettua` (
  `Username` varchar(50) NOT NULL,
  `IDOrdine` int NOT NULL,
  PRIMARY KEY (`Username`,`IDOrdine`),
  KEY `IDOrdine` (`IDOrdine`),
  CONSTRAINT `effettua_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `utente` (`Username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `effettua_ibfk_2` FOREIGN KEY (`IDOrdine`) REFERENCES `ordine` (`IDOrdine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `effettua`
--

LOCK TABLES `effettua` WRITE;
/*!40000 ALTER TABLE `effettua` DISABLE KEYS */;
INSERT INTO `effettua` VALUES ('Emilio0408',1),('Emilio0408',2),('Emilio0408',3),('AntSquill00',4),('Emilio0408',5),('Emilio0408',6),('Emilio0408',8),('Emilio0408',9),('Emilio0408',10),('Emilio0408',11),('Gian00',12),('Emilio0408',13);
/*!40000 ALTER TABLE `effettua` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `IDRecensione` int NOT NULL AUTO_INCREMENT,
  `Testo` text,
  `Voto` int NOT NULL,
  `IDProdotto` int NOT NULL,
  `Username` varchar(50) NOT NULL,
  `dataRecensione` date DEFAULT NULL,
  PRIMARY KEY (`IDRecensione`),
  KEY `IDProdotto` (`IDProdotto`),
  KEY `Username` (`Username`),
  CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`IDProdotto`) REFERENCES `prodotto` (`IDProdotto`) ON DELETE CASCADE,
  CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`Username`) REFERENCES `utente` (`Username`) ON DELETE CASCADE,
  CONSTRAINT `feedback_chk_1` CHECK ((`Voto` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,'Paurosa , indistruttibile , se dovessi dare una votazione universitaria\n30 e Lode',5,19,'Gian00','2025-07-22'),(2,'Bella cover',4,18,'Emilio0408','2025-07-22');
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `immagini`
--

DROP TABLE IF EXISTS `immagini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `immagini` (
  `Path` varchar(255) NOT NULL,
  `IDProdotto` int NOT NULL,
  PRIMARY KEY (`Path`),
  KEY `IDProdotto` (`IDProdotto`),
  CONSTRAINT `immagini_ibfk_1` FOREIGN KEY (`IDProdotto`) REFERENCES `prodotto` (`IDProdotto`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `immagini`
--

LOCK TABLES `immagini` WRITE;
/*!40000 ALTER TABLE `immagini` DISABLE KEYS */;
INSERT INTO `immagini` VALUES ('Cover Game Of Thrones-Grey.png',18),('Cover Game Of Thrones-White.png',18),('Cover Game Of Thrones Logo-White.png',19),('Cover Harry Potter Christmas Red Edition-Bordeaux.png',20),('Cover Harry Potter Dobby Black-Black.png',21),('Cover Harry Potter Logo Hogwarts Multicolor-White.png',22),('Cover Inter Biscione-Black.png',23),("Cover Inter Doppia Stella D'Oro-Black.png",24),('Cover Inter Scudetto-Black.png',25),('CoverMagSafe-Fucsia.png',26),('CoverMagSafe-Green.png',26),('CoverMagSafe-LightBlue.png',26),('CoverMagSafe-White.png',26),('Cover Dragon Ball Logo Torneo-Black.png',27),('Cover Dragon Ball Logo Torneo-Blue.png',27),('Cover Dragon Ball Logo Torneo-Red.png',27),('Cover Dragon Ball Logo Drago Shenron-Black.png',28),('Cover Dragon Ball Logo Drago Shenron-Blue.png',28),('Cover Dragon Ball Logo Drago Shenron-Red.png',28),('Cover Dragon Ball Logo Goku Base Form-Blue.png',29),('Cover Dragon Ball Logo Goku Base Form-Red.png',29),('Ring Stand MagSafe-Black.png',30),('Ring Stand MagSafe-Grey.png',30);

/*!40000 ALTER TABLE `immagini` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `indirizzo`
--

DROP TABLE IF EXISTS `indirizzo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `indirizzo` (
  `IDIndirizzo` int NOT NULL AUTO_INCREMENT,
  `CAP` varchar(10) DEFAULT NULL,
  `Via` varchar(100) DEFAULT NULL,
  `Nazione` varchar(50) DEFAULT NULL,
  `NumeroCivico` varchar(10) DEFAULT NULL,
  `Tipologia` varchar(50) DEFAULT NULL,
  `citta` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IDIndirizzo`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indirizzo`
--

LOCK TABLES `indirizzo` WRITE;
/*!40000 ALTER TABLE `indirizzo` DISABLE KEYS */;
INSERT INTO `indirizzo` VALUES (17,'84087','Via Sarno Striano','Italia','39','spedizione','Sarno');
/*!40000 ALTER TABLE `indirizzo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodo_di_pagamento`
--

DROP TABLE IF EXISTS `metodo_di_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodo_di_pagamento` (
  `IdMetodoDiPagamento` int NOT NULL AUTO_INCREMENT,
  `NumeroCarta` varchar(16) NOT NULL,
  `CVV` int NOT NULL,
  `NomeTitolare` varchar(50) NOT NULL,
  `CognomeTitolare` varchar(50) NOT NULL,
  `DataScadenza` date NOT NULL,
  PRIMARY KEY (`IdMetodoDiPagamento`),
  UNIQUE KEY `NumeroCarta` (`NumeroCarta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metodo_di_pagamento`
--

LOCK TABLES `metodo_di_pagamento` WRITE;
/*!40000 ALTER TABLE `metodo_di_pagamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `metodo_di_pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordine`
--

DROP TABLE IF EXISTS `ordine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordine` (
  `IDOrdine` int NOT NULL AUTO_INCREMENT,
  `DataErogazione` date NOT NULL,
  `DataConsegna` date DEFAULT NULL,
  `MetodoDiSpedizione` varchar(50) NOT NULL,
  `ImportoTotale` decimal(10,2) NOT NULL,
  `DataEmissione` date NOT NULL,
  `TipoPagamento` varchar(20) NOT NULL,
  `Stato` varchar(20) NOT NULL DEFAULT 'Elaborazione',
  `IndirizzoSpedizione` varchar(50) NOT NULL DEFAULT 'Via Capocchia,39',
  `paymentIntent` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`IDOrdine`),
  UNIQUE KEY `paymentIntent` (`paymentIntent`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordine`
--

LOCK TABLES `ordine` WRITE;
/*!40000 ALTER TABLE `ordine` DISABLE KEYS */;
INSERT INTO `ordine` VALUES (1,'2025-07-20','2025-07-21','express',39.97,'2025-07-20','card','In preparazione','Via Sarno Striano 39, 84087 Sarno, IT','pi_3RmtOvPDWen8x1PV10CujY5E'),(2,'2025-07-20','2025-07-21','express',29.99,'2025-07-20','card','In preparazione','Via Sarno Striano 39, 84087 Sarno, IT','pi_3Rmu7LPDWen8x1PV0MNGiqT1'),(3,'2025-07-20','2025-07-21','express',29.99,'2025-07-20','card','In preparazione','Via Sarno Striano 39, 84087 Sarno, IT','pi_3Rmu9SPDWen8x1PV00pTIv7F'),(4,'2025-07-20','2025-07-21','express',59.98,'2025-07-20','card','In preparazione','Via Sarno Striano 39, 84087 Sarno, IT','pi_3RmzjgPDWen8x1PV0G4k3DRj'),(5,'2025-07-21','2025-07-22','express',119.97,'2025-07-21','card','In preparazione','Via Sarno Striano 39, Sarno','pi_3RnGuuPDWen8x1PV2yfJRYiO'),(6,'2025-07-21','2025-07-22','express',99.97,'2025-07-21','card','In preparazione','Via Sarno Striano 39, Sarno','pi_3RnGyQPDWen8x1PV05xk3Kmy'),(8,'2025-07-21','2025-07-22','express',69.95,'2025-07-21','card','In preparazione','Via Sarno Striano 39, Sarno','pi_3RnHIGPDWen8x1PV1qr7s2dL'),(9,'2025-07-21','2025-07-27','standard',29.99,'2025-07-21','card','In preparazione','Via Sarno Striano 39, Sarno','pi_3RnK15PDWen8x1PV00k5G4j0'),(10,'2025-07-21','2025-07-22','express',59.98,'2025-07-21','card','In preparazione','Via Sarno Striano 39, Sarno','pi_3RnKbIPDWen8x1PV2rdDNTdV'),(11,'2025-07-21','2025-07-22','express',69.98,'2025-07-21','card','In preparazione','Via Sarno Striano 39, 84087 Sarno, IT','pi_3RnL3OPDWen8x1PV2VZR2iC5'),(12,'2025-07-22','2025-07-23','express',59.98,'2025-07-22','card','In preparazione','Via Sarno Striano 39, 84087 Sarno, IT','pi_3RnePbPDWen8x1PV0ipaRkt7'),(13,'2025-07-22','2025-07-23','express',189.94,'2025-07-22','card','In preparazione','Via Sarno Striano 39, Sarno','pi_3Rnf1gPDWen8x1PV0tEppMNe');
/*!40000 ALTER TABLE `ordine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preferiti`
--

DROP TABLE IF EXISTS `preferiti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preferiti` (
  `IDListaPreferiti` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`IDListaPreferiti`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preferiti`
--

LOCK TABLES `preferiti` WRITE;
/*!40000 ALTER TABLE `preferiti` DISABLE KEYS */;
INSERT INTO `preferiti` VALUES (1),(2),(3),(4),(5);
/*!40000 ALTER TABLE `preferiti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prodotto`
--

DROP TABLE IF EXISTS `prodotto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prodotto` (
  `IDProdotto` int NOT NULL AUTO_INCREMENT,
  `Costo` decimal(10,2) NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `Categoria` varchar(50) DEFAULT NULL,
  `Descrizione` text,
  `personalizzabile` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`IDProdotto`),
  UNIQUE KEY `unique_nome_prodotto` (`Nome`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prodotto`
--

LOCK TABLES `prodotto` WRITE;
/*!40000 ALTER TABLE `prodotto` DISABLE KEYS */;
INSERT INTO `prodotto` VALUES (18,29.99,'Cover Game Of Thrones','Serie TV','Cover Iron Legacy ispirata a Game of Thrones, in lega DarkVibranium rilievo 3D del Trono di Spade termoattivo, protezione AegisCore antiurto e supporto magnetico Hidden Dragon. Compatibile MagSafe.',0),(19,29.99,'Cover Game Of Thrones Logo','Serie TV','Cover ufficiale Game of Thrones con logo inciso a laser su scocca in TitanSkin, resistente a graffi e urti. Effetto opaco soft-touch con dettagli House Stark e rilievi riflettenti. Protezione EdgeLock 360° e supporto MagLink compatibile con MagSafe.',0),(20,19.99,'Cover Harry Potter Christmas Red Edition','Film','Cover Harry Potter con stemma Hogwarts stampato in HD su superficie SpellSkin antigraffio. Retro satinato con effetto incanto e bordi rinforzati con tecnologia WandGuard. Supporto magnetico LumosLink incluso.',0),(21,19.99,'Cover Harry Potter Dobby Black','Film','Cover Harry Potter con illustrazione premium di Dobby su fondo DarkVelvet. Realizzata in FlexSkin antiurto con bordi ElfoSoft. Frase incisa \"Dobby è un elfo libero\". Compatibile con ricarica wireless.',0),(22,24.99,'Cover Harry Potter Logo Hogwarts Multicolor','Film','Cover ufficiale Harry Potter con logo Hogwarts multicolore effetto olografico, realizzata in materiale CrystalGuard™ ad alta trasparenza e resistenza. I quattro emblemi delle Case – Grifondoro, Serpeverde, Tassorosso e Corvonero – sono rappresentati in rilievo con finitura lucida su sfondo FrostGrip™ opaco, creando un contrasto elegante e dinamico. La cover è dotata di tecnologia ShockFrame™ sui bordi per la massima protezione contro cadute accidentali, e compatibile con la ricarica wireless. Include trattamento anti-impronta e antigraffio con rivestimento MagicShield™, studiato per durare nel tempo. Ideale per veri fan del Wizarding World, unisce stile, protezione e magia.',0),(23,9.99,'Cover Inter Biscione','Calcio','Cover ufficiale FC Internazionale, con logo centrale avvolto da un maestoso biscione neroazzurro in rilievo lucido effetto 3D. Realizzata in materiale FlexShield™ ultraresistente, garantisce massima protezione contro graffi, urti e cadute accidentali. Il serpente, simbolo storico del club, si intreccia attorno all’emblema dell’Inter con dettagli satinati e finitura soft-touch, donando un look elegante e aggressivo. Tecnologia EdgeGuard™ sui bordi e compatibilità con la ricarica wireless. Antiscivolo, leggerissima e perfetta per i veri tifosi nerazzurri che vogliono portare con sé la propria passione ovunque.',0),(24,9.99,"Cover Inter Doppia Stella D'Oro','Calcio','Cover celebrativa FC Internazionale con logo ufficiale arricchito dallo scudetto tricolore e due stelle dorate, simbolo dei 20 scudetti conquistati. Il design esclusivo è stampato in alta definizione su materiale UltraGrip™ opaco anti-impronta, con dettagli oro in finitura metallizzata. Dotata di tecnologia AirCushion™ agli angoli per un’elevata protezione dagli urti e di superficie antiscivolo per una presa sicura. Ultra-sottile, flessibile e compatibile con la ricarica wireless. Pensata per i tifosi che vogliono portare con orgoglio la storia nerazzurra sempre con sé.",0),(25,9.99,'Cover Inter Scudetto','Calcio','Cover esclusiva dedicata ai tifosi nerazzurri, con design centrato sul numero di scudetti vinti dall’Inter, stampato in grande stile accanto al logo ufficiale del club. Realizzata con materiali premium SoftShield™ antigraffio e stampa HD a colori resistenti nel tempo. Protezione completa grazie agli angoli rinforzati ShockGuard™, bordo rialzato per proteggere lo schermo e compatibilità totale con la ricarica wireless. Un omaggio alla storia e ai trionfi della Beneamata, da portare sempre con sé.',0),(26,14.99,'Cover MagSafe','Generale','Cover innovativa compatibile con la tecnologia MagSafe, caratterizzata dal simbolo MagSafe stampato elegantemente sul retro. Realizzata in silicone premium SoftTouch™, offre una presa sicura e una sensazione piacevole al tatto. La struttura integrata consente un allineamento perfetto con i magneti MagSafe per una ricarica wireless efficiente e senza interruzioni. Protegge il dispositivo da urti, graffi e cadute, mantenendo il design sottile e leggero. Ideale per chi cerca funzionalità avanzate senza rinunciare allo stile',0),(27,14.99,'Cover Dragon Ball Logo Torneo','Anime','Cover ispirata al leggendario Torneo Tenkaichi di Dragon Ball, con il celebre logo impresso sul retro in rilievo effetto metallo. Realizzata in TPU antiurto con bordi rinforzati, offre massima protezione e uno stile deciso per veri fan della saga. La stampa ad alta definizione garantisce durabilità nel tempo, mentre il profilo slim mantiene il comfort nell’utilizzo quotidiano. Un omaggio epico ai combattimenti più iconici dell’universo Dragon Ball.',0),(28,14.99,'Cover Dragon Ball Logo Drago Shenron','Anime','Cover unica ispirata al leggendario drago Shenron di Dragon Ball, con un’illustrazione dettagliata del logo in stile olografico sul retro. La combinazione di materiali antiurto e finiture soft-touch garantisce protezione elevata e comfort in ogni situazione. Il design cattura l’essenza mistica delle Sfere del Drago, rendendo omaggio al potere di evocare Shenron. Ideale per veri fan, questa cover fonde stile e funzionalità con un tocco epico e mitologico.',0),(29,14.99,'Cover Dragon Ball Logo Goku Base Form','Anime','Cover ispirata al logo iconico di Goku nella sua forma base, simbolo di determinazione e spirito combattivo. Realizzata con materiali resistenti agli urti e superficie anti-impronta, offre protezione senza rinunciare allo stile. Il logo, stampato in alta definizione con finitura opaca, spicca sul retro della cover, evocando le origini del Saiyan più amato. Perfetta per i fan che vogliono portare con sé la forza e la semplicità di Goku.',0),(30,39.99,'Ring Stand MagSafe','Accessori','Caricatore magnetico wireless compatibile con iPhone e dispositivi MagSafe. Si aggancia automaticamente al retro del telefono per una ricarica stabile e veloce fino a 15W. Design sottile ed elegante, perfetto da usare anche durante l’uso del dispositivo.',0);
/*!40000 ALTER TABLE `prodotto` ENABLE KEYS */; con
UNLOCK TABLES;

--
-- Table structure for table `registra`
--

DROP TABLE IF EXISTS `registra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registra` (
  `Username` varchar(50) NOT NULL,
  `IDMetodoPagamento` int NOT NULL,
  PRIMARY KEY (`Username`,`IDMetodoPagamento`),
  KEY `IDMetodoPagamento` (`IDMetodoPagamento`),
  CONSTRAINT `registra_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `utente` (`Username`) ON DELETE CASCADE,
  CONSTRAINT `registra_ibfk_2` FOREIGN KEY (`IDMetodoPagamento`) REFERENCES `metodo_di_pagamento` (`IdMetodoDiPagamento`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registra`
--

LOCK TABLES `registra` WRITE;
/*!40000 ALTER TABLE `registra` DISABLE KEYS */;
/*!40000 ALTER TABLE `registra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salva`
--

DROP TABLE IF EXISTS `salva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salva` (
  `Username` varchar(50) NOT NULL,
  `IDIndirizzo` int NOT NULL,
  PRIMARY KEY (`Username`,`IDIndirizzo`),
  KEY `IDIndirizzo` (`IDIndirizzo`),
  CONSTRAINT `salva_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `utente` (`Username`) ON DELETE CASCADE,
  CONSTRAINT `salva_ibfk_2` FOREIGN KEY (`IDIndirizzo`) REFERENCES `indirizzo` (`IDIndirizzo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salva`
--

LOCK TABLES `salva` WRITE;
/*!40000 ALTER TABLE `salva` DISABLE KEYS */;
INSERT INTO `salva` VALUES ('Emilio0408',17);
/*!40000 ALTER TABLE `salva` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utente` (
  `Username` varchar(50) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Cognome` varchar(50) NOT NULL,
  `Passw` varchar(255) NOT NULL,
  `IscrizioneNewsLetter` tinyint(1) DEFAULT '0',
  `IDListaPreferiti` int DEFAULT NULL,
  `ruolo` tinyint(1) DEFAULT '0',
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Username`),
  UNIQUE KEY `unique_email` (`email`),
  KEY `IDListaPreferiti` (`IDListaPreferiti`),
  CONSTRAINT `utente_ibfk_1` FOREIGN KEY (`IDListaPreferiti`) REFERENCES `preferiti` (`IDListaPreferiti`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES ('AntSquill00','Antonio','Squillante','c8cd8066ce15d020f3b75ff5221dacb8e70d6e21b0d811bebdeaf01d746c0b05',1,2,0,'antoniosquillante33@gmail.com'),('Emilio0408','Emilio','Maione','d36139769bb55e08fc550b0f68bedc208da20a41cc55fe546d47cb056242713a',1,1,1,'emiliomaione21@gmail.com'),('Gian00','Gianluca','Del Gaizo','edb7dfbe1f00e64f1544145a75d3edfc4a85040bf0ff546f29a51ce062b65df2',0,5,0,'gianludelgaizo@gmail.com'),('Giovannino09','Giovanni','Ricupito','12fb0f3cdbfb884814f1fe3dd7ac651f2ee7918f3ebd0a7d5dd74f7ba376ee20',0,3,0,'giovanniric90@gmail.com'),('VinPasc00','Vincenzo','Pascale','60aa29389b2140507fe0b6c36e81c6ddc637acc348ac99ac2d29c76cc82589f3',0,4,0,'vincenzopascal04@gmail.com');
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `varianti`
--

DROP TABLE IF EXISTS `varianti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `varianti` (
  `colore` varchar(30) NOT NULL,
  `modello` varchar(30) NOT NULL,
  PRIMARY KEY (`colore`,`modello`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `varianti`
--

LOCK TABLES `varianti` WRITE;
/*!40000 ALTER TABLE `varianti` DISABLE KEYS */;
INSERT INTO `varianti` VALUES ('Black','iPhone 12'),('Black','iPhone 12 mini'),('Black','iPhone 12 PRO'),('Black','iPhone 12 PRO MAX'),('Black','iPhone 13'),('Black','iPhone 13 mini'),('Black','iPhone 13 PRO'),('Black','iPhone 13 PRO MAX'),('Black','iPhone 14'),('Black','iPhone 14 PRO'),('Black','iPhone 14 PRO MAX'),('Black','iPhone 15'),('Black','iPhone 15 PRO'),('Black','iPhone 15 PRO MAX'),('Black','iPhone 16'),('Black','iPhone 16 PRO'),('Black','iPhone 16 PRO MAX'),('Blue','iPhone 12'),('Blue','iPhone 12 mini'),('Blue','iPhone 12 PRO'),('Blue','iPhone 12 PRO MAX'),('Blue','iPhone 13'),('Blue','iPhone 13 mini'),('Blue','iPhone 13 PRO'),('Blue','iPhone 13 PRO MAX'),('Blue','iPhone 14'),('Blue','iPhone 14 PRO'),('Blue','iPhone 14 PRO MAX'),('Blue','iPhone 15'),('Blue','iPhone 15 PRO'),('Blue','iPhone 15 PRO MAX'),('Blue','iPhone 16'),('Blue','iPhone 16 PRO'),('Blue','iPhone 16 PRO MAX'),('Bordeaux','iPhone 12'),('Bordeaux','iPhone 12 mini'),('Bordeaux','iPhone 12 PRO'),('Bordeaux','iPhone 12 PRO MAX'),('Bordeaux','iPhone 13'),('Bordeaux','iPhone 13 mini'),('Bordeaux','iPhone 13 PRO'),('Bordeaux','iPhone 13 PRO MAX'),('Bordeaux','iPhone 14'),('Bordeaux','iPhone 14 PRO'),('Bordeaux','iPhone 14 PRO MAX'),('Bordeaux','iPhone 15'),('Bordeaux','iPhone 15 PRO'),('Bordeaux','iPhone 15 PRO MAX'),('Bordeaux','iPhone 16'),('Bordeaux','iPhone 16 PRO'),('Bordeaux','iPhone 16 PRO MAX'),('Fucsia','iPhone 12'),('Fucsia','iPhone 12 mini'),('Fucsia','iPhone 12 PRO'),('Fucsia','iPhone 12 PRO MAX'),('Fucsia','iPhone 13'),('Fucsia','iPhone 13 mini'),('Fucsia','iPhone 13 PRO'),('Fucsia','iPhone 13 PRO MAX'),('Fucsia','iPhone 14'),('Fucsia','iPhone 14 PRO'),('Fucsia','iPhone 14 PRO MAX'),('Fucsia','iPhone 15'),('Fucsia','iPhone 15 PRO'),('Fucsia','iPhone 15 PRO MAX'),('Fucsia','iPhone 16'),('Fucsia','iPhone 16 PRO'),('Fucsia','iPhone 16 PRO MAX'),('Green','iPhone 12'),('Green','iPhone 12 mini'),('Green','iPhone 12 PRO'),('Green','iPhone 12 PRO MAX'),('Green','iPhone 13'),('Green','iPhone 13 mini'),('Green','iPhone 13 PRO'),('Green','iPhone 13 PRO MAX'),('Green','iPhone 14'),('Green','iPhone 14 PRO'),('Green','iPhone 14 PRO MAX'),('Green','iPhone 15'),('Green','iPhone 15 PRO'),('Green','iPhone 15 PRO MAX'),('Green','iPhone 16'),('Green','iPhone 16 PRO'),('Green','iPhone 16 PRO MAX'),('Grey','iPhone 14'),('Grey','iPhone 14 PRO'),('Grey','iPhone 14 PRO MAX'),('Grey','iPhone 15'),('Grey','iPhone 15 PRO'),('Grey','iPhone 15 PRO MAX'),('Grey','iPhone 16'),('Grey','iPhone 16 PRO'),('Grey','iPhone 16 PRO MAX'),('LightBlue','iPhone 12'),('LightBlue','iPhone 12 mini'),('LightBlue','iPhone 12 PRO'),('LightBlue','iPhone 12 PRO MAX'),('LightBlue','iPhone 13'),('LightBlue','iPhone 13 mini'),('LightBlue','iPhone 13 PRO'),('LightBlue','iPhone 13 PRO MAX'),('LightBlue','iPhone 14'),('LightBlue','iPhone 14 PRO'),('LightBlue','iPhone 14 PRO MAX'),('LightBlue','iPhone 15'),('LightBlue','iPhone 15 PRO'),('LightBlue','iPhone 15 PRO MAX'),('LightBlue','iPhone 16'),('LightBlue','iPhone 16 PRO'),('LightBlue','iPhone 16 PRO MAX'),('Red','iPhone 12'),('Red','iPhone 12 mini'),('Red','iPhone 12 PRO'),('Red','iPhone 12 PRO MAX'),('Red','iPhone 13'),('Red','iPhone 13 mini'),('Red','iPhone 13 PRO'),('Red','iPhone 13 PRO MAX'),('Red','iPhone 14'),('Red','iPhone 14 PRO'),('Red','iPhone 14 PRO MAX'),('Red','iPhone 15'),('Red','iPhone 15 PRO'),('Red','iPhone 15 PRO MAX'),('Red','iPhone 16'),('Red','iPhone 16 PRO'),('Red','iPhone 16 PRO MAX'),('White','iPhone 12'),('White','iPhone 12 mini'),('White','iPhone 12 PRO'),('White','iPhone 12 PRO MAX'),('White','iPhone 13'),('White','iPhone 13 mini'),('White','iPhone 13 PRO'),('White','iPhone 13 PRO MAX'),('White','iPhone 14'),('White','iPhone 14 PRO'),('White','iPhone 14 PRO MAX'),('White','iPhone 15'),('White','iPhone 15 PRO'),('White','iPhone 15 PRO MAX'),('White','iPhone 16'),('White','iPhone 16 PRO'),('White','iPhone 16 PRO MAX');
/*!40000 ALTER TABLE `varianti` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-07 16:09:47

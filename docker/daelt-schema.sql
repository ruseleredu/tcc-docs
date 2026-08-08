/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.3.2-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: daelt
-- ------------------------------------------------------
-- Server version	12.3.2-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

CREATE DATABASE IF NOT EXISTS daelt
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE daelt;

--
-- Table structure for table `ALUNOS`
--

DROP TABLE IF EXISTS `ALUNOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ALUNOS` (
  `ID` int(10) unsigned NOT NULL COMMENT 'Identificador único da tabela (id do aluno)',
  `NOME` char(255) NOT NULL COMMENT 'Nome do aluno',
  `EMAIL` char(255) NOT NULL COMMENT 'Email PRIMÁRIO para envio de informações',
  `DATA_INICIO` date NOT NULL COMMENT 'Data de ingresso no TCC',
  `DATA_FIM` date DEFAULT NULL COMMENT 'Data de desligamento do TCC',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição dos alunos do DAELT aptos para TCC';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ALUNOS_DISCIPLINAS`
--

DROP TABLE IF EXISTS `ALUNOS_DISCIPLINAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ALUNOS_DISCIPLINAS` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do relacionamento',
  `ID_ALUNO` int(10) unsigned NOT NULL COMMENT 'Identificador único da tabela (id do aluno)',
  `ID_DISCIPLINA` char(20) NOT NULL COMMENT 'Identificador da disciplina',
  `ID_TURMA` char(20) NOT NULL COMMENT 'Identificador da turma',
  `DATA_INICIO` date NOT NULL COMMENT 'Data de início do relacionamento',
  `DATA_FIM` date DEFAULT NULL COMMENT 'Data de desligamento do relacionamento',
  PRIMARY KEY (`ID`),
  KEY `ALUNOS_DISCIPLINAS_FK1` (`ID_DISCIPLINA`),
  KEY `ALUNOS_DISCIPLINAS_FK2` (`ID_ALUNO`),
  CONSTRAINT `ALUNOS_DISCIPLINAS_FK1` FOREIGN KEY (`ID_DISCIPLINA`) REFERENCES `DOMINIO_DISCIPLINAS` (`ID`),
  CONSTRAINT `ALUNOS_DISCIPLINAS_FK2` FOREIGN KEY (`ID_ALUNO`) REFERENCES `ALUNOS` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10456 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição do relacionamento entre alunos e disciplinas';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DOMINIO_DISCIPLINAS`
--

DROP TABLE IF EXISTS `DOMINIO_DISCIPLINAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DOMINIO_DISCIPLINAS` (
  `ID` char(20) NOT NULL COMMENT 'Código da disciplina',
  `ID_RESPONSAVEL` int(10) unsigned NOT NULL COMMENT 'Identificador do professor responsável',
  `ID_COORDENADOR` int(10) unsigned NOT NULL COMMENT 'Identificador do professor coordenador do curso',
  `ID_AGREGADOR` char(20) NOT NULL COMMENT 'Código agregador da disciplina',
  `NOME` char(255) NOT NULL COMMENT 'Nome da disciplina - por extenso',
  `CURSO` char(255) NOT NULL COMMENT 'Nome do curso da disciplina',
  `SIGLA` char(20) NOT NULL COMMENT 'Sigla interna da UTFPR',
  PRIMARY KEY (`ID`),
  KEY `DOMINIO_DISCIPLINAS_FK1` (`ID_RESPONSAVEL`),
  KEY `DOMINIO_DISCIPLINAS_FK2` (`ID_COORDENADOR`),
  CONSTRAINT `DOMINIO_DISCIPLINAS_FK1` FOREIGN KEY (`ID_RESPONSAVEL`) REFERENCES `PROFESSORES` (`ID`),
  CONSTRAINT `DOMINIO_DISCIPLINAS_FK2` FOREIGN KEY (`ID_COORDENADOR`) REFERENCES `PROFESSORES` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição das disciplinas do DAELT ligadas ao TCC';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GRUPOS`
--

DROP TABLE IF EXISTS `GRUPOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `GRUPOS` (
  `ID` int(10) unsigned NOT NULL COMMENT 'Identificador único da tabela',
  `NOME` char(100) NOT NULL COMMENT 'Nome do grupo',
  `ID_LIDER` int(10) unsigned NOT NULL COMMENT 'Identificador do professor líder',
  PRIMARY KEY (`ID`),
  KEY `GRUPOS_FK1` (`ID_LIDER`),
  CONSTRAINT `GRUPOS_FK1` FOREIGN KEY (`ID_LIDER`) REFERENCES `PROFESSORES` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição dos grupos de pesquisa do DAELT';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PROFESSORES`
--

DROP TABLE IF EXISTS `PROFESSORES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROFESSORES` (
  `ID` int(10) unsigned NOT NULL COMMENT 'Identificador único da tabela',
  `NOME` char(255) NOT NULL COMMENT 'Nome do professor/externo',
  `EMAIL` char(255) DEFAULT NULL COMMENT 'Email PRIMÁRIO para envio de informações',
  `EMAIL2` char(255) DEFAULT NULL COMMENT 'Email SECUNDÁRIO para envio de informações',
  `EFETIVO` tinyint(1) NOT NULL COMMENT 'Professor efetivo ou não do DAELT',
  `DATA_INICIO` date NOT NULL COMMENT 'Data de ingresso no DAELT/SISTEMA',
  `DATA_FIM` date DEFAULT NULL COMMENT 'Data de desligamento do DAELT/SISTEMA',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição dos professores do DAELT aptos para TCC';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PROFESSORES_GRUPOS`
--

DROP TABLE IF EXISTS `PROFESSORES_GRUPOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROFESSORES_GRUPOS` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do relacionamento',
  `ID_PROFESSOR` int(10) unsigned NOT NULL COMMENT 'Identificador do professor',
  `ID_GRUPO` int(10) unsigned NOT NULL COMMENT 'Identificador do grupo',
  `DATA_INICIO` date NOT NULL COMMENT 'Data de ingresso no grupo',
  `DATA_FIM` date DEFAULT NULL COMMENT 'Data de desligamento do grupo',
  PRIMARY KEY (`ID`),
  KEY `PROFESSORES_GRUPOS_FK1` (`ID_PROFESSOR`),
  KEY `PROFESSORES_GRUPOS_FK2` (`ID_GRUPO`),
  CONSTRAINT `PROFESSORES_GRUPOS_FK1` FOREIGN KEY (`ID_PROFESSOR`) REFERENCES `PROFESSORES` (`ID`),
  CONSTRAINT `PROFESSORES_GRUPOS_FK2` FOREIGN KEY (`ID_GRUPO`) REFERENCES `GRUPOS` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=383 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição do relacionamento entre professores e grupos do ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PROFESSORES_INTERESSES`
--

DROP TABLE IF EXISTS `PROFESSORES_INTERESSES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROFESSORES_INTERESSES` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do relacionamento',
  `ID_PROFESSOR` int(10) unsigned NOT NULL COMMENT 'Identificador do professor',
  `INTERESSE` varchar(255) NOT NULL COMMENT 'Nome do interesse',
  PRIMARY KEY (`ID`),
  KEY `PROFESSORES_INTERESSES_FK1` (`ID_PROFESSOR`),
  CONSTRAINT `PROFESSORES_INTERESSES_FK1` FOREIGN KEY (`ID_PROFESSOR`) REFERENCES `PROFESSORES` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição do relacionamento entre professores e interesses';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PROFESSORES_TEMAS`
--

DROP TABLE IF EXISTS `PROFESSORES_TEMAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROFESSORES_TEMAS` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do relacionamento',
  `ID_PROFESSOR` int(10) unsigned NOT NULL COMMENT 'Identificador do professor',
  `TEMA` varchar(255) NOT NULL COMMENT 'Nome do tema de interesse',
  PRIMARY KEY (`ID`),
  KEY `PROFESSORES_TEMAS_FK1` (`ID_PROFESSOR`),
  CONSTRAINT `PROFESSORES_TEMAS_FK1` FOREIGN KEY (`ID_PROFESSOR`) REFERENCES `PROFESSORES` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição do relacionamento entre professores e temas';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-08-08  9:37:40

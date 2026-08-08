/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.3.2-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: tcc
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

CREATE DATABASE IF NOT EXISTS tcc
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tcc;

--
-- Table structure for table `AGREGADOR_DOCUMENTOS`
--

DROP TABLE IF EXISTS `AGREGADOR_DOCUMENTOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AGREGADOR_DOCUMENTOS` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único de relacionamento',
  `ID_AGREGADOR` char(20) NOT NULL COMMENT 'Código de agregação de documentos',
  `ID_DOCUMENTO` int(10) unsigned NOT NULL COMMENT 'Identificador do documento necessário',
  `DATA_LIMITE_ATUAL` date NOT NULL COMMENT 'Data limite ATUAL para o documento',
  PRIMARY KEY (`ID`),
  KEY `AGREGADOR_DOCUMENTOS_FK` (`ID_DOCUMENTO`),
  CONSTRAINT `AGREGADOR_DOCUMENTOS_FK` FOREIGN KEY (`ID_DOCUMENTO`) REFERENCES `DOCUMENTOS` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Agregador de documentos para facilitar inclusão de equipes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `BANCAS_EQUIPES`
--

DROP TABLE IF EXISTS `BANCAS_EQUIPES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BANCAS_EQUIPES` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único da BANCA',
  `ID_TIPO` int(10) unsigned NOT NULL COMMENT 'Se é referente a TCC1, TCC2, etc.',
  `ID_EQUIPE` char(50) NOT NULL COMMENT 'Id da equipe de TCC',
  `NOTA` float unsigned zerofill DEFAULT NULL COMMENT 'Nota atribuída à equipe',
  `DATA_APRESENTACAO` date DEFAULT NULL COMMENT 'Data de apresentacao perante a banca',
  `HORA_APRESENTACAO` time DEFAULT NULL COMMENT 'Horário de apresentação perante a banca',
  `DATA_INICIO` date NOT NULL COMMENT 'Data de início desta formação de banca',
  `DATA_FIM` date DEFAULT NULL COMMENT 'Data de encerramento desta formação de banca',
  PRIMARY KEY (`ID`),
  KEY `BANCAS_EQUIPES_FK_1` (`ID_TIPO`),
  KEY `BANCAS_EQUIPES_FK_2` (`ID_EQUIPE`),
  CONSTRAINT `BANCAS_EQUIPES_FK_1` FOREIGN KEY (`ID_TIPO`) REFERENCES `DOMINIO_BANCAS` (`ID`),
  CONSTRAINT `BANCAS_EQUIPES_FK_2` FOREIGN KEY (`ID_EQUIPE`) REFERENCES `EQUIPES` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3929 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Relacionamento entre bancas e equipes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `BANCAS_PROFESSORES`
--

DROP TABLE IF EXISTS `BANCAS_PROFESSORES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BANCAS_PROFESSORES` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do relacionamento',
  `ID_BANCA` int(10) unsigned NOT NULL COMMENT 'Identificador da banca',
  `ID_PROFESSOR` int(10) unsigned NOT NULL COMMENT 'Identificador do professor desta banca',
  PRIMARY KEY (`ID`),
  KEY `BANCAS_PROFESSORES_FK1` (`ID_BANCA`),
  KEY `BANCAS_PROFESSORES_FK2` (`ID_PROFESSOR`),
  CONSTRAINT `BANCAS_PROFESSORES_FK1` FOREIGN KEY (`ID_BANCA`) REFERENCES `BANCAS_EQUIPES` (`ID`),
  CONSTRAINT `BANCAS_PROFESSORES_FK2` FOREIGN KEY (`ID_PROFESSOR`) REFERENCES `DAELT`.`PROFESSORES` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8542 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Relacionamento entre bancas e membros/professores';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DOCUMENTOS`
--

DROP TABLE IF EXISTS `DOCUMENTOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DOCUMENTOS` (
  `ID` int(10) unsigned NOT NULL COMMENT 'Identificador do documento necessário',
  `NOME` char(255) NOT NULL COMMENT 'Nome do documento necessário',
  `ID_DEVEDOR` int(10) unsigned NOT NULL COMMENT 'Código de quem deve o documento',
  PRIMARY KEY (`ID`),
  KEY `DOCUMENTOS_FK` (`ID_DEVEDOR`),
  CONSTRAINT `DOCUMENTOS_FK` FOREIGN KEY (`ID_DEVEDOR`) REFERENCES `DOMINIO_DEVEDORES` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição dos documentos necessários para TCC';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DOMINIO_BANCAS`
--

DROP TABLE IF EXISTS `DOMINIO_BANCAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DOMINIO_BANCAS` (
  `ID` int(10) unsigned NOT NULL COMMENT 'Identificador único de um tipo',
  `NOME` char(255) DEFAULT NULL COMMENT 'Nome do tipo, indicando tipo de banca',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição dos tipos de atividades de banca (TCC1, TCC2, et';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DOMINIO_DEVEDORES`
--

DROP TABLE IF EXISTS `DOMINIO_DEVEDORES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DOMINIO_DEVEDORES` (
  `ID` int(10) unsigned NOT NULL COMMENT 'Identificador único de um devedor',
  `NOME` char(255) DEFAULT NULL COMMENT 'Nome de um devedor',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição dos devedores (EQUIPE, ORIENTADOR, LIDER, BANCA)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EQUIPES`
--

DROP TABLE IF EXISTS `EQUIPES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EQUIPES` (
  `ID` char(50) NOT NULL COMMENT 'Identificador único da tabela (id usado pelo DAELT)',
  `TITULO` char(255) NOT NULL COMMENT 'Título do trabalho',
  `ATIVA` tinyint(1) NOT NULL COMMENT 'Indica se equipe está ativa ou não',
  `ID_LIDER` int(10) unsigned NOT NULL COMMENT 'Identificador do professor que gere avaliação da proposta',
  `DATA_INICIO` date NOT NULL COMMENT 'Data de início da equipe',
  `DATA_FIM` date DEFAULT NULL COMMENT 'Data de encerramento da equipe',
  PRIMARY KEY (`ID`),
  KEY `EQUIPES_LIDERES_FK` (`ID_LIDER`),
  CONSTRAINT `EQUIPES_LIDERES_FK` FOREIGN KEY (`ID_LIDER`) REFERENCES `DAELT`.`PROFESSORES` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Descrição das equipes de alunos formados para TCC';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EQUIPES_ALUNOS`
--

DROP TABLE IF EXISTS `EQUIPES_ALUNOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EQUIPES_ALUNOS` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do relacionamento',
  `ID_EQUIPE` char(50) NOT NULL COMMENT 'Identificador da equipe',
  `ID_ALUNO` int(10) unsigned NOT NULL COMMENT 'Identificador do aluno pertencente a equipe',
  `DATA_INICIO` date NOT NULL COMMENT 'Data de início deste relacionamento',
  `DATA_FIM` date DEFAULT NULL COMMENT 'Data de encerramento deste relacionamento',
  PRIMARY KEY (`ID`),
  KEY `EQUIPES_ALUNOS_FK1` (`ID_EQUIPE`),
  KEY `EQUIPES_ALUNOS_FK2` (`ID_ALUNO`),
  CONSTRAINT `EQUIPES_ALUNOS_FK1` FOREIGN KEY (`ID_EQUIPE`) REFERENCES `EQUIPES` (`ID`),
  CONSTRAINT `EQUIPES_ALUNOS_FK2` FOREIGN KEY (`ID_ALUNO`) REFERENCES `DAELT`.`ALUNOS` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2631 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Relacionamento entre equipes e alunos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EQUIPES_DISCIPLINAS`
--

DROP TABLE IF EXISTS `EQUIPES_DISCIPLINAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EQUIPES_DISCIPLINAS` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do relacionamento',
  `ID_EQUIPE` char(50) NOT NULL COMMENT 'Identificador da equipe',
  `ID_DISCIPLINA` char(20) NOT NULL COMMENT 'Identificador da disciplina',
  `ID_TURMA` char(20) NOT NULL COMMENT 'Identificador da turma',
  `DATA_INICIO` date NOT NULL COMMENT 'Data de início da disciplina',
  `DATA_FIM` date DEFAULT NULL COMMENT 'Data de encerramento da disciplina',
  PRIMARY KEY (`ID`),
  KEY `EQUIPES_DISCIPLINAS_FK1` (`ID_EQUIPE`),
  KEY `EQUIPES_DISCIPLINAS_FK2` (`ID_DISCIPLINA`),
  CONSTRAINT `EQUIPES_DISCIPLINAS_FK1` FOREIGN KEY (`ID_EQUIPE`) REFERENCES `EQUIPES` (`ID`),
  CONSTRAINT `EQUIPES_DISCIPLINAS_FK2` FOREIGN KEY (`ID_DISCIPLINA`) REFERENCES `DAELT`.`DOMINIO_DISCIPLINAS` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4192 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Relacionamento entre equipes e disciplinas';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EQUIPES_DOCUMENTOS`
--

DROP TABLE IF EXISTS `EQUIPES_DOCUMENTOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EQUIPES_DOCUMENTOS` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do relacionamento',
  `ID_EQUIPE` char(50) NOT NULL COMMENT 'Id da equipe de TCC',
  `ID_DOCUMENTO` int(10) unsigned NOT NULL COMMENT 'Id do documento necessário',
  `DATA_LIMITE` date NOT NULL COMMENT 'Data limite para entrega de documento',
  `DATA` date DEFAULT NULL COMMENT 'Data de entrega do documento',
  `FORCADO` tinyint(1) NOT NULL COMMENT 'Indicativo de registro sem documento (força encerramento)',
  PRIMARY KEY (`ID`),
  KEY `EQUIPES_DOCUMENTOS_FK1` (`ID_EQUIPE`),
  KEY `EQUIPES_DOCUMENTOS_FK2` (`ID_DOCUMENTO`),
  CONSTRAINT `EQUIPES_DOCUMENTOS_FK1` FOREIGN KEY (`ID_EQUIPE`) REFERENCES `EQUIPES` (`ID`),
  CONSTRAINT `EQUIPES_DOCUMENTOS_FK2` FOREIGN KEY (`ID_DOCUMENTO`) REFERENCES `DOCUMENTOS` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16909 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Relacionamento entre documentos e equipes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EQUIPES_ORIENTADORES`
--

DROP TABLE IF EXISTS `EQUIPES_ORIENTADORES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `EQUIPES_ORIENTADORES` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do relacionamento',
  `ID_EQUIPE` char(50) NOT NULL COMMENT 'Identificador da equipe',
  `ID_ORIENTADOR` int(10) unsigned NOT NULL COMMENT 'Identificador do orientador da equipe',
  `ORIENTACAO` tinyint(1) NOT NULL COMMENT 'Indicador de orientacao (TRUE) ou co-orientacao (FALSE)',
  `DATA_INICIO` date NOT NULL COMMENT 'Data de início deste relacionamento',
  `DATA_FIM` date DEFAULT NULL COMMENT 'Data de encerramento deste relacionamento',
  PRIMARY KEY (`ID`),
  KEY `EQUIPES_ORIENTADORES_FK_1` (`ID_EQUIPE`),
  KEY `EQUIPES_ORIENTADORES_FK_2` (`ID_ORIENTADOR`),
  CONSTRAINT `EQUIPES_ORIENTADORES_FK_1` FOREIGN KEY (`ID_EQUIPE`) REFERENCES `EQUIPES` (`ID`),
  CONSTRAINT `EQUIPES_ORIENTADORES_FK_2` FOREIGN KEY (`ID_ORIENTADOR`) REFERENCES `DAELT`.`PROFESSORES` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1625 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='Relacionamento entre equipes e orientadores';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-08-08  9:37:28

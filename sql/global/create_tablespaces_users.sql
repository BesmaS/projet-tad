-- =============================================================
-- A executer en tant que SYSDBA sur oracle_xe
-- =============================================================

-- -------------------------------------------------------------
-- TABLESPACES
-- -------------------------------------------------------------

--  Cergy
CREATE TABLESPACE TS_CERGY_DATA
    DATAFILE 'ts_cergy_data.dbf' SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 500M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

--  Pau
CREATE TABLESPACE TS_PAU_DATA
    DATAFILE 'ts_pau_data.dbf' SIZE 50M AUTOEXTEND ON NEXT 10M MAXSIZE 500M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- Index des deux sites
CREATE TABLESPACE TS_INDEX
    DATAFILE 'ts_index.dbf' SIZE 30M AUTOEXTEND ON NEXT 5M MAXSIZE 200M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- Historique des affectations
CREATE TABLESPACE TS_HISTO
    DATAFILE 'ts_histo.dbf' SIZE 20M AUTOEXTEND ON NEXT 5M MAXSIZE 200M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- -------------------------------------------------------------
-- UTILISATEURS ORACLE
-- -------------------------------------------------------------

-- Administrateur global
CREATE USER glpi_global IDENTIFIED BY "glpi123"
    DEFAULT TABLESPACE TS_CERGY_DATA
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON TS_CERGY_DATA
    QUOTA UNLIMITED ON TS_PAU_DATA
    QUOTA UNLIMITED ON TS_INDEX
    QUOTA UNLIMITED ON TS_HISTO;

-- Utilisateur site Cergy
CREATE USER glpi_cergy IDENTIFIED BY "glpi123"
    DEFAULT TABLESPACE TS_CERGY_DATA
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON TS_CERGY_DATA
    QUOTA UNLIMITED ON TS_INDEX
    QUOTA UNLIMITED ON TS_HISTO;

-- Utilisateur site Pau
CREATE USER glpi_pau IDENTIFIED BY "glpi123!"
    DEFAULT TABLESPACE TS_PAU_DATA
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON TS_PAU_DATA
    QUOTA UNLIMITED ON TS_INDEX
    QUOTA UNLIMITED ON TS_HISTO;

-- Utilisateur lecture seule (reporting)
CREATE USER glpi_readonly IDENTIFIED BY "glpi123!"
    DEFAULT TABLESPACE TS_CERGY_DATA
    TEMPORARY TABLESPACE TEMP;

-- -------------------------------------------------------------
-- ROLES ORACLE
-- -------------------------------------------------------------

CREATE ROLE role_admin_global;
CREATE ROLE role_technicien;
CREATE ROLE role_lecture;

-- Droits role admin global
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE,
      CREATE TRIGGER, CREATE SEQUENCE, CREATE INDEX,
      CREATE DATABASE LINK TO role_admin_global;

-- Droits role technicien
GRANT CREATE SESSION TO role_technicien;

-- Droits role lecture
GRANT CREATE SESSION TO role_lecture;

-- -------------------------------------------------------------
-- ATTRIBUTION DES ROLES
-- -------------------------------------------------------------

GRANT role_admin_global TO glpi_global;
GRANT role_technicien   TO glpi_cergy;
GRANT role_technicien   TO glpi_pau;
GRANT role_lecture      TO glpi_readonly;

-- -------------------------------------------------------------
-- PRIVILEGES OBJET glpi_cergy
-- -------------------------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_cergy.USERS             TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_cergy.COMPUTERS         TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_cergy.TICKETS           TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_cergy.NETWORKS          TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_cergy.SOFTWARES         TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_cergy.LOCATIONS         TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_cergy.HISTO_AFFECTATION TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_cergy.VLAN              TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_cergy.EQUIPEMENT_RESEAU TO glpi_global;

GRANT SELECT ON glpi_cergy.USERS     TO glpi_readonly;
GRANT SELECT ON glpi_cergy.COMPUTERS TO glpi_readonly;
GRANT SELECT ON glpi_cergy.TICKETS   TO glpi_readonly;

-- -------------------------------------------------------------
-- PRIVILEGES OBJET glpi_pau
-- -------------------------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_pau.USERS             TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_pau.COMPUTERS         TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_pau.TICKETS           TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_pau.NETWORKS          TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_pau.SOFTWARES         TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_pau.LOCATIONS         TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_pau.HISTO_AFFECTATION TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_pau.VLAN              TO glpi_global;
GRANT SELECT, INSERT, UPDATE, DELETE ON glpi_pau.EQUIPEMENT_RESEAU TO glpi_global;

GRANT SELECT ON glpi_pau.USERS     TO glpi_readonly;
GRANT SELECT ON glpi_pau.COMPUTERS TO glpi_readonly;
GRANT SELECT ON glpi_pau.TICKETS   TO glpi_readonly;
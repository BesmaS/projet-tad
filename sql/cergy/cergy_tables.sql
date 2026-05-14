-- =============================================================
-- TABLES CERGY
-- A executer sur glpi_cergy
-- =============================================================

-- -------------------------------------------------------------
-- LOCATIONS (inspire de glpi_locations)
-- Batiment et salle physique
-- -------------------------------------------------------------
CREATE TABLE LOCATIONS (
    location_id NUMBER PRIMARY KEY,
    building    VARCHAR2(100) NOT NULL,
    room        VARCHAR2(50),
    floor       VARCHAR2(20),
    site_id     NUMBER DEFAULT 1
) TABLESPACE TS_CERGY_DATA;

-- -------------------------------------------------------------
-- USERS
-- -------------------------------------------------------------
CREATE TABLE USERS (
    user_id     NUMBER PRIMARY KEY,
    username    VARCHAR2(50)  UNIQUE NOT NULL,
    first_name  VARCHAR2(50),
    last_name   VARCHAR2(50),
    email       VARCHAR2(100) UNIQUE,
    role_id     NUMBER        NOT NULL,
    site_id     NUMBER        DEFAULT 1,
    location_id NUMBER,
    status      VARCHAR2(20)  DEFAULT 'ACTIF',

    CONSTRAINT fk_cergy_user_location
        FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id)
) TABLESPACE TS_CERGY_DATA;

-- -------------------------------------------------------------
-- VLAN (inspire de glpi_vlans)
-- Un meme numero de VLAN peut exister sur deux sites differents
-- La contrainte d unicite est sur (site_id, vlan_number)
-- -------------------------------------------------------------
CREATE TABLE VLAN (
    vlan_id     NUMBER PRIMARY KEY,
    vlan_number NUMBER        NOT NULL,
    vlan_name   VARCHAR2(100),
    site_id     NUMBER        DEFAULT 1,

    CONSTRAINT uk_cergy_vlan_site UNIQUE (site_id, vlan_number)
) TABLESPACE TS_CERGY_DATA;

-- -------------------------------------------------------------
-- NETWORKS
-- -------------------------------------------------------------
CREATE TABLE NETWORKS (
    network_id   NUMBER PRIMARY KEY,
    network_name VARCHAR2(100),
    ip_range     VARCHAR2(50),
    gateway      VARCHAR2(50),
    vlan_id      NUMBER,
    site_id      NUMBER DEFAULT 1,

    CONSTRAINT fk_cergy_network_vlan
        FOREIGN KEY (vlan_id) REFERENCES VLAN(vlan_id)
) TABLESPACE TS_CERGY_DATA;

-- -------------------------------------------------------------
-- EQUIPEMENT_RESEAU (inspire de glpi_networkequipments)
-- Switchs, routeurs, bornes Wi-Fi
-- -------------------------------------------------------------
CREATE TABLE EQUIPEMENT_RESEAU (
    equip_id    NUMBER PRIMARY KEY,
    equip_name  VARCHAR2(100) NOT NULL,
    equip_type  VARCHAR2(50),             -- SWITCH, ROUTER, WIFI_AP, FIREWALL
    brand       VARCHAR2(50),
    model       VARCHAR2(50),
    ip_mgmt     VARCHAR2(50) UNIQUE,
    location_id NUMBER,
    site_id     NUMBER DEFAULT 1,

    CONSTRAINT fk_cergy_equip_location
        FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id)
) TABLESPACE TS_CERGY_DATA;

-- -------------------------------------------------------------
-- COMPUTERS
-- -------------------------------------------------------------
CREATE TABLE COMPUTERS (
    computer_id      NUMBER PRIMARY KEY,
    inventory_number VARCHAR2(50)  UNIQUE NOT NULL,
    computer_name    VARCHAR2(100),
    serial_number    VARCHAR2(100),
    brand            VARCHAR2(50),
    model            VARCHAR2(50),
    computer_type    VARCHAR2(40)  DEFAULT 'DESKTOP',
    purchase_date    DATE,
    status           VARCHAR2(30),
    assigned_user    NUMBER,
    location_id      NUMBER,
    site_id          NUMBER DEFAULT 1,

    CONSTRAINT fk_cergy_computer_user
        FOREIGN KEY (assigned_user) REFERENCES USERS(user_id),

    CONSTRAINT fk_cergy_computer_location
        FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id)
) TABLESPACE TS_CERGY_DATA;

-- -------------------------------------------------------------
-- SOFTWARES
-- -------------------------------------------------------------
CREATE TABLE SOFTWARES (
    software_id   NUMBER PRIMARY KEY,
    software_name VARCHAR2(100) NOT NULL,
    version       VARCHAR2(50),
    license_type  VARCHAR2(50),
    editor        VARCHAR2(100)
) TABLESPACE TS_CERGY_DATA;

-- -------------------------------------------------------------
-- COMPUTER_SOFTWARES
-- -------------------------------------------------------------
CREATE TABLE COMPUTER_SOFTWARES (
    computer_id  NUMBER,
    software_id  NUMBER,
    install_date DATE DEFAULT SYSDATE,

    PRIMARY KEY (computer_id, software_id),

    CONSTRAINT fk_cergy_cs_computer
        FOREIGN KEY (computer_id) REFERENCES COMPUTERS(computer_id),

    CONSTRAINT fk_cergy_cs_software
        FOREIGN KEY (software_id) REFERENCES SOFTWARES(software_id)
) TABLESPACE TS_CERGY_DATA;

-- -------------------------------------------------------------
-- TICKETS
-- -------------------------------------------------------------
CREATE TABLE TICKETS (
    ticket_id     NUMBER PRIMARY KEY,
    title         VARCHAR2(200) NOT NULL,
    description   VARCHAR2(1000),
    priority      VARCHAR2(20)  CHECK (priority IN ('LOW','MEDIUM','HIGH','CRITICAL')),
    status        VARCHAR2(20)  CHECK (status IN ('OPEN','IN_PROGRESS','RESOLVED','CLOSED')),
    creation_date DATE          DEFAULT SYSDATE,
    close_date    DATE,
    created_by    NUMBER,
    assigned_to   NUMBER,
    computer_id   NUMBER,
    site_id       NUMBER DEFAULT 1,

    CONSTRAINT fk_cergy_ticket_creator
        FOREIGN KEY (created_by)  REFERENCES USERS(user_id),

    CONSTRAINT fk_cergy_ticket_assigned
        FOREIGN KEY (assigned_to) REFERENCES USERS(user_id),

    CONSTRAINT fk_cergy_ticket_computer
        FOREIGN KEY (computer_id) REFERENCES COMPUTERS(computer_id)
) TABLESPACE TS_CERGY_DATA;

-- -------------------------------------------------------------
-- HISTO_AFFECTATION (inspire de glpi : historique des affectations)
-- Trace qui a eu quel materiel et quand
-- -------------------------------------------------------------
CREATE TABLE HISTO_AFFECTATION (
    histo_id    NUMBER PRIMARY KEY,
    computer_id NUMBER NOT NULL,
    user_id     NUMBER NOT NULL,
    date_debut  DATE   NOT NULL,
    date_fin    DATE,
    site_id     NUMBER DEFAULT 1,

    CONSTRAINT fk_cergy_histo_computer
        FOREIGN KEY (computer_id) REFERENCES COMPUTERS(computer_id),

    CONSTRAINT fk_cergy_histo_user
        FOREIGN KEY (user_id) REFERENCES USERS(user_id)
) TABLESPACE TS_HISTO;

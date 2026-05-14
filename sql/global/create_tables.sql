-- =============================================================
-- TABLES GLOBALES : SITES et ROLES
-- A executer sur GLPI_GLOBAL
-- =============================================================

CREATE TABLE SITES (
    site_id   NUMBER PRIMARY KEY,
    site_name VARCHAR2(100) NOT NULL,
    city      VARCHAR2(100) NOT NULL,
    actif     CHAR(1) DEFAULT 'O' CHECK (actif IN ('O','N'))
);

CREATE TABLE ROLES (
    role_id     NUMBER PRIMARY KEY,
    role_name   VARCHAR2(50) UNIQUE NOT NULL,
    description VARCHAR2(255)
);

INSERT INTO SITES VALUES (1, 'CY Tech Cergy', 'Cergy', 'O');
INSERT INTO SITES VALUES (2, 'CY Tech Pau',   'Pau',   'O');

INSERT INTO ROLES VALUES (1, 'ADMIN_GLOBAL', 'Administrateur global du parc informatique');
INSERT INTO ROLES VALUES (2, 'TECHNICIAN',   'Technicien informatique local');
INSERT INTO ROLES VALUES (3, 'USER',         'Utilisateur ou etudiant');

COMMIT;

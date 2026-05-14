-- =============================================================
-- DONNEES INITIALES GLOBALES
-- A executer sur GLPI_GLOBAL
-- =============================================================

INSERT INTO SITES VALUES (1, 'CY Tech Cergy', 'Cergy', 'O');
INSERT INTO SITES VALUES (2, 'CY Tech Pau',   'Pau',   'O');

INSERT INTO ROLES VALUES (1, 'ADMIN_GLOBAL', 'Administrateur global du parc informatique');
INSERT INTO ROLES VALUES (2, 'TECHNICIAN',   'Technicien informatique local');
INSERT INTO ROLES VALUES (3, 'USER',         'Utilisateur ou etudiant');

COMMIT;

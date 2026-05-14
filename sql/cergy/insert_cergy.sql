-- =============================================================
-- DONNEES INITIALES CERGY
-- A executer sur glpi_cergy
-- =============================================================

-- LOCATIONS
INSERT INTO LOCATIONS VALUES (1, 'Batiment-A', 'Salle-101', 'RDC',   1);
INSERT INTO LOCATIONS VALUES (2, 'Batiment-A', 'Salle-201', '1er',   1);
INSERT INTO LOCATIONS VALUES (3, 'Batiment-B', 'Salle-101', 'RDC',   1);
INSERT INTO LOCATIONS VALUES (4, 'Batiment-B', 'Salle-301', '2eme',  1);

-- USERS
INSERT INTO USERS VALUES (1, 'admin.cergy', 'Admin', 'Cergy', 'admin.cergy@cy-tech.fr', 1, 1, 1, 'ACTIF');
INSERT INTO USERS VALUES (2, 'tech.cergy',  'Tech',  'Cergy', 'tech.cergy@cy-tech.fr',  2, 1, 1, 'ACTIF');
INSERT INTO USERS VALUES (3, 'besma.saidi', 'Besma', 'Saidi', 'besma.saidi@cy-tech.fr', 3, 1, 2, 'ACTIF');

-- VLAN
INSERT INTO VLAN VALUES (1, 10, 'VLAN-ADMIN-CERGY',    1);
INSERT INTO VLAN VALUES (2, 20, 'VLAN-ETUDIANT-CERGY', 1);
INSERT INTO VLAN VALUES (3, 30, 'VLAN-SERVEURS-CERGY', 1);

-- NETWORKS
INSERT INTO NETWORKS VALUES (1, 'Cergy Admin Network',   '192.168.1.0/24',  '192.168.1.1',  1, 1);
INSERT INTO NETWORKS VALUES (2, 'Cergy Student Network', '192.168.10.0/24', '192.168.10.1', 2, 1);
INSERT INTO NETWORKS VALUES (3, 'Cergy Server Network',  '10.1.0.0/24',     '10.1.0.1',     3, 1);

-- EQUIPEMENTS RESEAU
INSERT INTO EQUIPEMENT_RESEAU VALUES (1, 'SW-CERGY-CORE-01', 'SWITCH',   'Cisco',    'Catalyst 2960', '10.1.0.1', 1, 1);
INSERT INTO EQUIPEMENT_RESEAU VALUES (2, 'RT-CERGY-MAIN-01', 'ROUTER',   'Cisco',    'ISR 4331',      '10.1.0.2', 1, 1);
INSERT INTO EQUIPEMENT_RESEAU VALUES (3, 'AP-CERGY-A101',    'WIFI_AP',  'Ubiquiti', 'UniFi AP AC',   '10.1.1.1', 1, 1);
INSERT INTO EQUIPEMENT_RESEAU VALUES (4, 'FW-CERGY-01',      'FIREWALL', 'Fortinet', 'FortiGate 60F', '10.1.0.254', 1, 1);

-- COMPUTERS
INSERT INTO COMPUTERS VALUES (1, 'CERGY-PC-001', 'PC-BESMA',  'SN-CERGY-001',
    'Dell', 'OptiPlex',   'DESKTOP',
    TO_DATE('2024-01-10','YYYY-MM-DD'), 'ACTIVE', 3, 2, 1);

INSERT INTO COMPUTERS VALUES (2, 'CERGY-PC-002', 'PC-TECH',   'SN-CERGY-002',
    'HP',   'EliteOne',   'DESKTOP',
    TO_DATE('2023-06-15','YYYY-MM-DD'), 'ACTIVE', 2, 1, 1);

INSERT INTO COMPUTERS VALUES (3, 'CERGY-LT-001', 'LAPTOP-01', 'SN-CERGY-003',
    'Lenovo', 'ThinkPad', 'LAPTOP',
    TO_DATE('2024-03-20','YYYY-MM-DD'), 'ACTIVE', 3, 3, 1);

-- SOFTWARES
INSERT INTO SOFTWARES VALUES (1, 'Oracle Database', '21c',  'Enterprise', 'Oracle');
INSERT INTO SOFTWARES VALUES (2, 'Microsoft Office','2021', 'Volume',     'Microsoft');
INSERT INTO SOFTWARES VALUES (3, 'Antivirus Pro',   '5.2',  'Entreprise', 'Symantec');
INSERT INTO SOFTWARES VALUES (4, 'Visual Studio',   '2022', 'Education',  'Microsoft');

INSERT INTO COMPUTER_SOFTWARES VALUES (1, 1, SYSDATE);
INSERT INTO COMPUTER_SOFTWARES VALUES (1, 2, SYSDATE);
INSERT INTO COMPUTER_SOFTWARES VALUES (2, 2, SYSDATE);
INSERT INTO COMPUTER_SOFTWARES VALUES (2, 3, SYSDATE);
INSERT INTO COMPUTER_SOFTWARES VALUES (3, 2, SYSDATE);
INSERT INTO COMPUTER_SOFTWARES VALUES (3, 4, SYSDATE);

-- TICKETS
INSERT INTO TICKETS VALUES (1, 'Printer issue',    'Printer not responding',   'HIGH',     'OPEN',        SYSDATE,    NULL,       3, 2, 1, 1);
INSERT INTO TICKETS VALUES (2, 'Screen flicker',   'Monitor flickering',       'MEDIUM',   'IN_PROGRESS', SYSDATE-2,  NULL,       3, 2, 1, 1);
INSERT INTO TICKETS VALUES (3, 'Keyboard broken',  'Keys not working',         'LOW',      'RESOLVED',    SYSDATE-10, SYSDATE-3,  3, 2, 2, 1);
INSERT INTO TICKETS VALUES (4, 'Slow computer',    'Boot takes 10 minutes',    'HIGH',     'OPEN',        SYSDATE-1,  NULL,       3, 2, 3, 1);
INSERT INTO TICKETS VALUES (5, 'No internet',      'Cannot access internet',   'CRITICAL', 'IN_PROGRESS', SYSDATE,    NULL,       3, 2, 2, 1);

-- HISTO AFFECTATION
INSERT INTO HISTO_AFFECTATION VALUES (1, 1, 3, TO_DATE('2024-01-10','YYYY-MM-DD'), NULL,       1);
INSERT INTO HISTO_AFFECTATION VALUES (2, 2, 2, TO_DATE('2023-06-15','YYYY-MM-DD'), NULL,       1);
INSERT INTO HISTO_AFFECTATION VALUES (3, 3, 3, TO_DATE('2024-03-20','YYYY-MM-DD'), NULL,       1);
-- Ancien utilisateur du PC 1 avant Besma
INSERT INTO HISTO_AFFECTATION VALUES (4, 1, 2, TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2024-01-09','YYYY-MM-DD'), 1);

COMMIT;

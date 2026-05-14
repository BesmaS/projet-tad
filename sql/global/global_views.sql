-- =============================================================
-- VUES GLOBALES (BDDR)
-- A executer sur GLPI_GLOBAL apres creation des dblinks
-- =============================================================

-- Vue tous les utilisateurs
CREATE OR REPLACE VIEW V_ALL_USERS AS
SELECT 'CERGY' AS site,
       user_id, username, first_name, last_name,
       email, role_id, site_id, status
FROM USERS@cergy_link
UNION ALL
SELECT 'PAU' AS site,
       user_id, username, first_name, last_name,
       email, role_id, site_id, status
FROM USERS@pau_link;

-- Vue tous les ordinateurs
CREATE OR REPLACE VIEW V_ALL_COMPUTERS AS
SELECT 'CERGY' AS site,
       computer_id, inventory_number, computer_name,
       serial_number, brand, model, computer_type,
       purchase_date, status, assigned_user, site_id
FROM COMPUTERS@cergy_link
UNION ALL
SELECT 'PAU' AS site,
       computer_id, inventory_number, computer_name,
       serial_number, brand, model, computer_type,
       purchase_date, status, assigned_user, site_id
FROM COMPUTERS@pau_link;

-- Vue tous les tickets
CREATE OR REPLACE VIEW V_ALL_TICKETS AS
SELECT 'CERGY' AS site,
       ticket_id, title, description, priority, status,
       creation_date, close_date, created_by, assigned_to,
       computer_id, site_id
FROM TICKETS@cergy_link
UNION ALL
SELECT 'PAU' AS site,
       ticket_id, title, description, priority, status,
       creation_date, close_date, created_by, assigned_to,
       computer_id, site_id
FROM TICKETS@pau_link;

-- Vue tous les equipements reseau
CREATE OR REPLACE VIEW V_ALL_EQUIPEMENTS AS
SELECT 'CERGY' AS site,
       equip_id, equip_name, equip_type, brand, model, ip_mgmt, site_id
FROM EQUIPEMENT_RESEAU@cergy_link
UNION ALL
SELECT 'PAU' AS site,
       equip_id, equip_name, equip_type, brand, model, ip_mgmt, site_id
FROM EQUIPEMENT_RESEAU@pau_link;

-- Vue historique affectations global
CREATE OR REPLACE VIEW V_ALL_HISTO AS
SELECT 'CERGY' AS site,
       histo_id, computer_id, user_id, date_debut, date_fin, site_id
FROM HISTO_AFFECTATION@cergy_link
UNION ALL
SELECT 'PAU' AS site,
       histo_id, computer_id, user_id, date_debut, date_fin, site_id
FROM HISTO_AFFECTATION@pau_link;

-- Vue dashboard global : synthese par site
CREATE OR REPLACE VIEW V_DASHBOARD_GLOBAL AS
SELECT 'CERGY' AS site,
    (SELECT COUNT(*) FROM USERS@cergy_link)     AS nb_utilisateurs,
    (SELECT COUNT(*) FROM COMPUTERS@cergy_link) AS nb_ordinateurs,
    (SELECT COUNT(*) FROM TICKETS@cergy_link)   AS nb_tickets_total,
    (SELECT COUNT(*) FROM TICKETS@cergy_link WHERE status = 'OPEN')        AS tickets_ouverts,
    (SELECT COUNT(*) FROM TICKETS@cergy_link WHERE status = 'IN_PROGRESS') AS tickets_en_cours,
    (SELECT COUNT(*) FROM COMPUTERS@cergy_link WHERE status = 'ACTIVE')    AS materiel_actif
FROM DUAL
UNION ALL
SELECT 'PAU' AS site,
    (SELECT COUNT(*) FROM USERS@pau_link),
    (SELECT COUNT(*) FROM COMPUTERS@pau_link),
    (SELECT COUNT(*) FROM TICKETS@pau_link),
    (SELECT COUNT(*) FROM TICKETS@pau_link WHERE status = 'OPEN'),
    (SELECT COUNT(*) FROM TICKETS@pau_link WHERE status = 'IN_PROGRESS'),
    (SELECT COUNT(*) FROM COMPUTERS@pau_link WHERE status = 'ACTIVE')
FROM DUAL;
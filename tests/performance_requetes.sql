-- =============================================================
-- TESTS DE PERFORMANCE ET PLANS DE REQUETES
-- A executer apres generation des donnees massives
-- =============================================================

SET SERVEROUTPUT ON;
SET TIMING ON;

-- =============================================================
-- REQUETE 1 : Materiels ACTIFS de Cergy par type
-- Test de l index compose idx_cergy_computers_site_type_status
-- =============================================================

-- SANS index (on le rend invisible)
ALTER INDEX idx_cergy_computers_site_type_status INVISIBLE;

EXPLAIN PLAN FOR
SELECT c.computer_id, c.inventory_number, c.computer_name,
       c.brand, c.model, c.computer_type, c.status,
       u.username, u.email
FROM   COMPUTERS c
JOIN   USERS u ON c.assigned_user = u.user_id
WHERE  c.site_id       = 1
AND    c.computer_type = 'DESKTOP'
AND    c.status        = 'ACTIVE';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(FORMAT => 'ALL'));

-- AVEC index
ALTER INDEX idx_cergy_computers_site_type_status VISIBLE;

EXPLAIN PLAN FOR
SELECT c.computer_id, c.inventory_number, c.computer_name,
       c.brand, c.model, c.computer_type, c.status,
       u.username, u.email
FROM   COMPUTERS c
JOIN   USERS u ON c.assigned_user = u.user_id
WHERE  c.site_id       = 1
AND    c.computer_type = 'DESKTOP'
AND    c.status        = 'ACTIVE';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(FORMAT => 'ALL'));

-- =============================================================
-- REQUETE 2 : Tickets ouverts par priorite sur Cergy
-- Test de l index compose idx_cergy_tickets_site_status
-- =============================================================

ALTER INDEX idx_cergy_tickets_site_status INVISIBLE;

EXPLAIN PLAN FOR
SELECT t.priority,
       COUNT(*)                          AS nb_tickets,
       AVG(SYSDATE - t.creation_date)    AS age_moyen_jours
FROM   TICKETS t
WHERE  t.site_id = 1
AND    t.status IN ('OPEN','IN_PROGRESS')
GROUP  BY t.priority
ORDER  BY DECODE(t.priority,'CRITICAL',1,'HIGH',2,'MEDIUM',3,'LOW',4);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(FORMAT => 'ALL'));

ALTER INDEX idx_cergy_tickets_site_status VISIBLE;

EXPLAIN PLAN FOR
SELECT t.priority,
       COUNT(*)                          AS nb_tickets,
       AVG(SYSDATE - t.creation_date)    AS age_moyen_jours
FROM   TICKETS t
WHERE  t.site_id = 1
AND    t.status IN ('OPEN','IN_PROGRESS')
GROUP  BY t.priority
ORDER  BY DECODE(t.priority,'CRITICAL',1,'HIGH',2,'MEDIUM',3,'LOW',4);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(FORMAT => 'ALL'));

/*-- =============================================================
-- REQUETE 3 : Vision globale Cergy + Pau via BDDR
-- Test de la vue V_ALL_TICKETS avec UNION ALL
-- arche uniqueent piur glpi_global
-- =============================================================

EXPLAIN PLAN FOR
SELECT site, priority, COUNT(*) AS nb_tickets
FROM   V_ALL_TICKETS
WHERE  status = 'OPEN'
GROUP  BY site, priority
ORDER  BY site, priority;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(FORMAT => 'ALL'));
*/
-- =============================================================
-- REQUETE 4 : Historique d affectation d un ordinateur
-- Test des index sur HISTO_AFFECTATION
-- =============================================================

EXPLAIN PLAN FOR
SELECT h.histo_id,
       c.inventory_number,
       u.username,
       h.date_debut,
       h.date_fin
FROM   HISTO_AFFECTATION h
JOIN   COMPUTERS c ON h.computer_id = c.computer_id
JOIN   USERS     u ON h.user_id     = u.user_id
WHERE  h.computer_id = 1010
ORDER  BY h.date_debut DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(FORMAT => 'ALL'));

-- =============================================================
-- REQUETE 5 : Utilisation des fonctions PL/SQL
-- Tickets ouverts par technicien + materiels actifs du site
-- =============================================================

SELECT u.username,
       nb_tickets_ouverts(u.user_id)  AS tickets_ouverts,
       nb_materiel_actif(u.site_id)   AS materiels_actifs_site
FROM   USERS u
WHERE  u.role_id = 2
AND    u.site_id = 1
ORDER  BY tickets_ouverts DESC;

-- =============================================================
-- REQUETE 6 : Jointure lourde materiels + tickets + users
-- Mesure du temps de reponse avec SET TIMING ON
-- =============================================================

SELECT c.computer_name,
       u.username,
       COUNT(t.ticket_id)                                        AS nb_tickets_total,
       SUM(CASE WHEN t.status = 'OPEN' THEN 1 ELSE 0 END)       AS nb_open,
       SUM(CASE WHEN t.status = 'CLOSED' THEN 1 ELSE 0 END)     AS nb_closed,
       MAX(t.creation_date)                                      AS dernier_ticket
FROM   COMPUTERS c
JOIN   USERS     u ON c.assigned_user = u.user_id
JOIN   TICKETS   t ON t.computer_id   = c.computer_id
WHERE  c.site_id = 1
GROUP  BY c.computer_name, u.username
HAVING COUNT(t.ticket_id) > 5
ORDER  BY nb_open DESC;

-- =============================================================
-- APPEL DU RAPPORT CURSEUR
-- =============================================================

EXEC rapport_tickets_priorite;

SET TIMING OFF;

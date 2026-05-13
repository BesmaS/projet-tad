-- =========================
-- BENCHMARK 1 : tickets ouverts
-- À lancer avec GLPI_CERGY ou GLPI_PAU
-- =========================

SELECT *
FROM TICKETS
WHERE status = 'OPEN';


-- =========================
-- BENCHMARK 2 : recherche utilisateur par email
-- À lancer avec GLPI_CERGY ou GLPI_PAU
-- =========================

SELECT *
FROM USERS
WHERE email = 'besma.saidi@cy-tech.fr';


-- =========================
-- BENCHMARK 3 : jointure tickets + utilisateurs
-- À lancer avec GLPI_CERGY ou GLPI_PAU
-- =========================

SELECT t.ticket_id, t.title, t.status, u.username
FROM TICKETS t
JOIN USERS u
ON t.created_by = u.user_id;


-- =========================
-- BENCHMARK 4 : statistiques tickets
-- À lancer avec GLPI_CERGY ou GLPI_PAU
-- =========================

SELECT status, COUNT(*) AS nb_tickets
FROM TICKETS
GROUP BY status;


-- =========================
-- BENCHMARK 5 : vue globale multi-sites
-- À lancer avec GLPI_GLOBAL
-- =========================

SELECT *
FROM V_ALL_TICKETS
WHERE status = 'OPEN';


-- =========================
-- BENCHMARK 6 : nombre de tickets par site
-- À lancer avec GLPI_GLOBAL
-- =========================

SELECT site, COUNT(*) AS nb_tickets
FROM V_ALL_TICKETS
GROUP BY site;
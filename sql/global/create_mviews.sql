CREATE MATERIALIZED VIEW MV_DASHBOARD_GLOBAL
    BUILD IMMEDIATE
    REFRESH COMPLETE ON DEMAND
AS
SELECT 'CERGY' AS site,
       COUNT(*) AS nb_tickets_total,
       SUM(CASE WHEN status = 'OPEN'        THEN 1 ELSE 0 END) AS tickets_ouverts,
       SUM(CASE WHEN status = 'IN_PROGRESS' THEN 1 ELSE 0 END) AS tickets_en_cours
FROM TICKETS@cergy_link
UNION ALL
SELECT 'PAU',
       COUNT(*),
       SUM(CASE WHEN status = 'OPEN'        THEN 1 ELSE 0 END),
       SUM(CASE WHEN status = 'IN_PROGRESS' THEN 1 ELSE 0 END)
FROM TICKETS@pau_link;

-- MV 2 : Stats tickets par priorité
CREATE MATERIALIZED VIEW MV_STATS_TICKETS
    BUILD IMMEDIATE
    REFRESH COMPLETE ON DEMAND
AS
SELECT 'CERGY' AS site, priority,
       COUNT(*) AS total,
       SUM(CASE WHEN status = 'OPEN'        THEN 1 ELSE 0 END) AS nb_open,
       SUM(CASE WHEN status = 'CLOSED'      THEN 1 ELSE 0 END) AS nb_closed
FROM TICKETS@cergy_link
GROUP BY priority
UNION ALL
SELECT 'PAU', priority,
       COUNT(*),
       SUM(CASE WHEN status = 'OPEN'        THEN 1 ELSE 0 END),
       SUM(CASE WHEN status = 'CLOSED'      THEN 1 ELSE 0 END)
FROM TICKETS@pau_link
GROUP BY priority;

-- MV 3 : Parc actif par site
CREATE MATERIALIZED VIEW MV_PARC_ACTIF
    BUILD IMMEDIATE
    REFRESH COMPLETE ON DEMAND
AS
SELECT 'CERGY' AS site, computer_type, COUNT(*) AS nb
FROM COMPUTERS@cergy_link
WHERE status = 'ACTIVE'
GROUP BY computer_type
UNION ALL
SELECT 'PAU', computer_type, COUNT(*)
FROM COMPUTERS@pau_link
WHERE status = 'ACTIVE'
GROUP BY computer_type;
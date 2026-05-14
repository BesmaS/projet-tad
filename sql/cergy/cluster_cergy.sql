-- =============================================================
-- CLUSTER ORACLE - CERGY
-- Regroupe physiquement COMPUTERS et TICKETS par computer_id
-- dans les memes blocs disque
-- → accelere "donner tous les tickets d'un PC"
-- A executer sur glpi_cergy AVANT de creer les tables
-- =============================================================

CREATE CLUSTER cergy_cluster_comp_ticket (computer_id NUMBER)
    SIZE 512
    TABLESPACE TS_CERGY_DATA;

CREATE INDEX idx_cergy_cluster
    ON CLUSTER cergy_cluster_comp_ticket
    TABLESPACE TS_INDEX;

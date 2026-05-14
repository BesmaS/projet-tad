-- =============================================================
-- CLUSTER ORACLE - PAU
-- Regroupe physiquement COMPUTERS et TICKETS par computer_id
-- dans les memes blocs disque
-- → accelere "donner tous les tickets d'un PC"
-- A executer sur glpi_pau AVANT de creer les tables
-- =============================================================

CREATE CLUSTER pau_cluster_comp_ticket (computer_id NUMBER)
    SIZE 512
    TABLESPACE TS_PAU_DATA;

CREATE INDEX idx_pau_cluster
    ON CLUSTER pau_cluster_comp_ticket
    TABLESPACE TS_INDEX;
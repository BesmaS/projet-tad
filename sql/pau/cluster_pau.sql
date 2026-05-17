

CREATE CLUSTER pau_cluster_comp_ticket (computer_id NUMBER)
    SIZE 512
    TABLESPACE TS_PAU_DATA;

CREATE INDEX idx_pau_cluster
    ON CLUSTER pau_cluster_comp_ticket
    TABLESPACE TS_INDEX;
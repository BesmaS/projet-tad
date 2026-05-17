CREATE CLUSTER cergy_cluster_comp_ticket (computer_id NUMBER)
    SIZE 512
    TABLESPACE TS_CERGY_DATA;

CREATE INDEX idx_cergy_cluster
    ON CLUSTER cergy_cluster_comp_ticket
    TABLESPACE TS_INDEX;

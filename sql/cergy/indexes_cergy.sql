-- =============================================================
-- INDEX CERGY
-- A executer sur glpi_cergy
-- =============================================================

-- USERS
CREATE INDEX idx_cergy_users_email
    ON USERS(email) TABLESPACE TS_INDEX;

CREATE INDEX idx_cergy_users_username
    ON USERS(username) TABLESPACE TS_INDEX;

-- Index compose : users actifs par site
CREATE INDEX idx_cergy_users_site_status
    ON USERS(site_id, status) TABLESPACE TS_INDEX;

-- COMPUTERS
CREATE INDEX idx_cergy_computers_inventory
    ON COMPUTERS(inventory_number) TABLESPACE TS_INDEX;

CREATE INDEX idx_cergy_computers_status
    ON COMPUTERS(status) TABLESPACE TS_INDEX;

-- Index compose : tous les PCs actifs de Cergy par type
CREATE INDEX idx_cergy_computers_site_type_status
    ON COMPUTERS(site_id, computer_type, status) TABLESPACE TS_INDEX;

-- TICKETS
CREATE INDEX idx_cergy_tickets_status
    ON TICKETS(status) TABLESPACE TS_INDEX;

CREATE INDEX idx_cergy_tickets_priority
    ON TICKETS(priority) TABLESPACE TS_INDEX;

CREATE INDEX idx_cergy_tickets_creation
    ON TICKETS(creation_date) TABLESPACE TS_INDEX;

-- Index compose : tickets ouverts par site (dashboard)
CREATE INDEX idx_cergy_tickets_site_status
    ON TICKETS(site_id, status) TABLESPACE TS_INDEX;

-- VLAN
CREATE INDEX idx_cergy_vlan_site
    ON VLAN(site_id, vlan_number) TABLESPACE TS_INDEX;

-- HISTO_AFFECTATION
CREATE INDEX idx_cergy_histo_computer
    ON HISTO_AFFECTATION(computer_id, date_debut) TABLESPACE TS_INDEX;

CREATE INDEX idx_cergy_histo_user
    ON HISTO_AFFECTATION(user_id, date_debut) TABLESPACE TS_INDEX;

-- EQUIPEMENT_RESEAU
CREATE INDEX idx_cergy_equip_site_type
    ON EQUIPEMENT_RESEAU(site_id, equip_type) TABLESPACE TS_INDEX;

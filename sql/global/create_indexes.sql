-- =========================
-- INDEX USERS
-- =========================

CREATE INDEX idx_users_email
ON USERS(email);

CREATE INDEX idx_users_username
ON USERS(username);

-- =========================
-- INDEX COMPUTERS
-- =========================

CREATE INDEX idx_computers_inventory
ON COMPUTERS(inventory_number);

CREATE INDEX idx_computers_status
ON COMPUTERS(status);

-- =========================
-- INDEX TICKETS
-- =========================

CREATE INDEX idx_tickets_status
ON TICKETS(status);

CREATE INDEX idx_tickets_priority
ON TICKETS(priority);

CREATE INDEX idx_tickets_creation_date
ON TICKETS(creation_date);
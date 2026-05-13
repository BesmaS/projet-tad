CREATE INDEX idx_cergy_users_email
ON USERS(email);

CREATE INDEX idx_cergy_users_username
ON USERS(username);

CREATE INDEX idx_cergy_computers_inventory
ON COMPUTERS(inventory_number);

CREATE INDEX idx_cergy_computers_status
ON COMPUTERS(status);

CREATE INDEX idx_cergy_tickets_status
ON TICKETS(status);

CREATE INDEX idx_cergy_tickets_priority
ON TICKETS(priority);

CREATE INDEX idx_cergy_tickets_creation
ON TICKETS(creation_date);
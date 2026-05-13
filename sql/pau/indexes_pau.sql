CREATE INDEX idx_pau_users_email
ON USERS(email);

CREATE INDEX idx_pau_users_username
ON USERS(username);

CREATE INDEX idx_pau_computers_inventory
ON COMPUTERS(inventory_number);

CREATE INDEX idx_pau_computers_status
ON COMPUTERS(status);

CREATE INDEX idx_pau_tickets_status
ON TICKETS(status);

CREATE INDEX idx_pau_tickets_priority
ON TICKETS(priority);

CREATE INDEX idx_pau_tickets_creation
ON TICKETS(creation_date);
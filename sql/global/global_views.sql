CREATE OR REPLACE VIEW V_ALL_USERS AS
SELECT 'CERGY' AS site, user_id, username, first_name, last_name, email, role_id, site_id
FROM USERS@cergy_link
UNION ALL
SELECT 'PAU' AS site, user_id, username, first_name, last_name, email, role_id, site_id
FROM USERS@pau_link;

CREATE OR REPLACE VIEW V_ALL_COMPUTERS AS
SELECT 'CERGY' AS site, computer_id, inventory_number, computer_name, serial_number,
       brand, model, purchase_date, status, assigned_user
FROM COMPUTERS@cergy_link
UNION ALL
SELECT 'PAU' AS site, computer_id, inventory_number, computer_name, serial_number,
       brand, model, purchase_date, status, assigned_user
FROM COMPUTERS@pau_link;

CREATE OR REPLACE VIEW V_ALL_TICKETS AS
SELECT 'CERGY' AS site, ticket_id, title, description, priority, status,
       creation_date, created_by, assigned_to, computer_id
FROM TICKETS@cergy_link
UNION ALL
SELECT 'PAU' AS site, ticket_id, title, description, priority, status,
       creation_date, created_by, assigned_to, computer_id
FROM TICKETS@pau_link;
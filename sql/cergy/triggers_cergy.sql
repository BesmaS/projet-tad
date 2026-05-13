--ajuste automatiquement la date quand un ticket est créé 
CREATE OR REPLACE TRIGGER trg_ticket_creation
BEFORE INSERT ON TICKETS
FOR EACH ROW
BEGIN
    :NEW.creation_date := SYSDATE;
END;
/
-- force creation_date = SYSDATE a chaque INSERT ticket
CREATE OR REPLACE TRIGGER trg_pau_ticket_creation
BEFORE INSERT ON TICKETS
FOR EACH ROW
BEGIN
    :NEW.creation_date := SYSDATE;
END;
/

--  enregistre automatiquement l affectation dans
-- HISTO_AFFECTATION quand on change le assigned_user d un ordinateur
CREATE OR REPLACE TRIGGER trg_pau_affectation_histo
AFTER UPDATE OF assigned_user ON COMPUTERS
FOR EACH ROW
WHEN (NEW.assigned_user IS NOT NULL AND
      (OLD.assigned_user IS NULL OR NEW.assigned_user != OLD.assigned_user))
DECLARE
    v_histo_id NUMBER;
BEGIN
    -- Fermer l affectation precedente
    IF :OLD.assigned_user IS NOT NULL THEN
        UPDATE HISTO_AFFECTATION
        SET    date_fin = SYSDATE
        WHERE  computer_id = :OLD.computer_id
        AND    user_id     = :OLD.assigned_user
        AND    date_fin    IS NULL;
    END IF;

    -- Creer la nouvelle affectation
    SELECT NVL(MAX(histo_id), 0) + 1 INTO v_histo_id
    FROM   HISTO_AFFECTATION;

    INSERT INTO HISTO_AFFECTATION (histo_id, computer_id, user_id, date_debut, site_id)
    VALUES (v_histo_id, :NEW.computer_id, :NEW.assigned_user, SYSDATE, :NEW.site_id);
END;
/

--  interdit de supprimer un ticket encore OPEN
CREATE OR REPLACE TRIGGER trg_pau_ticket_no_delete_open
BEFORE DELETE ON TICKETS
FOR EACH ROW
BEGIN
    IF :OLD.status = 'OPEN' THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Impossible de supprimer un ticket en statut OPEN.');
    END IF;
END;
/

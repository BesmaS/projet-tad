-- =============================================================
-- PROCEDURES ET FONCTIONS CERGY
-- A executer sur glpi_cergy
-- =============================================================

-- =============================================================
-- FONCTIONS
-- =============================================================

-- Fonction 1 : retourne le nombre de tickets ouverts d un user
CREATE OR REPLACE FUNCTION nb_tickets_ouverts (
    p_user_id NUMBER
) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM   TICKETS
    WHERE  created_by = p_user_id
    AND    status IN ('OPEN', 'IN_PROGRESS');

    RETURN v_count;
END;
/

-- Fonction 2 : retourne le nombre de materiels actifs sur un site
CREATE OR REPLACE FUNCTION nb_materiel_actif (
    p_site_id NUMBER
) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM   COMPUTERS
    WHERE  site_id = p_site_id
    AND    status  = 'ACTIVE';

    RETURN v_count;
END;
/

-- =============================================================
-- PROCEDURES
-- =============================================================

-- Procedure 1 : ajouter un ticket
-- Utilise un curseur pour verifier que le technicien existe
-- et a bien le role_id = 2 avant d inserer
CREATE OR REPLACE PROCEDURE add_ticket (
    p_ticket_id   NUMBER,
    p_title       VARCHAR2,
    p_description VARCHAR2,
    p_priority    VARCHAR2,
    p_status      VARCHAR2,
    p_created_by  NUMBER,
    p_assigned_to NUMBER,
    p_computer_id NUMBER
)
IS
    -- Curseur : verifie que le technicien existe avec role 2
    CURSOR cur_check_tech IS
        SELECT user_id, username
        FROM   USERS
        WHERE  user_id  = p_assigned_to
        AND    role_id  = 2;

    v_found BOOLEAN := FALSE;
BEGIN
    -- Parcourir le curseur de verification
    FOR v_tech IN cur_check_tech LOOP
        v_found := TRUE;
        DBMS_OUTPUT.PUT_LINE('Technicien trouve : ' || v_tech.username);
    END LOOP;

    IF NOT v_found THEN
        RAISE_APPLICATION_ERROR(-20002,
            'L utilisateur assigne n existe pas ou n est pas technicien (role_id=2).');
    END IF;

    INSERT INTO TICKETS (
        ticket_id, title, description, priority,
        status, created_by, assigned_to, computer_id
    )
    VALUES (
        p_ticket_id, p_title, p_description, p_priority,
        p_status, p_created_by, p_assigned_to, p_computer_id
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Ticket ' || p_ticket_id || ' cree avec succes.');
END;
/

-- Procedure 2 : rapport des tickets par priorite
-- Utilise un curseur explicite avec OPEN / FETCH / CLOSE
CREATE OR REPLACE PROCEDURE rapport_tickets_priorite
IS
    -- Curseur explicite avec agregation par priorite
    CURSOR cur_rapport IS
        SELECT priority,
               COUNT(*)                                              AS total,
               SUM(CASE WHEN status = 'OPEN'        THEN 1 ELSE 0 END) AS nb_open,
               SUM(CASE WHEN status = 'IN_PROGRESS' THEN 1 ELSE 0 END) AS nb_progress,
               SUM(CASE WHEN status = 'RESOLVED'    THEN 1 ELSE 0 END) AS nb_resolved,
               SUM(CASE WHEN status = 'CLOSED'      THEN 1 ELSE 0 END) AS nb_closed
        FROM   TICKETS
        GROUP  BY priority
        ORDER  BY DECODE(priority,'CRITICAL',1,'HIGH',2,'MEDIUM',3,'LOW',4,5);

    v_ligne cur_rapport%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== RAPPORT TICKETS PAR PRIORITE (CERGY) ===');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('PRIORITE',10) || RPAD('TOTAL',8) ||
        RPAD('OPEN',8)      || RPAD('EN COURS',10) ||
        RPAD('RESOLU',8)    || 'FERME'
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 52, '-'));

    OPEN cur_rapport;
    LOOP
        FETCH cur_rapport INTO v_ligne;
        EXIT WHEN cur_rapport%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_ligne.priority,     10) ||
            RPAD(v_ligne.total,         8) ||
            RPAD(v_ligne.nb_open,       8) ||
            RPAD(v_ligne.nb_progress,  10) ||
            RPAD(v_ligne.nb_resolved,   8) ||
            v_ligne.nb_closed
        );
    END LOOP;
    CLOSE cur_rapport;

    DBMS_OUTPUT.PUT_LINE('=============================================');
END;
/

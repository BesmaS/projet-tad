CREATE OR REPLACE PROCEDURE add_ticket (
    p_ticket_id NUMBER,
    p_title VARCHAR2,
    p_description VARCHAR2,
    p_priority VARCHAR2,
    p_status VARCHAR2,
    p_created_by NUMBER,
    p_assigned_to NUMBER,
    p_computer_id NUMBER
)
IS
BEGIN
    INSERT INTO TICKETS (
        ticket_id,
        title,
        description,
        priority,
        status,
        created_by,
        assigned_to,
        computer_id
    )
    VALUES (
        p_ticket_id,
        p_title,
        p_description,
        p_priority,
        p_status,
        p_created_by,
        p_assigned_to,
        p_computer_id
    );

    COMMIT;
END;
/
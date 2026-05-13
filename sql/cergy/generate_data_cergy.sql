CREATE OR REPLACE PROCEDURE generate_tickets (
    p_number NUMBER
)
IS
BEGIN
    FOR i IN 100..(100 + p_number) LOOP

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
            i,
            'Generated Ticket ' || i,
            'Automatically generated ticket',
            'MEDIUM',
            'OPEN',
            3,
            2,
            1
        );

    END LOOP;

    COMMIT;
END;
/
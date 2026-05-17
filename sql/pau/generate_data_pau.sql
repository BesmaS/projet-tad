CREATE OR REPLACE PROCEDURE generate_all_data_pau (
    p_nb_users   NUMBER,
    p_nb_comp    NUMBER,
    p_nb_tickets NUMBER
)
IS
    v_base_user  CONSTANT NUMBER := 2000;
    v_base_comp  CONSTANT NUMBER := 2000;
    v_base_tick  CONSTANT NUMBER := 2000;
    v_base_loc   CONSTANT NUMBER := 20;
    v_base_vlan  CONSTANT NUMBER := 20;
    v_base_equip CONSTANT NUMBER := 20;
    v_base_histo CONSTANT NUMBER := 2000;

    TYPE t_arr IS TABLE OF VARCHAR2(30);
    v_priorities  t_arr := t_arr('LOW','MEDIUM','HIGH','CRITICAL');
    v_statuses    t_arr := t_arr('OPEN','IN_PROGRESS','RESOLVED','CLOSED');
    v_comp_types  t_arr := t_arr('DESKTOP','LAPTOP','SERVER','PRINTER','TABLET');
    v_brands      t_arr := t_arr('Dell','HP','Lenovo','Apple','Asus','Acer');
    v_buildings   t_arr := t_arr('Batiment-C','Batiment-D','Batiment-E','Batiment-F');
    v_equip_types t_arr := t_arr('SWITCH','ROUTER','WIFI_AP','FIREWALL');

    v_rand_user NUMBER;
    v_rand_tech NUMBER;
    v_rand_comp NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Debut generation donnees PAU...');

    -- LOCATIONS (10 salles)
    FOR i IN 1..10 LOOP
        INSERT INTO LOCATIONS (location_id, building, room, floor, site_id)
        VALUES (
            v_base_loc + i,
            v_buildings(MOD(i-1, 4) + 1),
            'Salle-PAU-' || LPAD(i * 10, 3, '0'),
            'Etage-' || TO_CHAR(MOD(i, 4)),
            2
        );
    END LOOP;
    COMMIT;

    -- VLAN (10 VLANs)
    FOR i IN 1..10 LOOP
        INSERT INTO VLAN (vlan_id, vlan_number, vlan_name, site_id)
        VALUES (
            v_base_vlan + i,
            200 + i * 10,
            'VLAN-PAU-' || TO_CHAR(200 + i * 10),
            2
        );
    END LOOP;
    COMMIT;

    -- EQUIPEMENTS RESEAU (20 equipements)
    FOR i IN 1..20 LOOP
        INSERT INTO EQUIPEMENT_RESEAU (
            equip_id, equip_name, equip_type, brand, model, ip_mgmt, location_id, site_id
        )
        VALUES (
            v_base_equip + i,
            'PAU-EQUIP-' || LPAD(i, 3, '0'),
            v_equip_types(MOD(i-1, 4) + 1),
            CASE MOD(i,3) WHEN 0 THEN 'Cisco' WHEN 1 THEN 'HP' ELSE 'Juniper' END,
            'Model-' || TO_CHAR(MOD(i, 5) + 1),
            '10.2.' || TO_CHAR(i) || '.1',
            v_base_loc + MOD(i-1, 10) + 1,
            2
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Locations / VLANs / Equipements OK');

    -- USERS
    FOR i IN 1..p_nb_users LOOP
        INSERT INTO USERS (
            user_id, username, first_name, last_name,
            email, role_id, site_id, location_id, status
        )
        VALUES (
            v_base_user + i,
            'pau.user.' || LPAD(i, 4, '0'),
            'Prenom' || TO_CHAR(i),
            'Nom'    || TO_CHAR(i),
            'pau.user.' || TO_CHAR(i) || '@cy-tech.fr',
            CASE
                WHEN MOD(i, 50) = 0 THEN 1
                WHEN MOD(i, 10) = 0 THEN 2
                ELSE 3
            END,
            2,
            v_base_loc + MOD(i-1, 10) + 1,
            CASE WHEN MOD(i, 20) = 0 THEN 'INACTIF' ELSE 'ACTIF' END
        );
        IF MOD(i, 100) = 0 THEN
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Users : ' || TO_CHAR(i) || '/' || TO_CHAR(p_nb_users));
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Users OK : ' || TO_CHAR(p_nb_users));

    -- COMPUTERS
    FOR i IN 1..p_nb_comp LOOP
        v_rand_user := v_base_user + MOD(i * 7, p_nb_users) + 1;

        INSERT INTO COMPUTERS (
            computer_id, inventory_number, computer_name,
            serial_number, brand, model, computer_type,
            purchase_date, status, assigned_user, location_id, site_id
        )
        VALUES (
            v_base_comp + i,
            'PAU-PC-' || LPAD(i, 5, '0'),
            'PAU-' || v_brands(MOD(i-1, 6) + 1) || '-' || TO_CHAR(i),
            'SN-PAU-' || LPAD(i, 6, '0'),
            v_brands(MOD(i-1, 6) + 1),
            'Model-' || TO_CHAR(MOD(i, 8) + 1),
            v_comp_types(MOD(i-1, 5) + 1),
            SYSDATE - (365 * (MOD(i, 5) + 1)) + MOD(i, 30),
            CASE
                WHEN MOD(i, 15) = 0 THEN 'MAINTENANCE'
                WHEN MOD(i, 10) = 0 THEN 'INACTIVE'
                ELSE 'ACTIVE'
            END,
            v_rand_user,
            v_base_loc + MOD(i-1, 10) + 1,
            2
        );
        IF MOD(i, 50) = 0 THEN
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Computers : ' || TO_CHAR(i) || '/' || TO_CHAR(p_nb_comp));
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Computers OK : ' || TO_CHAR(p_nb_comp));

    -- TICKETS
    FOR i IN 1..p_nb_tickets LOOP
        v_rand_user := v_base_user + MOD(i * 7, p_nb_users) + 1;
        v_rand_tech := v_base_user + (MOD(i, 50) + 1) * 10;
        v_rand_comp := v_base_comp + MOD(i * 5, p_nb_comp)  + 1;

        INSERT INTO TICKETS (
            ticket_id, title, description,
            priority, status,
            creation_date, close_date,
            created_by, assigned_to, computer_id, site_id
        )
        VALUES (
            v_base_tick + i,
            'Ticket PAU #' || TO_CHAR(i),
            'Description automatique ticket PAU ' || TO_CHAR(i),
            v_priorities(MOD(i-1, 4) + 1),
            v_statuses(MOD(i-1, 4) + 1),
            SYSDATE - MOD(i, 365),
            CASE
                WHEN v_statuses(MOD(i-1, 4) + 1) IN ('RESOLVED','CLOSED')
                THEN SYSDATE - MOD(i, 30)
                ELSE NULL
            END,
            v_rand_user,
            v_rand_tech,
            v_rand_comp,
            2
        );
        IF MOD(i, 500) = 0 THEN
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Tickets : ' || TO_CHAR(i) || '/' || TO_CHAR(p_nb_tickets));
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Tickets OK : ' || TO_CHAR(p_nb_tickets));

    -- HISTO_AFFECTATION
    FOR i IN 1..100 LOOP
        v_rand_comp := v_base_comp + MOD(i * 3, p_nb_comp)  + 1;
        v_rand_user := v_base_user + MOD(i * 7, p_nb_users) + 1;

        INSERT INTO HISTO_AFFECTATION (
            histo_id, computer_id, user_id, date_debut, date_fin, site_id
        )
        VALUES (
            v_base_histo + i,
            v_rand_comp,
            v_rand_user,
            SYSDATE - (MOD(i, 500) + 30),
            CASE WHEN MOD(i, 3) != 0 THEN SYSDATE - MOD(i, 30) ELSE NULL END,
            2
        );
    END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Histo OK');
    DBMS_OUTPUT.PUT_LINE('=== GENERATION PAU TERMINEE ===');
    DBMS_OUTPUT.PUT_LINE('Users    : ' || TO_CHAR(p_nb_users));
    DBMS_OUTPUT.PUT_LINE('Computers: ' || TO_CHAR(p_nb_comp));
    DBMS_OUTPUT.PUT_LINE('Tickets  : ' || TO_CHAR(p_nb_tickets));
END;
/

-- Appel :
-- SET SERVEROUTPUT ON;
-- EXEC generate_all_data_pau(500, 300, 5000);
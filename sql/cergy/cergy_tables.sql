CREATE TABLE USERS (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) UNIQUE NOT NULL,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(100) UNIQUE,
    role_id NUMBER NOT NULL,
    site_id NUMBER DEFAULT 1
);

CREATE TABLE COMPUTERS (
    computer_id NUMBER PRIMARY KEY,
    inventory_number VARCHAR2(50) UNIQUE NOT NULL,
    computer_name VARCHAR2(100),
    serial_number VARCHAR2(100),
    brand VARCHAR2(50),
    model VARCHAR2(50),
    purchase_date DATE,
    status VARCHAR2(30),
    assigned_user NUMBER,

    CONSTRAINT fk_cergy_computer_user
        FOREIGN KEY (assigned_user)
        REFERENCES USERS(user_id)
);

CREATE TABLE SOFTWARES (
    software_id NUMBER PRIMARY KEY,
    software_name VARCHAR2(100) NOT NULL,
    version VARCHAR2(50),
    license_type VARCHAR2(50)
);

CREATE TABLE COMPUTER_SOFTWARES (
    computer_id NUMBER,
    software_id NUMBER,

    PRIMARY KEY (computer_id, software_id),

    CONSTRAINT fk_cergy_cs_computer
        FOREIGN KEY (computer_id)
        REFERENCES COMPUTERS(computer_id),

    CONSTRAINT fk_cergy_cs_software
        FOREIGN KEY (software_id)
        REFERENCES SOFTWARES(software_id)
);

CREATE TABLE NETWORKS (
    network_id NUMBER PRIMARY KEY,
    network_name VARCHAR2(100),
    ip_range VARCHAR2(50),
    vlan_number NUMBER
);

CREATE TABLE TICKETS (
    ticket_id NUMBER PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    description VARCHAR2(1000),
    priority VARCHAR2(20),
    status VARCHAR2(20),
    creation_date DATE DEFAULT SYSDATE,
    created_by NUMBER,
    assigned_to NUMBER,
    computer_id NUMBER,

    CONSTRAINT fk_cergy_ticket_creator
        FOREIGN KEY (created_by)
        REFERENCES USERS(user_id),

    CONSTRAINT fk_cergy_ticket_assigned
        FOREIGN KEY (assigned_to)
        REFERENCES USERS(user_id),

    CONSTRAINT fk_cergy_ticket_computer
        FOREIGN KEY (computer_id)
        REFERENCES COMPUTERS(computer_id)
);
CREATE TABLE SITES (
    site_id NUMBER PRIMARY KEY,
    site_name VARCHAR2(50) NOT NULL,
    city VARCHAR2(50)
);

CREATE TABLE ROLES (
    role_id NUMBER PRIMARY KEY,
    role_name VARCHAR2(50) UNIQUE NOT NULL
);

CREATE TABLE USERS (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) UNIQUE NOT NULL,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(100) UNIQUE,
    role_id NUMBER,
    site_id NUMBER,

    CONSTRAINT fk_users_roles
        FOREIGN KEY (role_id)
        REFERENCES ROLES(role_id),

    CONSTRAINT fk_users_sites
        FOREIGN KEY (site_id)
        REFERENCES SITES(site_id)
);

CREATE TABLE COMPUTERS (
    computer_id NUMBER PRIMARY KEY,
    inventory_number VARCHAR2(50) UNIQUE,
    computer_name VARCHAR2(100),
    serial_number VARCHAR2(100),
    brand VARCHAR2(50),
    model VARCHAR2(50),
    purchase_date DATE,
    status VARCHAR2(30),

    site_id NUMBER,

    CONSTRAINT fk_computers_sites
        FOREIGN KEY (site_id)
        REFERENCES SITES(site_id)
);

CREATE TABLE SOFTWARES (
    software_id NUMBER PRIMARY KEY,
    software_name VARCHAR2(100),
    version VARCHAR2(50),
    license_type VARCHAR2(50)
);

CREATE TABLE COMPUTER_SOFTWARES (
    computer_id NUMBER,
    software_id NUMBER,

    PRIMARY KEY (computer_id, software_id),

    CONSTRAINT fk_cs_computer
        FOREIGN KEY (computer_id)
        REFERENCES COMPUTERS(computer_id),

    CONSTRAINT fk_cs_software
        FOREIGN KEY (software_id)
        REFERENCES SOFTWARES(software_id)
);

CREATE TABLE TICKETS (
    ticket_id NUMBER PRIMARY KEY,
    title VARCHAR2(200),
    description VARCHAR2(1000),
    priority VARCHAR2(20),
    status VARCHAR2(20),
    creation_date DATE DEFAULT SYSDATE,

    created_by NUMBER,
    assigned_to NUMBER,
    computer_id NUMBER,

    CONSTRAINT fk_ticket_creator
        FOREIGN KEY (created_by)
        REFERENCES USERS(user_id),

    CONSTRAINT fk_ticket_assigned
        FOREIGN KEY (assigned_to)
        REFERENCES USERS(user_id),

    CONSTRAINT fk_ticket_computer
        FOREIGN KEY (computer_id)
        REFERENCES COMPUTERS(computer_id)
);
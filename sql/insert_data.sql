-- =========================
-- INSERT SITES
-- =========================

INSERT INTO SITES VALUES (1, 'CY Tech Cergy', 'Cergy');
INSERT INTO SITES VALUES (2, 'CY Tech Pau', 'Pau');

-- =========================
-- INSERT ROLES
-- =========================

INSERT INTO ROLES VALUES (1, 'Administrator');
INSERT INTO ROLES VALUES (2, 'Technician');
INSERT INTO ROLES VALUES (3, 'Student');

-- =========================
-- INSERT USERS
-- =========================

INSERT INTO USERS VALUES (
    1,
    'admin',
    'admin',
    'admin',
    'admin@cy-tech.fr',
    1,
    1
);

INSERT INTO USERS VALUES (
    2,
    'saidi.besma',
    'besma',
    'saidi',
    'besma@cy-tech.fr',
    2,
    2
);

-- =========================
-- INSERT COMPUTERS
-- =========================

INSERT INTO COMPUTERS VALUES (
    1,
    'PC-CERGY-001',
    'SN12345',
    'Dell',
    'OptiPlex',
    TO_DATE('2024-01-10','YYYY-MM-DD'),
    'Active',
    1
);

-- =========================
-- INSERT SOFTWARES
-- =========================

INSERT INTO SOFTWARES VALUES (
    1,
    'Oracle Database',
    '21c',
    'Enterprise'
);

-- =========================
-- LINK COMPUTER / SOFTWARE
-- =========================

INSERT INTO COMPUTER_SOFTWARES VALUES (1,1);

-- =========================
-- INSERT TICKETS
-- =========================

INSERT INTO TICKETS VALUES (
    1,
    'Printer issue',
    'Printer not responding',
    'High',
    'Open',
    SYSDATE,
    1,
    2,
    1
);

COMMIT;
INSERT INTO USERS VALUES (
    1,
    'admin.cergy',
    'Admin',
    'Cergy',
    'admin.cergy@cy-tech.fr',
    1,
    1
);

INSERT INTO USERS VALUES (
    2,
    'tech.cergy',
    'Tech',
    'Cergy',
    'tech.cergy@cy-tech.fr',
    2,
    1
);

INSERT INTO USERS VALUES (
    3,
    'besma.saidi',
    'Besma',
    'Saidi',
    'besma.saidi@cy-tech.fr',
    3,
    1
);

INSERT INTO COMPUTERS VALUES (
    1,
    'CERGY-PC-001',
    'PC-BESMA',
    'SN-CERGY-001',
    'Dell',
    'OptiPlex',
    TO_DATE('2024-01-10','YYYY-MM-DD'),
    'ACTIVE',
    3
);

INSERT INTO SOFTWARES VALUES (
    1,
    'Oracle Database',
    '21c',
    'Enterprise'
);

INSERT INTO COMPUTER_SOFTWARES VALUES (
    1,
    1
);

INSERT INTO NETWORKS VALUES (
    1,
    'Cergy Main Network',
    '192.168.1.0/24',
    10
);

INSERT INTO TICKETS VALUES (
    1,
    'Printer issue',
    'Printer not responding',
    'HIGH',
    'OPEN',
    SYSDATE,
    3,
    2,
    1
);

COMMIT;
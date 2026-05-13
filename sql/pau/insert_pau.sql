INSERT INTO USERS VALUES (
    1,
    'admin.pau',
    'Admin',
    'Pau',
    'admin.pau@cy-tech.fr',
    1,
    2
);

INSERT INTO USERS VALUES (
    2,
    'tech.pau',
    'Tech',
    'Pau',
    'tech.pau@cy-tech.fr',
    2,
    2
);

INSERT INTO USERS VALUES (
    3,
    'etudiant.pau',
    'Etudiant',
    'Pau',
    'etudiant.pau@cy-tech.fr',
    3,
    2
);

INSERT INTO COMPUTERS VALUES (
    1,
    'PAU-PC-001',
    'PC-PAU-001',
    'SN-PAU-001',
    'HP',
    'EliteDesk',
    TO_DATE('2024-02-15','YYYY-MM-DD'),
    'ACTIVE',
    3
);

INSERT INTO SOFTWARES VALUES (
    1,
    'Oracle Database',
    '21c',
    'Enterprise'
);

INSERT INTO COMPUTER_SOFTWARES VALUES (1, 1);

INSERT INTO NETWORKS VALUES (
    1,
    'Pau Main Network',
    '192.168.2.0/24',
    20
);

INSERT INTO TICKETS VALUES (
    1,
    'Network issue',
    'Wi-Fi connection problem',
    'MEDIUM',
    'OPEN',
    SYSDATE,
    3,
    2,
    1
);

COMMIT;
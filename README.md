# Mini-projet GLPI - Gestion du Parc Informatique de CY Tech
**ING2 - Traitement & Administration de Données - 2025-2026**


| Nom | Prénom |
|-----|--------|
| SAIDI | Besma |
| SAIL | Rayan |
| TOUNKARA | Mohamed |
| ALLOCHON | Matthieu |

---

## Présentation

Ce projet consiste à repenser une partie de la base de données GLPI pour améliorer les performances du parc informatique de CY Tech et prendre en compte l'aspect multi-sites (Cergy, Pau).

Le modèle s'inspire du reverse engineering du dépôt officiel GLPI (https://github.com/glpi-project/glpi) et implémente une architecture Oracle complète avec fragmentation horizontale des données par site.

---

## Structure du projet

```
PROJET-TAD/
├── sql/
│   ├── global/                         # Schéma GLPI_GLOBAL
│   │   ├── create_tablespaces_users.sql  # Tablespaces + users Oracle + GRANT (SYSDBA)
│   │   ├── create_tables.sql             # Tables SITES et ROLES
│   │   ├── create_indexes.sql            # Index globaux
│   │   ├── insert_data.sql               # Données initiales globales
│   │   ├── dblinks.sql                   # Database links cergy_link et pau_link
│   │   ├── global_views.sql              # Vues UNION ALL + V_DASHBOARD_GLOBAL
│   │   └── materialized_views.sql        # MV_DASHBOARD_GLOBAL, MV_STATS_TICKETS, MV_PARC_ACTIF
│   │
│   ├── cergy/                          # Schéma glpi_cergy
│   │   ├── cergy_tables.sql              # 10 tables du site Cergy
│   │   ├── cluster_cergy.sql             # Cluster COMPUTERS + TICKETS
│   │   ├── indexes_cergy.sql             # Index simples et composés
│   │   ├── triggers_cergy.sql            # 3 triggers
│   │   ├── cergy_procedure.sql           # 2 fonctions + 2 procédures avec curseurs
│   │   ├── insert_cergy.sql              # Données initiales
│   │   └── generate_data_cergy.sql       # Génération massive (5000 users, 1000 PCs, 50000 tickets)
│   │
│   └── pau/                            # Schéma glpi_pau
│       ├── pau_tables.sql                # 10 tables du site Pau
│       ├── cluster_pau.sql               # Cluster COMPUTERS + TICKETS
│       ├── indexes_pau.sql               # Index simples et composés
│       ├── triggers_pau.sql              # 3 triggers
│       ├── procedures_pau.sql            # 2 fonctions + 2 procédures avec curseurs
│       ├── insert_pau.sql                # Données initiales
│       └── generate_data_pau.sql         # Génération massive (5000 users, 1000 PCs, 50000 tickets)
│
├── tests/
│   ├── perf_requetes_cergy.sqlnb         # Tests de performance Cergy (EXPLAIN PLAN)
│   ├── perf_requetes_pau.sqlnb           # Tests de performance Pau
│   └── perf_requetes_global.sqlnb        # Tests BDDR + MV vs Vues classiques
│
├── diagrams/
│   ├── schema_relationnel.drawio         # Schéma relationnel (10 tables)
│   └── architecture_bddr.drawio          # Architecture BDDR (3 schémas Oracle)
│
└── reports/
    └── rapport_GLPI_CYTech.pdf           # Rapport final
```

---

## Ordre d'exécution

### 1. Sur oracle_xe en SYSDBA
```sql
-- Créer les tablespaces, users Oracle et rôles
@sql/global/create_tablespaces_users.sql
```

### 2. Sur GLPI_GLOBAL
```sql
@sql/global/create_tables.sql
@sql/global/insert_data.sql
@sql/global/dblinks.sql
@sql/global/global_views.sql
@sql/global/materialized_views.sql
```

### 3. Sur glpi_cergy
```sql
@sql/cergy/cluster_cergy.sql       -- AVANT les tables
@sql/cergy/cergy_tables.sql
@sql/cergy/indexes_cergy.sql
@sql/cergy/triggers_cergy.sql
@sql/cergy/cergy_procedure.sql
@sql/cergy/insert_cergy.sql
@sql/cergy/generate_data_cergy.sql

-- Générer les données massives
EXEC generate_all_data_cergy(5000, 1000, 50000);
```

### 4. Sur glpi_pau
```sql
@sql/pau/pau_tables.sql
@sql/pau/indexes_pau.sql
@sql/pau/triggers_pau.sql
@sql/pau/procedures_pau.sql
@sql/pau/insert_pau.sql
@sql/pau/generate_data_pau.sql

-- Générer les données massives
EXEC generate_all_data_pau(5000, 1000, 50000);
```

### 5. Tests de performance
Ouvrir les notebooks dans `tests/` avec VSCode + extension Oracle SQL Developer.

---

## Architecture

| Schéma | Tablespace | Contenu |
|--------|-----------|---------|
| glpi_cergy | TS_CERGY_DATA | 5 000 users, 1 000 computers, 50 000 tickets |
| glpi_pau | TS_PAU_DATA | 5 000 users, 1 000 computers, 50 000 tickets |
| GLPI_GLOBAL | — | Vues UNION ALL, database links, MV |

---

## Éléments implémentés

### Tables (10 par site)
USERS · LOCATIONS · COMPUTERS · SOFTWARES · COMPUTER_SOFTWARES · VLAN · NETWORKS · EQUIPEMENT_RESEAU · TICKETS · HISTO_AFFECTATION

### Oracle avancé
- **4 Tablespaces** : TS_CERGY_DATA, TS_PAU_DATA, TS_INDEX, TS_HISTO
- **4 Users Oracle** : glpi_global, glpi_cergy, glpi_pau, glpi_readonly
- **3 Rôles** : role_admin_global, role_technicien, role_lecture
- **2 Clusters** : cergy_cluster_comp_ticket, pau_cluster_comp_ticket
- **14 Index** par site dont 5 index composés

### PL/SQL (par site)
- **3 Triggers** : création date ticket, historique affectation, protection suppression
- **2 Fonctions** : nb_tickets_ouverts, nb_materiel_actif
- **2 Procédures** avec curseurs : add_ticket, rapport_tickets_priorite
- **1 Procédure** de génération massive : generate_all_data_cergy/pau

### BDDR
- **2 Database links** : cergy_link, pau_link
- **6 Vues globales** : V_ALL_USERS, V_ALL_COMPUTERS, V_ALL_TICKETS, V_ALL_EQUIPEMENTS, V_ALL_HISTO, V_DASHBOARD_GLOBAL
- **3 Vues matérialisées** : MV_DASHBOARD_GLOBAL, MV_STATS_TICKETS, MV_PARC_ACTIF

---

-- =============================================================
-- CLEANUP CERGY
-- A executer sur glpi_cergy AVANT les nouveaux fichiers
-- Supprime tout dans le bon ordre (FK d abord)
-- =============================================================

-- Tables dependantes en premier
DROP TABLE HISTO_AFFECTATION    CASCADE CONSTRAINTS PURGE;
DROP TABLE COMPUTER_SOFTWARES   CASCADE CONSTRAINTS PURGE;
DROP TABLE TICKETS               CASCADE CONSTRAINTS PURGE;
DROP TABLE COMPUTERS             CASCADE CONSTRAINTS PURGE;
DROP TABLE SOFTWARES             CASCADE CONSTRAINTS PURGE;
DROP TABLE EQUIPEMENT_RESEAU     CASCADE CONSTRAINTS PURGE;
DROP TABLE NETWORKS              CASCADE CONSTRAINTS PURGE;
DROP TABLE VLAN                  CASCADE CONSTRAINTS PURGE;
DROP TABLE USERS                 CASCADE CONSTRAINTS PURGE;
DROP TABLE LOCATIONS             CASCADE CONSTRAINTS PURGE;

-- Procedures / fonctions / triggers (droppés automatiquement avec les tables
-- mais on les supprime explicitement au cas ou)
DROP PROCEDURE add_ticket;
DROP PROCEDURE rapport_tickets_priorite;
DROP PROCEDURE generate_tickets;
DROP PROCEDURE generate_all_data_cergy;
DROP FUNCTION  nb_tickets_ouverts;
DROP FUNCTION  nb_materiel_actif;

-- Cluster (apres avoir droppe les tables qui en dependent)
DROP CLUSTER cergy_cluster_comp_ticket;

COMMIT;

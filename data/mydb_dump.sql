-- SQL Dump generated on 2026-08-07T11:20:43.151Z
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

-- Schema for table: my_table
CREATE TABLE my_table (  id INTEGER PRIMARY KEY AUTOINCREMENT,  name TEXT,  category TEXT,  status TEXT);

-- Data for table: my_table
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (1, 'Project Alpha', 'Frontend', 'Live');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (2, 'Project Beta', 'Backend', 'In Progress');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (3, 'Project Alpha', 'Frontend', 'Live');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (4, 'Project Beta', 'Backend', 'In Progress');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (5, 'Docusaurus Setup', 'Documentation', 'Active');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (6, 'SQLite Integration', 'Database', 'Completed');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (7, 'New Service', 'Backend', 'Production');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (8, 'New Service', 'Backend', 'Production');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (9, 'New Service', 'Backend', 'Production');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (10, 'New Service', 'Backend', 'Production');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (11, 'Docusaurus Setup', 'Documentation', 'Active');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (12, 'SQLite Integration', 'Database', 'Completed');
INSERT INTO "my_table" ("id", "name", "category", "status") VALUES (13, 'New Service', 'Backend', 'Production');

COMMIT;

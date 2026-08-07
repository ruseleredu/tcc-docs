// scripts/init-db.js
const Database = require('better-sqlite3');
const fs = require('fs');
const path = require('path');

// 1. Ensure /data folder exists
const dataDir = path.join(__dirname, '../data');
if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir, { recursive: true });
}

// 2. Connecting opens/creates the database file synchronously
const db = new Database(path.join(dataDir, 'mydb.sqlite'));

console.log('✅ SQLite database created successfully.');

// 3. Create table
db.exec(`
  CREATE TABLE IF NOT EXISTS my_table (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    status TEXT NOT NULL
  );
`);

// 4. Insert data
const insert = db.prepare('INSERT INTO my_table (name, category, status) VALUES (?, ?, ?)');
insert.run('Docusaurus Setup', 'Documentation', 'Active');
insert.run('SQLite Integration', 'Database', 'Completed');

console.log('🌱 Seeded database with sample data.');
db.close();

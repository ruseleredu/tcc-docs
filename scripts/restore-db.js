// scripts/restore-db.js
const Database = require('better-sqlite3');
const fs = require('fs');
const path = require('path');

const dumpSql = fs.readFileSync(path.join(__dirname, '../data/mydb_dump.sql'), 'utf8');
const db = new Database(path.join(__dirname, '../data/mydb_restored.sqlite'));

// Execute the raw SQL commands in the dump
db.exec(dumpSql);
db.close();

console.log('✅ Database restored from dump file!');

const Database = require('better-sqlite3');
const fs = require('fs');
const path = require('path');

// 1. Create or open the combined SQLite database file
const db = new Database('database.sqlite', { verbose: console.log });

try {
    // 2. Enable Foreign Key constraints in SQLite
    db.pragma('foreign_keys = ON');

    // 3. Read both SQL schema files
    const daeltSchemaPath = path.join(__dirname, 'sqlite-daelt-schema.sql');
    const tccSchemaPath = path.join(__dirname, 'sqlite-tcc-schema.sql');

    const daeltSql = fs.readFileSync(daeltSchemaPath, 'utf8');
    const tccSql = fs.readFileSync(tccSchemaPath, 'utf8');

    // 4. Execute schemas inside a single transaction
    const initializeDatabase = db.transaction(() => {
        console.log('Applying DAELT schema...');
        db.exec(daeltSql);

        console.log('Applying TCC schema...');
        db.exec(tccSql);
    });

    initializeDatabase();

    console.log(' Successfully initialized both DAELT and TCC schemas into database.sqlite!');
} catch (error) {
    console.error(' Database initialization failed:', error.message);
} finally {
    db.close();
}

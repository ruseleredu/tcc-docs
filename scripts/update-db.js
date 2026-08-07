// scripts/update-db.js
const Database = require('better-sqlite3');
const path = require('path');
const fs = require('fs');

function addEntry(name, category, status) {
    try {
        const dbPath = path.join(__dirname, '../data/mydb.sqlite');

        if (!fs.existsSync(dbPath)) {
            throw new Error(`Database file not found at: ${dbPath}`);
        }

        // 1. Open connection synchronously
        const db = new Database(dbPath);

        // 2. Prepare statement and execute run
        const stmt = db.prepare(
            'INSERT INTO my_table (name, category, status) VALUES (?, ?, ?)'
        );
        const result = stmt.run(name, category, status);

        // 3. Close connection
        db.close();

        console.log(`✅ SQLite database updated successfully (ID: ${result.lastInsertRowid}).`);
    } catch (err) {
        console.error('❌ Failed to update SQLite database:', err);
        process.exit(1);
    }
}

// Example usage
addEntry('New Service', 'Backend', 'Production');

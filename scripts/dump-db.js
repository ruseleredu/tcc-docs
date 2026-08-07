// scripts/dump-db.js
const Database = require('better-sqlite3');
const fs = require('fs');
const path = require('path');

function escapeSqlValue(val) {
    if (val === null || val === undefined) return 'NULL';
    if (typeof val === 'number') return val;
    if (typeof val === 'boolean') return val ? 1 : 0;
    // Escape single quotes for SQL string literals
    return `'${String(val).replace(/'/g, "''")}'`;
}

function dumpDatabase() {
    try {
        const dbPath = path.join(__dirname, '../data/mydb.sqlite');

        if (!fs.existsSync(dbPath)) {
            throw new Error(`Database file not found at: ${dbPath}`);
        }

        const db = new Database(dbPath);
        let sqlDump = `-- SQL Dump generated on ${new Date().toISOString()}\n`;
        sqlDump += `PRAGMA foreign_keys=OFF;\nBEGIN TRANSACTION;\n\n`;

        // 1. Fetch all user tables (excluding SQLite internal tables)
        const tables = db
            .prepare(
                "SELECT name, sql FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
            )
            .all();

        for (const table of tables) {
            // Append table creation schema
            sqlDump += `-- Schema for table: ${table.name}\n`;
            sqlDump += `${table.sql};\n\n`;

            // 2. Fetch all rows for the table
            const rows = db.prepare(`SELECT * FROM "${table.name}"`).all();

            if (rows.length > 0) {
                sqlDump += `-- Data for table: ${table.name}\n`;
                const columns = Object.keys(rows[0]).map((col) => `"${col}"`).join(', ');

                for (const row of rows) {
                    const values = Object.values(row)
                        .map(escapeSqlValue)
                        .join(', ');

                    sqlDump += `INSERT INTO "${table.name}" (${columns}) VALUES (${values});\n`;
                }
                sqlDump += `\n`;
            }
        }

        sqlDump += `COMMIT;\n`;
        db.close();

        // 3. Save to readable .sql file
        const outputDir = path.join(__dirname, '../data');
        const dumpPath = path.join(outputDir, 'mydb_dump.sql');

        fs.writeFileSync(dumpPath, sqlDump, 'utf8');
        console.log(`✅ Readable SQL dump generated at: ${dumpPath}`);
    } catch (err) {
        console.error('❌ Failed to create dump:', err.message);
        process.exit(1);
    }
}

dumpDatabase();

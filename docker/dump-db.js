const Database = require('better-sqlite3');
const fs = require('fs');

const db = new Database('database.sqlite');
const outputFile = 'dump.sql';

function generateSqlDump() {
    const writeStream = fs.createWriteStream(outputFile, { encoding: 'utf8' });

    writeStream.write('PRAGMA foreign_keys = OFF;\n');
    writeStream.write('BEGIN TRANSACTION;\n\n');

    // 1. Fetch all user tables
    const tables = db
        .prepare(
            `SELECT name, sql FROM sqlite_master 
       WHERE type='table' AND name NOT LIKE 'sqlite_%'`
        )
        .all();

    for (const table of tables) {
        // Write Table Creation DDL
        writeStream.write(`-- Table structure for ${table.name}\n`);
        writeStream.write(`${table.sql};\n\n`);

        // 2. Fetch table rows
        const rows = db.prepare(`SELECT * FROM "${table.name}"`).all();
        if (rows.length > 0) {
            writeStream.write(`-- Data for ${table.name}\n`);
            for (const row of rows) {
                const columns = Object.keys(row).map((col) => `"${col}"`).join(', ');
                const values = Object.values(row)
                    .map((val) => {
                        if (val === null) return 'NULL';
                        if (typeof val === 'number') return val;
                        // Escape single quotes for SQL compatibility
                        return `'${String(val).replace(/'/g, "''")}'`;
                    })
                    .join(', ');

                writeStream.write(
                    `INSERT INTO "${table.name}" (${columns}) VALUES (${values});\n`
                );
            }
            writeStream.write('\n');
        }
    }

    // 3. Fetch Indexes, Triggers, and Views
    const schemaExtras = db
        .prepare(
            `SELECT sql FROM sqlite_master 
       WHERE type IN ('index', 'trigger', 'view') 
       AND name NOT LIKE 'sqlite_%' AND sql IS NOT NULL`
        )
        .all();

    if (schemaExtras.length > 0) {
        writeStream.write('-- Indexes, Views, & Triggers\n');
        for (const extra of schemaExtras) {
            writeStream.write(`${extra.sql};\n`);
        }
    }

    writeStream.write('\nCOMMIT;\n');
    writeStream.write('PRAGMA foreign_keys = ON;\n');

    writeStream.end();
    console.log(`✨ Dump successfully saved to ${outputFile}`);
}

try {
    generateSqlDump();
} catch (error) {
    console.error('❌ Failed to create dump:', error);
} finally {
    db.close();
}

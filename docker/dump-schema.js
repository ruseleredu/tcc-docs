const Database = require('better-sqlite3');
const fs = require('fs');

const db = new Database('database.sqlite');
const outputFile = 'schema_dump.sql';

function generateSchemaDump() {
    const writeStream = fs.createWriteStream(outputFile, { encoding: 'utf8' });

    writeStream.write('-- SQLite Schema Dump\n');
    writeStream.write('PRAGMA foreign_keys = ON;\n\n');

    // 1. Fetch table schemas
    const tables = db
        .prepare(
            `SELECT name, sql FROM sqlite_master 
       WHERE type='table' AND name NOT LIKE 'sqlite_%'
       ORDER BY name`
        )
        .all();

    writeStream.write('-- ==========================================\n');
    writeStream.write('-- TABLES\n');
    writeStream.write('-- ==========================================\n\n');

    for (const table of tables) {
        writeStream.write(`DROP TABLE IF EXISTS "${table.name}";\n`);
        writeStream.write(`${table.sql};\n\n`);
    }

    // 2. Fetch Indexes, Triggers, and Views
    const extras = db
        .prepare(
            `SELECT type, name, sql FROM sqlite_master 
       WHERE type IN ('index', 'trigger', 'view') 
       AND name NOT LIKE 'sqlite_%' 
       AND sql IS NOT NULL
       ORDER BY type, name`
        )
        .all();

    if (extras.length > 0) {
        writeStream.write('-- ==========================================\n');
        writeStream.write('-- INDEXES, VIEWS, & TRIGGERS\n');
        writeStream.write('-- ==========================================\n\n');

        for (const item of extras) {
            writeStream.write(`-- ${item.type.toUpperCase()}: ${item.name}\n`);
            writeStream.write(`${item.sql};\n\n`);
        }
    }

    writeStream.end();
    console.log(`✨ Schema successfully dumped to ${outputFile}`);
}

try {
    generateSchemaDump();
} catch (error) {
    console.error('❌ Schema dump failed:', error);
} finally {
    db.close();
}

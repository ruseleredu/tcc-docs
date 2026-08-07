// scripts/fetch-db.js
const Database = require('better-sqlite3');
const fs = require('fs');
const path = require('path');

function exportData() {
    try {
        // 1. Resolve absolute path to SQLite file inside /data
        const dbPath = path.join(__dirname, '../data/mydb.sqlite');

        // Ensure database exists before attempting to read
        if (!fs.existsSync(dbPath)) {
            throw new Error(`Database file not found at: ${dbPath}`);
        }

        // 2. Open connection synchronously
        const db = new Database(dbPath);

        // 3. Query your table (.all() returns an array of plain JavaScript objects)
        const rows = db.prepare('SELECT id, name, category, status FROM my_table').all();

        // 4. Ensure destination directory exists
        const outputDir = path.join(__dirname, '../src/data');
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }

        // 5. Save as JSON for Docusaurus React components
        fs.writeFileSync(
            path.join(outputDir, 'tableData.json'),
            JSON.stringify(rows, null, 2)
        );

        // 6. Clean up connection
        db.close();

        console.log('✅ SQLite data exported to src/data/tableData.json');
    } catch (err) {
        console.error('❌ Failed to export SQLite data:', err);
        process.exit(1);
    }
}

exportData();

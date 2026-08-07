const React = require('react');
const { renderToFile, Document, Page, Text, View, StyleSheet } = require('@react-pdf/renderer');
const Database = require('better-sqlite3');
const path = require('path');
const fs = require('fs');

// Create styles using Flexbox
const styles = StyleSheet.create({
    page: { padding: 30, fontSize: 10, fontFamily: 'Helvetica' },
    title: { fontSize: 18, marginBottom: 15, fontWeight: 'bold' },
    table: { display: 'table', width: 'auto', borderStyle: 'solid', borderWidth: 1, borderColor: '#bfbfbf' },
    tableRow: { flexDirection: 'row' },
    tableHeader: { backgroundColor: '#f0f0f0', fontWeight: 'bold' },
    colHeader: { padding: 5, borderWidth: 1, borderColor: '#bfbfbf', width: '25%' },
    colCell: { padding: 5, borderWidth: 1, borderColor: '#bfbfbf', width: '25%' },
});

// React component representing the PDF document
function PdfDocument({ data }) {
    return (
        React.createElement(Document, null,
            React.createElement(Page, { size: 'A4', style: styles.page },
                React.createElement(Text, { style: styles.title }, 'SQLite Database Report'),
                React.createElement(View, { style: styles.table },
                    // Header Row
                    React.createElement(View, { style: [styles.tableRow, styles.tableHeader] },
                        React.createElement(Text, { style: styles.colHeader }, 'ID'),
                        React.createElement(Text, { style: styles.colHeader }, 'Name'),
                        React.createElement(Text, { style: styles.colHeader }, 'Category'),
                        React.createElement(Text, { style: styles.colHeader }, 'Status')
                    ),
                    // Data Rows
                    data.map((row) =>
                        React.createElement(View, { style: styles.tableRow, key: row.id },
                            React.createElement(Text, { style: styles.colCell }, String(row.id)),
                            React.createElement(Text, { style: styles.colCell }, row.name),
                            React.createElement(Text, { style: styles.colCell }, row.category),
                            React.createElement(Text, { style: styles.colCell }, row.status)
                        )
                    )
                )
            )
        )
    );
}

async function generatePdf() {
    const dbPath = path.join(__dirname, '../data/mydb.sqlite');
    const db = new Database(dbPath);
    const rows = db.prepare('SELECT id, name, category, status FROM my_table').all();
    db.close();

    const outputDir = path.join(__dirname, '../static/pdf');
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    const outputPath = path.join(outputDir, 'report.pdf');
    await renderToFile(React.createElement(PdfDocument, { data: rows }), outputPath);
    console.log('✅ PDF generated successfully using @react-pdf/renderer at static/pdf/report.pdf');
}

generatePdf().catch(console.error);

// src/components/SqlTable.js
import React from 'react';
import tableData from '../data/tableData.json';

export default function SqlTable() {
    if (!tableData || tableData.length === 0) {
        return <p>No data available in SQLite table.</p>;
    }

    const columns = Object.keys(tableData[0]);

    return (
        <div style={{ overflowX: 'auto', margin: '1rem 0' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                <thead>
                    <tr>
                        {columns.map((col) => (
                            <th key={col} style={{ borderBottom: '2px solid var(--ifm-color-emphasis-300)', textAlign: 'left', padding: '8px' }}>
                                {col.toUpperCase()}
                            </th>
                        ))}
                    </tr>
                </thead>
                <tbody>
                    {tableData.map((row, idx) => (
                        <tr key={idx}>
                            {columns.map((col) => (
                                <td key={col} style={{ borderBottom: '1px solid var(--ifm-color-emphasis-200)', padding: '8px' }}>
                                    {row[col]}
                                </td>
                            ))}
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}

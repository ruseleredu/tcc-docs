const Database = require('better-sqlite3');
const { fakerPT_BR: faker } = require('@faker-js/faker');

const db = new Database('database.sqlite', { verbose: console.log });

try {
    // Ensure Foreign Keys are respected
    db.pragma('foreign_keys = ON');

    const seedDatabase = db.transaction(() => {
        console.log('🌱 Starting database seeding...\n');

        // Helper to generate a random date in YYYY-MM-DD
        const randomDate = (startYear = 2020, endYear = 2026) => {
            return faker.date
                .between({
                    from: `${startYear}-01-01`,
                    to: `${endYear}-12-31`,
                })
                .toISOString()
                .split('T')[0];
        };

        // -------------------------------------------------------------
        // 1. DAELT: PROFESSORES
        // -------------------------------------------------------------
        console.log('Seeding PROFESSORES...');
        const stmtProf = db.prepare(`
      INSERT INTO PROFESSORES (ID, NOME, EMAIL, EMAIL2, EFETIVO, DATA_INICIO, DATA_FIM)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `);

        for (let i = 1; i <= 20; i++) {
            stmtProf.run(
                i,
                faker.person.fullName(),
                faker.internet.email().toLowerCase(),
                faker.datatype.boolean(0.3) ? faker.internet.email().toLowerCase() : null,
                faker.datatype.boolean(0.85) ? 1 : 0,
                randomDate(2015, 2022),
                null
            );
        }

        // -------------------------------------------------------------
        // 2. DAELT: ALUNOS
        // -------------------------------------------------------------
        console.log('Seeding ALUNOS...');
        const stmtAluno = db.prepare(`
      INSERT INTO ALUNOS (ID, NOME, EMAIL, DATA_INICIO, DATA_FIM)
      VALUES (?, ?, ?, ?, ?)
    `);

        for (let i = 1000; i <= 1050; i++) {
            stmtAluno.run(
                i,
                faker.person.fullName(),
                faker.internet.email().toLowerCase(),
                randomDate(2021, 2024),
                null
            );
        }

        // -------------------------------------------------------------
        // 3. DAELT: GRUPOS
        // -------------------------------------------------------------
        console.log('Seeding GRUPOS...');
        const stmtGrupo = db.prepare(`
      INSERT INTO GRUPOS (ID, NOME, ID_LIDER)
      VALUES (?, ?, ?)
    `);

        const gruposList = [
            'Sistemas Embarcados e IoT',
            'Processamento Digital de Sinais',
            'Automação e Robótica',
            'Inteligência Artificial Aplicada',
            'Telecomunicações e Redes',
        ];

        gruposList.forEach((nome, idx) => {
            stmtGrupo.run(idx + 1, nome, faker.number.int({ min: 1, max: 20 }));
        });

        // -------------------------------------------------------------
        // 4. DAELT: DOMINIO_DISCIPLINAS
        // -------------------------------------------------------------
        console.log('Seeding DOMINIO_DISCIPLINAS...');
        const stmtDisc = db.prepare(`
      INSERT INTO DOMINIO_DISCIPLINAS (ID, ID_RESPONSAVEL, ID_COORDENADOR, ID_AGREGADOR, NOME, CURSO, SIGLA)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `);

        const disciplinas = [
            { id: 'ET71A', nome: 'Trabalho de Conclusão de Curso 1', sigla: 'TCC1' },
            { id: 'ET72A', nome: 'Trabalho de Conclusão de Curso 2', sigla: 'TCC2' },
            { id: 'ET70A', nome: 'Metodologia de Pesquisa', sigla: 'METOD' },
        ];

        disciplinas.forEach((d) => {
            stmtDisc.run(
                d.id,
                faker.number.int({ min: 1, max: 20 }),
                faker.number.int({ min: 1, max: 20 }),
                'AGR01',
                d.nome,
                'Engenharia Eletrônica',
                d.sigla
            );
        });

        // -------------------------------------------------------------
        // 5. TCC: DOMINIO_BANCAS & DOMINIO_DEVEDORES
        // -------------------------------------------------------------
        console.log('Seeding DOMINIO_BANCAS & DOMINIO_DEVEDORES...');
        const stmtBancaTipo = db.prepare(`INSERT INTO DOMINIO_BANCAS (ID, NOME) VALUES (?, ?)`);
        stmtBancaTipo.run(1, 'Proposta de TCC 1');
        stmtBancaTipo.run(2, 'Defesa Final de TCC 2');

        const stmtDevedores = db.prepare(`INSERT INTO DOMINIO_DEVEDORES (ID, NOME) VALUES (?, ?)`);
        const devedores = ['EQUIPE', 'ORIENTADOR', 'LIDER', 'BANCA'];
        devedores.forEach((nome, idx) => stmtDevedores.run(idx + 1, nome));

        // -------------------------------------------------------------
        // 6. TCC: DOCUMENTOS
        // -------------------------------------------------------------
        console.log('Seeding DOCUMENTOS...');
        const stmtDocs = db.prepare(`INSERT INTO DOCUMENTOS (ID, NOME, ID_DEVEDOR) VALUES (?, ?, ?)`);
        const docs = [
            { id: 1, nome: 'Termo de Aceite de Orientação', devedor: 2 },
            { id: 2, nome: 'Proposta de TCC', devedor: 1 },
            { id: 3, nome: 'Relatório Final em PDF', devedor: 1 },
            { id: 4, nome: 'Ata de Defesa', devedor: 4 },
        ];
        docs.forEach((doc) => stmtDocs.run(doc.id, doc.nome, doc.devedor));

        // -------------------------------------------------------------
        // 7. TCC: EQUIPES
        // -------------------------------------------------------------
        console.log('Seeding EQUIPES...');
        const stmtEquipe = db.prepare(`
      INSERT INTO EQUIPES (ID, TITULO, ATIVA, ID_LIDER, DATA_INICIO, DATA_FIM)
      VALUES (?, ?, ?, ?, ?, ?)
    `);

        const equipes = [];
        for (let i = 1; i <= 10; i++) {
            const eqId = `EQ-2026-${String(i).padStart(3, '0')}`;
            equipes.push(eqId);

            stmtEquipe.run(
                eqId,
                `Desenvolvimento de ${faker.company.catchPhrase()}`,
                1,
                faker.number.int({ min: 1, max: 20 }),
                '2026-02-15',
                null
            );
        }

        // -------------------------------------------------------------
        // 8. RELATIONS: EQUIPES_ALUNOS & EQUIPES_ORIENTADORES
        // -------------------------------------------------------------
        console.log('Seeding EQUIPES_ALUNOS & EQUIPES_ORIENTADORES...');
        const stmtEqAluno = db.prepare(`
      INSERT INTO EQUIPES_ALUNOS (ID_EQUIPE, ID_ALUNO, DATA_INICIO, DATA_FIM)
      VALUES (?, ?, ?, ?)
    `);

        const stmtEqOrient = db.prepare(`
      INSERT INTO EQUIPES_ORIENTADORES (ID_EQUIPE, ID_ORIENTADOR, ORIENTACAO, DATA_INICIO, DATA_FIM)
      VALUES (?, ?, ?, ?, ?)
    `);

        let studentIdCounter = 1000;
        equipes.forEach((eqId) => {
            // Add 2 students per team
            stmtEqAluno.run(eqId, studentIdCounter++, '2026-02-15', null);
            stmtEqAluno.run(eqId, studentIdCounter++, '2026-02-15', null);

            // Add 1 primary advisor + 1 co-advisor
            stmtEqOrient.run(eqId, faker.number.int({ min: 1, max: 10 }), 1, '2026-02-15', null);
            stmtEqOrient.run(eqId, faker.number.int({ min: 11, max: 20 }), 0, '2026-02-15', null);
        });

        // -------------------------------------------------------------
        // 9. TCC: BANCAS_EQUIPES & BANCAS_PROFESSORES
        // -------------------------------------------------------------
        console.log('Seeding BANCAS_EQUIPES & BANCAS_PROFESSORES...');
        const stmtBanca = db.prepare(`
      INSERT INTO BANCAS_EQUIPES (ID_TIPO, ID_EQUIPE, NOTA, DATA_APRESENTACAO, HORA_APRESENTACAO, DATA_INICIO, DATA_FIM)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `);

        const stmtBancaProf = db.prepare(`
      INSERT INTO BANCAS_PROFESSORES (ID_BANCA, ID_PROFESSOR)
      VALUES (?, ?)
    `);

        equipes.forEach((eqId) => {
            const result = stmtBanca.run(
                1,
                eqId,
                faker.number.float({ min: 7.0, max: 10.0, fractionDigits: 1 }),
                '2026-06-20',
                '14:00:00',
                '2026-02-15',
                null
            );

            const bancaId = result.lastInsertRowid;

            // Assign 3 professors to the defense panel
            const profs = faker.helpers.arrayElements([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 3);
            profs.forEach((pId) => stmtBancaProf.run(bancaId, pId));
        });

        console.log('\n✨ Database successfully seeded!');
    });

    seedDatabase();
} catch (error) {
    console.error('❌ Seeding failed:', error);
} finally {
    db.close();
}

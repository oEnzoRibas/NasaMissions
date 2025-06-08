-- SCENARIO C: Attempting to add a Nave WITH a Tripulante
-- EXPECTED OUTCOME: SUCCEED

BEGIN;

INSERT INTO naves (nome, tipo, fabricante, ano_construcao, status)
VALUES ('Test Nave Success Crew Script', 'Type C', 'Test Corp', 2024, 'Active');

INSERT INTO tripulantes (id_nave, nome_tripulante, data_de_nascimento, genero, nacionalidade, competencia, data_ingresso, status)
VALUES (
    currval(pg_get_serial_sequence('naves', 'id_nave')), 
    'Captain Eva Rostova Script',
    '1990-05-15', 
    'Feminino',
    'Estelar Union',
    'Comandante',
    '2023-01-10',
    'Ativo'
);

COMMIT;

SELECT * FROM naves WHERE nome = 'Test Nave Success Crew Script';
SELECT t.* FROM tripulantes t JOIN naves n ON t.id_nave = n.id_nave WHERE n.nome = 'Test Nave Success Crew Script';

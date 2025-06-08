-- SCENARIO B: Attempting to add a Nave WITH a Mission
-- EXPECTED OUTCOME: SUCCEED

BEGIN;

INSERT INTO naves (nome, tipo, fabricante, ano_construcao, status)
VALUES ('Test Nave Success Mission Script', 'Type B', 'Test Corp', 2024, 'Active');

INSERT INTO missoes (id_nave, nome_missao, data_lancamento, destino, duracao_dias, resultado, descricao)
VALUES (
    currval(pg_get_serial_sequence('naves', 'id_nave')), 
    'Maiden Flight Mission Script',
    '2024-10-15',
    'Orbit',
    7,
    'Scheduled',
    'Test mission for Test Nave Success Mission Script'
);

COMMIT;

SELECT * FROM naves WHERE nome = 'Test Nave Success Mission Script';
SELECT m.* FROM missoes m JOIN naves n ON m.id_nave = n.id_nave WHERE n.nome = 'Test Nave Success Mission Script';


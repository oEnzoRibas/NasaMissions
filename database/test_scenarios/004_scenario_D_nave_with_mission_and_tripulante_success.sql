-- SCENARIO D: Attempting to add a Nave WITH BOTH a Mission AND a Tripulante
-- EXPECTED OUTCOME: SUCCEED
-- Run this script using psql: psql -U your_username -d nasa_missions -f 004_scenario_D_nave_with_mission_and_tripulante_success.sql


BEGIN;

INSERT INTO naves (nome, tipo, fabricante, ano_construcao, status)
VALUES ('Nasa Super Star', 'Type D', 'NASA', 2024, 'Active');

INSERT INTO missoes (id_nave, nome_missao, data_lancamento, destino, duracao_dias, resultado, descricao)
VALUES (
    currval(pg_get_serial_sequence('naves', 'id_nave')), 
    'Nasa Super Star Exploration Gamma Script',
    '2025-01-01',
    'Sector Gamma-7',
    365,
    'Planned',
    'Long-range exploration mission'
);

INSERT INTO tripulantes (id_nave, nome_tripulante, data_de_nascimento, genero, nacionalidade, competencia, data_ingresso, status)
VALUES (
    currval(pg_get_serial_sequence('naves', 'id_nave')), 
    'Enzo Ribas Chief Engineer Nasa Super Star',
    '2005-11-20',
    'Masculino',
    'Enzo Ribas',
    'Engenheiro Chefe',
    '2022-03-15',
    'Ativo'
);

COMMIT;

SELECT * FROM naves WHERE nome = 'Test Nave Fully Equipped Script';
SELECT m.* FROM missoes m JOIN naves n ON m.id_nave = n.id_nave WHERE n.nome = 'Nasa Super Star';
SELECT t.* FROM tripulantes t JOIN naves n ON t.id_nave = n.id_nave WHERE n.nome = 'Nasa Super Star';

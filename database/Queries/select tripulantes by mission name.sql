SELECT * FROM "equipe_missoes";

SELECT t.nome_tripulante AS nome, t.competencia, m.nome_missao, m.data_lancamento
FROM "tripulantes" t
JOIN "missoes" m ON t.id_nave = m.id_nave;

SELECT t.nome_tripulante, em.funcao_na_missao
FROM "equipe_missoes" em
JOIN "tripulantes" t ON em.id_tripulante = t.id_tripulante
JOIN "missoes" m ON em.id_missao = m.id_missao
WHERE m.nome_missao = 'Apollo 11 - Lua';

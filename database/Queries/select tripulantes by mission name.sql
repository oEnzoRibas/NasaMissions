select * from
EquipeMissoes


select t.nome_tripulante as 'nome', t.competencia, m.nome_missao, m.data_lancamento from
Tripulantes T
JOIN Missoes M ON T.id_nave = M.id_nave

SELECT t.nome_tripulante, em.funcao_na_missao
FROM EquipeMissoes em
JOIN Tripulantes t ON em.id_tripulante = t.id_tripulante
JOIN Missoes m ON em.id_missao = m.id_missao
WHERE m.nome_missao = 'Apollo 11 - Lua';
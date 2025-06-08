SELECT n.nome, t.nome_tripulante, m.nome_missao
FROM naves n
JOIN tripulantes t ON n.id_nave = t.id_nave
JOIN missoes m ON n.id_nave = m.id_nave
--WHERE m.nome_missao = 'Apollo 11 - Lua';

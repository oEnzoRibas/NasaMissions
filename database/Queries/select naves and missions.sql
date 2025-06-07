
SELECT n.nome as "Nome da Nave",
n.tipo,
n.fabricante,
n.ano_construcao,
n.status,
m.nome_missao as "Nome da Missão",
m.data_lancamento as "Data de início",
m.duracao_dias as "Duração",
m.resultado as "Resultado",
m.descricao
FROM 
	naves n JOIN missoes m on n.id_nave = m.id_nave

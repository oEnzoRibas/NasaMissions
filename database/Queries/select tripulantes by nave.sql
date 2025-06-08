
SELECT * FROM naves WHERE nome = 'Nasa Super Star';
SELECT m.* FROM missoes m JOIN naves n ON m.id_nave = n.id_nave WHERE n.nome = 'Nasa Super Star';
SELECT t.* FROM tripulantes t JOIN naves n ON t.id_nave = n.id_nave WHERE n.nome = 'Nasa Super Star';
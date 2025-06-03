USE NASA_Missions
SELECT * FROM Tripulantes T
JOIN NAVES N ON t.id_nave = n.id_nave
WHERE T.nome_tripulante LIKE 'e%'

delete from Tripulantes where id_tripulante
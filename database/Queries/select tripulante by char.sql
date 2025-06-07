-- Switch to the NASA_Missions database (in psql, use \c NASA_Missions)
-- \c NASA_Missions

SELECT * FROM Tripulantes T
JOIN Naves N ON T.id_nave = N.id_nave
WHERE T.nome_tripulante ILIKE 'e%';


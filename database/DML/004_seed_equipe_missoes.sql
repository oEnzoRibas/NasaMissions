-- Popular EquipeMissao associando cada tripulante à missão correspondente pela nave
    INSERT INTO Equipe_Missoes (id_missao, id_tripulante, funcao_na_missao)
    SELECT
        m.id_missao,
        t.id_tripulante,
        t.competencia
    FROM
        Missoes m
    JOIN
        Tripulantes t ON m.id_nave = t.id_nave;

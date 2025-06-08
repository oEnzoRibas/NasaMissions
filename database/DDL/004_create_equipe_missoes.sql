-- Tabela EquipeMissoes (Relaciona missão e tripulante)
    CREATE TABLE IF NOT EXISTS equipe_missoes (
        id_missao INT REFERENCES missoes(id_missao) ON DELETE NO ACTION,
        id_tripulante INT REFERENCES tripulantes(id_tripulante) ON DELETE NO ACTION,
        funcao_na_missao VARCHAR(100),
        PRIMARY KEY (id_missao, id_tripulante)
    );

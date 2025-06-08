-- Tabela Missoes
    CREATE TABLE IF NOT EXISTS missoes (
        id_missao SERIAL PRIMARY KEY,
        id_nave INT REFERENCES naves(id_nave) ON DELETE CASCADE,
        nome_missao VARCHAR(100) NOT NULL,
        data_lancamento DATE NOT NULL,
        destino VARCHAR(100) NOT NULL,
        duracao_dias INT NOT NULL,
        resultado VARCHAR(50) NOT NULL,
        descricao TEXT
    );

-- Tabela Tripulantes
    CREATE TABLE tripulantes (
        id_tripulante SERIAL PRIMARY KEY,
        id_nave INT REFERENCES naves(id_nave) ON DELETE CASCADE,
        nome_tripulante VARCHAR(100) NOT NULL,
        data_de_nascimento DATE NOT NULL,
        genero VARCHAR(20) NOT NULL,
        nacionalidade VARCHAR(50) NOT NULL,
        competencia VARCHAR(100) NOT NULL,
        data_ingresso DATE NOT NULL,
        status VARCHAR(30) NOT NULL
    );

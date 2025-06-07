-- Tabela Naves
    CREATE TABLE naves (
        id_nave SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        tipo VARCHAR(50) NOT NULL,
        fabricante VARCHAR(100) NOT NULL,
        ano_construcao INT NOT NULL,
        status VARCHAR(30) NOT NULL
    );

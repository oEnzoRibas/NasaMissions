    -- Criação do banco (execute no terminal ou pgAdmin, não no script SQL)
    -- CREATE DATABASE nasa_missions;

    -- Depois conecte-se ao banco nasa_missions
    -- \c nasa_missions

    -- Tabela Naves
    CREATE TABLE naves (
        id_nave SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        tipo VARCHAR(50) NOT NULL,
        fabricante VARCHAR(100) NOT NULL,
        ano_construcao INT NOT NULL,
        status VARCHAR(30) NOT NULL
    );

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

    -- Tabela Missoes
    CREATE TABLE missoes (
        id_missao SERIAL PRIMARY KEY,
        id_nave INT REFERENCES naves(id_nave) ON DELETE CASCADE,
        nome_missao VARCHAR(100) NOT NULL,
        data_lancamento DATE NOT NULL,
        destino VARCHAR(100) NOT NULL,
        duracao_dias INT NOT NULL,
        resultado VARCHAR(50) NOT NULL,
        descricao TEXT
    );

    -- Tabela EquipeMissoes (Relaciona missão e tripulante)
    CREATE TABLE equipe_missoes (
        id_missao INT REFERENCES missoes(id_missao) ON DELETE NO ACTION,
        id_tripulante INT REFERENCES tripulantes(id_tripulante) ON DELETE NO ACTION,
        funcao_na_missao VARCHAR(100),
        PRIMARY KEY (id_missao, id_tripulante)
    );

    -- Inserção de Naves
    INSERT INTO naves (nome, tipo, fabricante, ano_construcao, status) VALUES
    ('Apollo 11', 'Tripulada', 'NASA', 1969, 'Aposentada'),
    ('Voyager 1', 'Sonda', 'NASA', 1977, 'Ativa'),
    ('Starship', 'Carga/Tripulada', 'SpaceX', 2023, 'Ativa'),
    ('Perseverance', 'Rover', 'NASA', 2020, 'Ativa'),
    ('Mars Reconnaissance Orbiter', 'Satélite', 'NASA', 2006, 'Ativa'),
    ('James Webb', 'Telescópio Espacial', 'NASA/ESA/CSA', 2021, 'Ativa'),
    ('Mars Odyssey', 'Sonda', 'NASA', 2001, 'Ativa'),
    ('Mars Express', 'Sonda', 'ESA', 2003, 'Ativa'),
    ('Mars Global Surveyor', 'Sonda', 'NASA', 1996, 'Finalizada'),
    ('Curiosity', 'Rover', 'NASA', 2011, 'Ativa'),
    ('Hubble', 'Telescópio', 'NASA/ESA', 1990, 'Ativa'),
    ('Challenger', 'Ônibus Espacial', 'NASA', 1982, 'Destruída'),
    ('Discovery', 'Ônibus Espacial', 'NASA', 1983, 'Aposentada'),
    ('Atlantis', 'Ônibus Espacial', 'NASA', 1985, 'Aposentada'),
    ('Spirit', 'Rover', 'NASA', 2003, 'Inativa'),
    ('Opportunity', 'Rover', 'NASA', 2003, 'Inativa'),
    ('New Horizons', 'Sonda', 'NASA', 2006, 'Ativa'),
    ('Cassini', 'Sonda', 'NASA/ESA/ASI', 1997, 'Finalizada'),
    ('Juno', 'Sonda', 'NASA', 2011, 'Ativa'),
    ('Millennium Falcon', 'Carga/Tripulada', 'Corellian Engineering Corporation', 1977, 'Ficcional'),
    ('Enterprise NCC-1701', 'Exploração', 'Starfleet', 2265, 'Ficcional'),
    ('X-Wing', 'Caça', 'Incom Corporation', 1977, 'Ficcional'),
    ('Nave dos Guardiões', 'Transporte', 'Guardiões da Galáxia', 2014, 'Ficcional'),
    ('Batmóvel Espacial', 'Veículo', 'Wayne Enterprises', 2022, 'Ficcional'),
    ('Nave dos Superamigos', 'Transporte', 'Superamigos', 1973, 'Ficcional'),
    ('Planet Express', 'Entrega', 'Planet Express', 2999, 'Ficcional'),
    ('Nave dos Jetsons', 'Familiar', 'Spacely Sprockets', 2062, 'Ficcional');

    -- Inserção de Missões
    INSERT INTO missoes (id_nave, nome_missao, data_lancamento, destino, duracao_dias, resultado, descricao) VALUES
    (1, 'Apollo 11 - Lua', '1969-07-16', 'Lua', 8, 'Sucesso', 'Primeiro pouso tripulado na Lua'),
    (2, 'Voyager 1 - Interestelar', '1977-09-05', 'Espaço Interestelar', 17000, 'Sucesso', 'Exploração além do sistema solar'),
    (3, 'Starship SN24 - Marte Teste', '2025-05-01', 'Marte', 180, 'Em andamento', 'Missão de teste rumo a Marte'),
    (4, 'Perseverance - Marte', '2020-07-30', 'Marte', 687, 'Sucesso', 'Exploração e coleta de amostras em Marte'),
    (5, 'Mars Reconnaissance Orbiter - Marte', '2006-08-12', 'Marte', 6000, 'Sucesso', 'Estudo da atmosfera e superfície de Marte'),
    (6, 'James Webb - Universo', '2021-12-25', 'Espaço Profundo', 365, 'Em andamento', 'Observação do universo em diferentes comprimentos de onda'),
    (7, 'Mars Odyssey - Marte', '2001-04-07', 'Marte', 8000, 'Sucesso', 'Estudo da superfície e clima de Marte'),
    (8, 'Mars Express - Marte', '2003-06-02', 'Marte', 7000, 'Sucesso', 'Exploração da atmosfera e geologia de Marte'),
    (9, 'Mars Global Surveyor - Marte', '1996-11-07', 'Marte', 4000, 'Finalizada', 'Mapeamento detalhado da superfície de Marte'),
    (10, 'Curiosity - Marte', '2011-11-26', 'Marte', 3000, 'Sucesso', 'Análise química e geológica de Marte'),
    (11, 'Hubble - Universo', '1990-04-24', 'Espaço Profundo', 12000, 'Sucesso', 'Observação astronômica de galáxias e estrelas'),
    (12, 'Challenger - Ônibus Espacial Trágico', '1983-04-04', 'Órbita da Terra', 73, 'Fracasso', 'Missão trágica, destruição durante lançamento'),
    (13, 'Discovery - Ônibus Espacial Aposentado', '1984-08-30', 'Órbita da Terra', 365, 'Aposentada', 'Diversas missões de sucesso, aposentada'),
    (14, 'Atlantis - Ônibus Espacial Aposentado', '1985-10-03', 'Órbita da Terra', 300, 'Aposentada', 'Diversas missões de sucesso, aposentada'),
    (15, 'Spirit - Rover Inativo em Marte', '2003-06-10', 'Marte', 2210, 'Finalizada', 'Rover inativo após missão bem-sucedida em Marte'),
    (16, 'Opportunity - Rover Inativo em Marte', '2003-07-07', 'Marte', 5111, 'Finalizada', 'Rover inativo após missão prolongada em Marte'),
    (17, 'New Horizons - Plutão e Cinturão de Kuiper', '2006-01-19', 'Plutão/Cinturão de Kuiper', 3462, 'Sucesso', 'Sobrevoo de Plutão e exploração do Cinturão de Kuiper'),
    (18, 'Cassini - Saturno Finalizada', '1997-10-15', 'Saturno', 4832, 'Finalizada', 'Missão de exploração de Saturno e suas luas'),
    (19, 'Juno - Júpiter', '2011-08-05', 'Júpiter', 4000, 'Sucesso', 'Estudo da atmosfera e campo gravitacional de Júpiter'),
    (20, 'Kessel Run', '1977-05-25', 'Kessel', 1, 'Sucesso', 'Millennium Falcon completa o Kessel Run em menos de 12 parsecs (Star Wars)');

    -- Você pode inserir tripulantes e equipe_missoes depois, conforme desejar.


    -- Inserindo Tripulantes
    INSERT INTO Tripulantes (id_nave, nome_tripulante, data_de_nascimento, genero, nacionalidade, competencia, data_ingresso, status) VALUES
    -- Apollo 11
    (1, 'Neil Armstrong', '1930-08-05', 'Masculino', 'Americana', 'Comandante', '1962-09-17', 'Aposentado'),
    (1, 'Buzz Aldrin', '1930-01-20', 'Masculino', 'Americana', 'Piloto do Módulo Lunar', '1963-10-17', 'Aposentado'),
    (1, 'Michael Collins', '1930-10-31', 'Masculino', 'Americana', 'Piloto do Módulo de Comando', '1963-10-17', 'Aposentado'),
    -- Voyager 1 (não tripulada, mas exemplo fictício)
    (2, 'HAL 9000', '1992-01-01', 'Outro', 'Ficcional', 'Inteligência Artificial', '1977-09-05', 'Ativo'),
    -- Starship
    (3, 'Elon Musk', '1971-06-28', 'Masculino', 'Sul-Africana', 'Comandante', '2023-01-01', 'Ativo'),
    (3, 'Jessica Watkins', '1988-05-14', 'Feminino', 'Americana', 'Engenheira de Missão', '2024-01-01', 'Ativo'),
    -- Perseverance (não tripulada, exemplo fictício)
    (4, 'Rover Bot', '2020-07-30', 'Outro', 'Ficcional', 'Robô Cientista', '2020-07-30', 'Ativo'),
    -- Mars Reconnaissance Orbiter (não tripulada, exemplo fictício)
    (5, 'AI Orbiter', '2006-08-12', 'Outro', 'Ficcional', 'Sistema Autônomo', '2006-08-12', 'Ativo'),
    -- James Webb (não tripulada, exemplo fictício)
    (6, 'Webb AI', '2021-12-25', 'Outro', 'Ficcional', 'Controle Óptico', '2021-12-25', 'Ativo'),
    -- Mars Odyssey (não tripulada, exemplo fictício)
    (7, 'Odyssey Bot', '2001-04-07', 'Outro', 'Ficcional', 'Robô Cientista', '2001-04-07', 'Ativo'),
    -- Mars Express (não tripulada, exemplo fictício)
    (8, 'Express AI', '2003-06-02', 'Outro', 'Ficcional', 'Sistema Autônomo', '2003-06-02', 'Ativo'),
    -- Mars Global Surveyor (não tripulada, exemplo fictício)
    (9, 'Surveyor Bot', '1996-11-07', 'Outro', 'Ficcional', 'Robô Cientista', '1996-11-07', 'Inativo'),
    -- Curiosity (não tripulada, exemplo fictício)
    (10, 'Curiosity Bot', '2011-11-26', 'Outro', 'Ficcional', 'Robô Cientista', '2011-11-26', 'Ativo'),
    -- Hubble (não tripulada, exemplo fictício)
    (11, 'Hubble AI', '1990-04-24', 'Outro', 'Ficcional', 'Controle Óptico', '1990-04-24', 'Ativo'),
    -- Challenger
    (12, 'Francis Scobee', '1939-05-19', 'Masculino', 'Americana', 'Comandante', '1978-01-01', 'Falecido'),
    (12, 'Michael Smith', '1945-04-30', 'Masculino', 'Americana', 'Piloto', '1980-01-01', 'Falecido'),
    -- Discovery
    (13, 'John Young', '1930-09-24', 'Masculino', 'Americana', 'Comandante', '1978-01-01', 'Aposentado'),
    (13, 'Judith Resnik', '1949-04-05', 'Feminino', 'Americana', 'Especialista de Missão', '1984-01-01', 'Falecida'),
    -- Atlantis
    (14, 'Frederick Hauck', '1941-04-11', 'Masculino', 'Americana', 'Comandante', '1985-01-01', 'Aposentado'),
    (14, 'Mary Cleave', '1947-02-05', 'Feminino', 'Americana', 'Especialista de Missão', '1985-01-01', 'Aposentada'),
    -- Spirit (não tripulada, exemplo fictício)
    (15, 'Spirit Bot', '2003-06-10', 'Outro', 'Ficcional', 'Robô Cientista', '2003-06-10', 'Inativo'),
    -- Opportunity (não tripulada, exemplo fictício)
    (16, 'Opportunity Bot', '2003-07-07', 'Outro', 'Ficcional', 'Robô Cientista', '2003-07-07', 'Inativo'),
    -- New Horizons (não tripulada, exemplo fictício)
    (17, 'Horizons AI', '2006-01-19', 'Outro', 'Ficcional', 'Sistema Autônomo', '2006-01-19', 'Ativo'),
    -- Cassini (não tripulada, exemplo fictício)
    (18, 'Cassini Bot', '1997-10-15', 'Outro', 'Ficcional', 'Robô Cientista', '1997-10-15', 'Finalizado'),
    -- Juno (não tripulada, exemplo fictício)
    (19, 'Juno AI', '2011-08-05', 'Outro', 'Ficcional', 'Sistema Autônomo', '2011-08-05', 'Ativo'),
    -- Millennium Falcon (Star Wars)
    (20, 'Han Solo', '1929-07-29', 'Masculino', 'Corelliano', 'Capitão', '1977-05-25', 'Ativo'),
    (20, 'Chewbacca', '1180-01-01', 'Masculino', 'Wookiee', 'Co-piloto', '1977-05-25', 'Ativo'),
    -- Enterprise NCC-1701 (Star Trek)
    (21, 'James T. Kirk', '2233-03-22', 'Masculino', 'Terráqueo', 'Capitão', '2265-09-08', 'Ativo'),
    (21, 'Spock', '2230-01-06', 'Masculino', 'Vulcano', 'Oficial de Ciências', '2265-09-08', 'Ativo'),
    -- X-Wing (Star Wars)
    (22, 'Luke Skywalker', '1919-05-25', 'Masculino', 'Tatooiniano', 'Piloto', '1977-05-25', 'Ativo'),
    -- Nave dos Guardiões (Marvel)
    (23, 'Peter Quill', '1980-02-04', 'Masculino', 'Terráqueo', 'Líder', '2014-08-01', 'Ativo'),
    (23, 'Gamora', '1985-03-15', 'Feminino', 'Zen-Whoberiana', 'Combatente', '2014-08-01', 'Ativo'),
    -- Batmóvel Espacial (DC)
    (24, 'Bruce Wayne', '1972-02-19', 'Masculino', 'Americana', 'Batman', '2022-03-04', 'Ativo'),
    -- Nave dos Superamigos (DC)
    (25, 'Superman', '1938-06-01', 'Masculino', 'Kryptoniano', 'Líder', '1973-09-08', 'Ativo'),
    (25, 'Mulher-Maravilha', '1941-10-21', 'Feminino', 'Amazona', 'Combatente', '1973-09-08', 'Ativa'),
    -- Planet Express (Futurama)
    (26, 'Philip J. Fry', '1974-08-14', 'Masculino', 'Americana', 'Entregador', '2999-03-28', 'Ativo'),
    (26, 'Turanga Leela', '2975-07-29', 'Feminino', 'Mutante', 'Capitã', '2999-03-28', 'Ativa'),
    -- Nave dos Jetsons
    (27, 'George Jetson', '2022-07-31', 'Masculino', 'Americana', 'Pai de Família', '2062-09-23', 'Ativo'),
    (27, 'Jane Jetson', '2024-04-01', 'Feminino', 'Americana', 'Mãe de Família', '2062-09-23', 'Ativa');


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

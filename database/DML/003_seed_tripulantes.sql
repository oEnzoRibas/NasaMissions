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

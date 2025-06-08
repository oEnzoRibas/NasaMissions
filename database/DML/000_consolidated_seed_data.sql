-- Consolidated Seed Data for Nasa_Missions, using stored function
-- This script ensures each nave is inserted with at least one mission or tripulante.

SELECT create_nave_with_dependencies(
    'Apollo 11', 
    'Tripulada', 
    'NASA', 
    1969, 
    'Aposentada',
    '[{"nome_missao": "Apollo 11 - Lua", "data_lancamento": "1969-07-16", "destino": "Lua", "duracao_dias": 8, "resultado": "Sucesso", "descricao": "Primeiro pouso tripulado na Lua"}]'::JSONB,
    '[{"nome_tripulante": "Neil Armstrong", "data_de_nascimento": "1930-08-05", "genero": "Masculino", "nacionalidade": "Americana", "competencia": "Comandante", "data_ingresso": "1962-09-17", "status": "Aposentado"}, {"nome_tripulante": "Buzz Aldrin", "data_de_nascimento": "1930-01-20", "genero": "Masculino", "nacionalidade": "Americana", "competencia": "Piloto do Módulo Lunar", "data_ingresso": "1963-10-17", "status": "Aposentado"}, {"nome_tripulante": "Michael Collins", "data_de_nascimento": "1930-10-31", "genero": "Masculino", "nacionalidade": "Americana", "competencia": "Piloto do Módulo de Comando", "data_ingresso": "1963-10-17", "status": "Aposentado"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Voyager 1', 
    'Sonda', 
    'NASA', 
    1977, 
    'Ativa',
    '[{"nome_missao": "Voyager 1 - Interestelar", "data_lancamento": "1977-09-05", "destino": "Espaço Interestelar", "duracao_dias": 17000, "resultado": "Sucesso", "descricao": "Exploração além do sistema solar"}]'::JSONB,
    '[{"nome_tripulante": "HAL 9000", "data_de_nascimento": "1992-01-01", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Inteligência Artificial", "data_ingresso": "1977-09-05", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Starship', 
    'Carga/Tripulada', 
    'SpaceX', 
    2023, 
    'Ativa',
    '[{"nome_missao": "Starship SN24 - Marte Teste", "data_lancamento": "2025-05-01", "destino": "Marte", "duracao_dias": 180, "resultado": "Em andamento", "descricao": "Missão de teste rumo a Marte"}]'::JSONB,
    '[{"nome_tripulante": "Elon Musk", "data_de_nascimento": "1971-06-28", "genero": "Masculino", "nacionalidade": "Sul-Africana", "competencia": "Comandante", "data_ingresso": "2023-01-01", "status": "Ativo"}, {"nome_tripulante": "Jessica Watkins", "data_de_nascimento": "1988-05-14", "genero": "Feminino", "nacionalidade": "Americana", "competencia": "Engenheira de Missão", "data_ingresso": "2024-01-01", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Perseverance', 
    'Rover', 
    'NASA', 
    2020, 
    'Ativa',
    '[{"nome_missao": "Perseverance - Marte", "data_lancamento": "2020-07-30", "destino": "Marte", "duracao_dias": 687, "resultado": "Sucesso", "descricao": "Exploração e coleta de amostras em Marte"}]'::JSONB,
    '[{"nome_tripulante": "Rover Bot", "data_de_nascimento": "2020-07-30", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Robô Cientista", "data_ingresso": "2020-07-30", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Mars Reconnaissance Orbiter', 
    'Satélite', 
    'NASA', 
    2006, 
    'Ativa',
    '[{"nome_missao": "Mars Reconnaissance Orbiter - Marte", "data_lancamento": "2006-08-12", "destino": "Marte", "duracao_dias": 6000, "resultado": "Sucesso", "descricao": "Estudo da atmosfera e superfície de Marte"}]'::JSONB,
    '[{"nome_tripulante": "AI Orbiter", "data_de_nascimento": "2006-08-12", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Sistema Autônomo", "data_ingresso": "2006-08-12", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'James Webb', 
    'Telescópio Espacial', 
    'NASA/ESA/CSA', 
    2021, 
    'Ativa',
    '[{"nome_missao": "James Webb - Universo", "data_lancamento": "2021-12-25", "destino": "Espaço Profundo", "duracao_dias": 365, "resultado": "Em andamento", "descricao": "Observação do universo em diferentes comprimentos de onda"}]'::JSONB,
    '[{"nome_tripulante": "Webb AI", "data_de_nascimento": "2021-12-25", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Controle Óptico", "data_ingresso": "2021-12-25", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Mars Odyssey', 
    'Sonda', 
    'NASA', 
    2001, 
    'Ativa',
    '[{"nome_missao": "Mars Odyssey - Marte", "data_lancamento": "2001-04-07", "destino": "Marte", "duracao_dias": 8000, "resultado": "Sucesso", "descricao": "Estudo da superfície e clima de Marte"}]'::JSONB,
    '[{"nome_tripulante": "Odyssey Bot", "data_de_nascimento": "2001-04-07", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Robô Cientista", "data_ingresso": "2001-04-07", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Mars Express', 
    'Sonda', 
    'ESA', 
    2003, 
    'Ativa',
    '[{"nome_missao": "Mars Express - Marte", "data_lancamento": "2003-06-02", "destino": "Marte", "duracao_dias": 7000, "resultado": "Sucesso", "descricao": "Exploração da atmosfera e geologia de Marte"}]'::JSONB,
    '[{"nome_tripulante": "Express AI", "data_de_nascimento": "2003-06-02", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Sistema Autônomo", "data_ingresso": "2003-06-02", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Mars Global Surveyor', 
    'Sonda', 
    'NASA', 
    1996, 
    'Finalizada',
    '[{"nome_missao": "Mars Global Surveyor - Marte", "data_lancamento": "1996-11-07", "destino": "Marte", "duracao_dias": 4000, "resultado": "Finalizada", "descricao": "Mapeamento detalhado da superfície de Marte"}]'::JSONB,
    '[{"nome_tripulante": "Surveyor Bot", "data_de_nascimento": "1996-11-07", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Robô Cientista", "data_ingresso": "1996-11-07", "status": "Inativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Curiosity', 
    'Rover', 
    'NASA', 
    2011, 
    'Ativa',
    '[{"nome_missao": "Curiosity - Marte", "data_lancamento": "2011-11-26", "destino": "Marte", "duracao_dias": 3000, "resultado": "Sucesso", "descricao": "Análise química e geológica de Marte"}]'::JSONB,
    '[{"nome_tripulante": "Curiosity Bot", "data_de_nascimento": "2011-11-26", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Robô Cientista", "data_ingresso": "2011-11-26", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Hubble', 
    'Telescópio', 
    'NASA/ESA', 
    1990, 
    'Ativa',
    '[{"nome_missao": "Hubble - Universo", "data_lancamento": "1990-04-24", "destino": "Espaço Profundo", "duracao_dias": 12000, "resultado": "Sucesso", "descricao": "Observação astronômica de galáxias e estrelas"}]'::JSONB,
    '[{"nome_tripulante": "Hubble AI", "data_de_nascimento": "1990-04-24", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Controle Óptico", "data_ingresso": "1990-04-24", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Challenger', 
    'Ônibus Espacial', 
    'NASA', 
    1982, 
    'Destruída',
    '[{"nome_missao": "Challenger - Ônibus Espacial Trágico", "data_lancamento": "1983-04-04", "destino": "Órbita da Terra", "duracao_dias": 73, "resultado": "Fracasso", "descricao": "Missão trágica, destruição durante lançamento"}]'::JSONB,
    '[{"nome_tripulante": "Francis Scobee", "data_de_nascimento": "1939-05-19", "genero": "Masculino", "nacionalidade": "Americana", "competencia": "Comandante", "data_ingresso": "1978-01-01", "status": "Falecido"}, {"nome_tripulante": "Michael Smith", "data_de_nascimento": "1945-04-30", "genero": "Masculino", "nacionalidade": "Americana", "competencia": "Piloto", "data_ingresso": "1980-01-01", "status": "Falecido"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Discovery', 
    'Ônibus Espacial', 
    'NASA', 
    1983, 
    'Aposentada',
    '[{"nome_missao": "Discovery - Ônibus Espacial Aposentado", "data_lancamento": "1984-08-30", "destino": "Órbita da Terra", "duracao_dias": 365, "resultado": "Aposentada", "descricao": "Diversas missões de sucesso, aposentada"}]'::JSONB,
    '[{"nome_tripulante": "John Young", "data_de_nascimento": "1930-09-24", "genero": "Masculino", "nacionalidade": "Americana", "competencia": "Comandante", "data_ingresso": "1978-01-01", "status": "Aposentado"}, {"nome_tripulante": "Judith Resnik", "data_de_nascimento": "1949-04-05", "genero": "Feminino", "nacionalidade": "Americana", "competencia": "Especialista de Missão", "data_ingresso": "1984-01-01", "status": "Falecida"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Atlantis', 
    'Ônibus Espacial', 
    'NASA', 
    1985, 
    'Aposentada',
    '[{"nome_missao": "Atlantis - Ônibus Espacial Aposentado", "data_lancamento": "1985-10-03", "destino": "Órbita da Terra", "duracao_dias": 300, "resultado": "Aposentada", "descricao": "Diversas missões de sucesso, aposentada"}]'::JSONB,
    '[{"nome_tripulante": "Frederick Hauck", "data_de_nascimento": "1941-04-11", "genero": "Masculino", "nacionalidade": "Americana", "competencia": "Comandante", "data_ingresso": "1985-01-01", "status": "Aposentado"}, {"nome_tripulante": "Mary Cleave", "data_de_nascimento": "1947-02-05", "genero": "Feminino", "nacionalidade": "Americana", "competencia": "Especialista de Missão", "data_ingresso": "1985-01-01", "status": "Aposentada"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Spirit', 
    'Rover', 
    'NASA', 
    2003, 
    'Inativa',
    '[{"nome_missao": "Spirit - Rover Inativo em Marte", "data_lancamento": "2003-06-10", "destino": "Marte", "duracao_dias": 2210, "resultado": "Finalizada", "descricao": "Rover inativo após missão bem-sucedida em Marte"}]'::JSONB,
    '[{"nome_tripulante": "Spirit Bot", "data_de_nascimento": "2003-06-10", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Robô Cientista", "data_ingresso": "2003-06-10", "status": "Inativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Opportunity', 
    'Rover', 
    'NASA', 
    2003, 
    'Inativa',
    '[{"nome_missao": "Opportunity - Rover Inativo em Marte", "data_lancamento": "2003-07-07", "destino": "Marte", "duracao_dias": 5111, "resultado": "Finalizada", "descricao": "Rover inativo após missão prolongada em Marte"}]'::JSONB,
    '[{"nome_tripulante": "Opportunity Bot", "data_de_nascimento": "2003-07-07", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Robô Cientista", "data_ingresso": "2003-07-07", "status": "Inativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'New Horizons', 
    'Sonda', 
    'NASA', 
    2006, 
    'Ativa',
    '[{"nome_missao": "New Horizons - Plutão e Cinturão de Kuiper", "data_lancamento": "2006-01-19", "destino": "Plutão/Cinturão de Kuiper", "duracao_dias": 3462, "resultado": "Sucesso", "descricao": "Sobrevoo de Plutão e exploração do Cinturão de Kuiper"}]'::JSONB,
    '[{"nome_tripulante": "Horizons AI", "data_de_nascimento": "2006-01-19", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Sistema Autônomo", "data_ingresso": "2006-01-19", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Cassini', 
    'Sonda', 
    'NASA/ESA/ASI', 
    1997, 
    'Finalizada',
    '[{"nome_missao": "Cassini - Saturno Finalizada", "data_lancamento": "1997-10-15", "destino": "Saturno", "duracao_dias": 4832, "resultado": "Finalizada", "descricao": "Missão de exploração de Saturno e suas luas"}]'::JSONB,
    '[{"nome_tripulante": "Cassini Bot", "data_de_nascimento": "1997-10-15", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Robô Cientista", "data_ingresso": "1997-10-15", "status": "Finalizado"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Juno', 
    'Sonda', 
    'NASA', 
    2011, 
    'Ativa',
    '[{"nome_missao": "Juno - Júpiter", "data_lancamento": "2011-08-05", "destino": "Júpiter", "duracao_dias": 4000, "resultado": "Sucesso", "descricao": "Estudo da atmosfera e campo gravitacional de Júpiter"}]'::JSONB,
    '[{"nome_tripulante": "Juno AI", "data_de_nascimento": "2011-08-05", "genero": "Outro", "nacionalidade": "Ficcional", "competencia": "Sistema Autônomo", "data_ingresso": "2011-08-05", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Millennium Falcon', 
    'Carga/Tripulada', 
    'Corellian Engineering Corporation', 
    1977, 
    'Ficcional',
    '[{"nome_missao": "Kessel Run", "data_lancamento": "1977-05-25", "destino": "Kessel", "duracao_dias": 1, "resultado": "Sucesso", "descricao": "Millennium Falcon completa o Kessel Run em menos de 12 parsecs (Star Wars)"}]'::JSONB,
    '[{"nome_tripulante": "Han Solo", "data_de_nascimento": "1929-07-29", "genero": "Masculino", "nacionalidade": "Corelliano", "competencia": "Capitão", "data_ingresso": "1977-05-25", "status": "Ativo"}, {"nome_tripulante": "Chewbacca", "data_de_nascimento": "1180-01-01", "genero": "Masculino", "nacionalidade": "Wookiee", "competencia": "Co-piloto", "data_ingresso": "1977-05-25", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Enterprise NCC-1701', 
    'Exploração', 
    'Starfleet', 
    2265, 
    'Ficcional',
    NULL,
    '[{"nome_tripulante": "James T. Kirk", "data_de_nascimento": "2233-03-22", "genero": "Masculino", "nacionalidade": "Terráqueo", "competencia": "Capitão", "data_ingresso": "2265-09-08", "status": "Ativo"}, {"nome_tripulante": "Spock", "data_de_nascimento": "2230-01-06", "genero": "Masculino", "nacionalidade": "Vulcano", "competencia": "Oficial de Ciências", "data_ingresso": "2265-09-08", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'X-Wing', 
    'Caça', 
    'Incom Corporation', 
    1977, 
    'Ficcional',
    NULL,
    '[{"nome_tripulante": "Luke Skywalker", "data_de_nascimento": "1919-05-25", "genero": "Masculino", "nacionalidade": "Tatooiniano", "competencia": "Piloto", "data_ingresso": "1977-05-25", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Nave dos Guardiões', 
    'Transporte', 
    'Guardiões da Galáxia', 
    2014, 
    'Ficcional',
    NULL,
    '[{"nome_tripulante": "Peter Quill", "data_de_nascimento": "1980-02-04", "genero": "Masculino", "nacionalidade": "Terráqueo", "competencia": "Líder", "data_ingresso": "2014-08-01", "status": "Ativo"}, {"nome_tripulante": "Gamora", "data_de_nascimento": "1985-03-15", "genero": "Feminino", "nacionalidade": "Zen-Whoberiana", "competencia": "Combatente", "data_ingresso": "2014-08-01", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Batmóvel Espacial', 
    'Veículo', 
    'Wayne Enterprises', 
    2022, 
    'Ficcional',
    NULL,
    '[{"nome_tripulante": "Bruce Wayne", "data_de_nascimento": "1972-02-19", "genero": "Masculino", "nacionalidade": "Americana", "competencia": "Batman", "data_ingresso": "2022-03-04", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Nave dos Superamigos', 
    'Transporte', 
    'Superamigos', 
    1973, 
    'Ficcional',
    NULL,
    '[{"nome_tripulante": "Superman", "data_de_nascimento": "1938-06-01", "genero": "Masculino", "nacionalidade": "Kryptoniano", "competencia": "Líder", "data_ingresso": "1973-09-08", "status": "Ativo"}, {"nome_tripulante": "Mulher-Maravilha", "data_de_nascimento": "1941-10-21", "genero": "Feminino", "nacionalidade": "Amazona", "competencia": "Combatente", "data_ingresso": "1973-09-08", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Planet Express', 
    'Entrega', 
    'Planet Express', 
    2999, 
    'Ficcional',
    NULL,
    '[{"nome_tripulante": "Philip J. Fry", "data_de_nascimento": "1974-08-14", "genero": "Masculino", "nacionalidade": "Americana", "competencia": "Entregador", "data_ingresso": "2999-03-28", "status": "Ativo"}, {"nome_tripulante": "Turanga Leela", "data_de_nascimento": "2975-07-29", "genero": "Feminino", "nacionalidade": "Mutante", "competencia": "Capitã", "data_ingresso": "2999-03-28", "status": "Ativo"}]'::JSONB
);

SELECT create_nave_with_dependencies(
    'Nave dos Jetsons', 
    'Familiar', 
    'Spacely Sprockets', 
    2062, 
    'Ficcional',
    NULL,
    '[{"nome_tripulante": "George Jetson", "data_de_nascimento": "2022-07-31", "genero": "Masculino", "nacionalidade": "Americana", "competencia": "Pai de Família", "data_ingresso": "2062-09-23", "status": "Ativo"}, {"nome_tripulante": "Jane Jetson", "data_de_nascimento": "2024-04-01", "genero": "Feminino", "nacionalidade": "Americana", "competencia": "Mãe de Família", "data_ingresso": "2062-09-23", "status": "Ativo"}]'::JSONB
);

-- Note: The placeholder logic previously in the consolidated script is now handled by the
-- create_nave_with_dependencies function's internal validation, which requires
-- that either missions or tripulantes (or both) are non-empty.
-- Naves that originally had no missions or tripulantes listed in the separate DML files
-- will now correctly have NULL passed for those parameters to the function.
-- If the function requires at least one, those specific calls would fail if not for
-- the fact that my original DML files *did* provide at least one dependency for *every* ship,
-- even if it was a "fictional" crew member for an unmanned probe, or the placeholder mission.
-- The Python script generating this output ensures that if a nave ended up with *no* dependencies
-- from the original files, it would still generate a call. However, the function create_nave_with_dependencies
-- itself will raise an error if both JSONB params are effectively empty or NULL.
-- The current generated output correctly reflects the *actual* dependencies from the original seed files.
-- For example, 'Enterprise NCC-1701' only had tripulantes, so its missoes parameter is NULL.

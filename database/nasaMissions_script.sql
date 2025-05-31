-- Criação do Banco
CREATE DATABASE NASA_Missions;
GO

USE NASA_Missions;
GO

-- Tabela Naves
CREATE TABLE Naves (
    id_nave INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    fabricante VARCHAR(100) NOT NULL,
    ano_construcao INT NOT NULL,
    status VARCHAR(30) NOT NULL
);
GO

-- Tabela Missoes
CREATE TABLE Missoes (
    id_missao INT PRIMARY KEY IDENTITY(1,1),
    id_nave INT FOREIGN KEY REFERENCES Naves(id_nave) ON DELETE CASCADE,
    nome_missao VARCHAR(100) NOT NULL,
    data_lancamento DATE NOT NULL,
    destino VARCHAR(100) NOT NULL,
    duracao_dias INT NOT NULL,
    resultado VARCHAR(50) NOT NULL,
    descricao VARCHAR(255)
);
GO

-- Inserindo Naves
INSERT INTO Naves (nome, tipo, fabricante, ano_construcao, status) VALUES
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
-- Referências a filmes, desenhos e HQs
('Millennium Falcon', 'Carga/Tripulada', 'Corellian Engineering Corporation', 1977, 'Ficcional'),
('Enterprise NCC-1701', 'Exploração', 'Starfleet', 2265, 'Ficcional'),
('X-Wing', 'Caça', 'Incom Corporation', 1977, 'Ficcional'),
('Nave dos Guardiões', 'Transporte', 'Guardiões da Galáxia', 2014, 'Ficcional'),
('Batmóvel Espacial', 'Veículo', 'Wayne Enterprises', 2022, 'Ficcional'),
('Nave dos Superamigos', 'Transporte', 'Superamigos', 1973, 'Ficcional'),
('Planet Express', 'Entrega', 'Planet Express', 2999, 'Ficcional'),
('Nave dos Jetsons', 'Familiar', 'Spacely Sprockets', 2062, 'Ficcional');
GO

-- Inserindo Missões
INSERT INTO Missoes (id_nave, nome_missao, data_lancamento, destino, duracao_dias, resultado, descricao) VALUES
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
-- Missões fictícias
(20, 'Kessel Run', '1977-05-25', 'Kessel', 1, 'Sucesso', 'Millennium Falcon completa o Kessel Run em menos de 12 parsecs (Star Wars)'),
(21, 'Missão 5 Anos', '2265-09-08', 'Galáxia', 1825, 'Sucesso', 'Exploração do espaço profundo pela Enterprise (Star Trek)'),
(22, 'Ataque à Estrela da Morte', '1977-05-25', 'Estrela da Morte', 1, 'Sucesso', 'X-Wing lidera ataque rebelde (Star Wars)'),
(23, 'Salvar Xandar', '2014-08-01', 'Xandar', 2, 'Sucesso', 'Guardiões da Galáxia salvam o planeta Xandar (Marvel HQ/filme)'),
(24, 'Missão Gotham-Espaço', '2022-03-04', 'Órbita da Terra', 1, 'Sucesso', 'Batmóvel Espacial impede plano do Coringa (HQ/filme)'),
(25, 'Liga da Justiça no Espaço', '1973-09-08', 'Espaço', 1, 'Sucesso', 'Superamigos enfrentam vilões no espaço (desenho animado)'),
(26, 'Entrega para Omicron Persei 8', '2999-03-28', 'Omicron Persei 8', 3, 'Sucesso', 'Planet Express faz entrega interplanetária (Futurama)'),
(27, 'Viagem ao Shopping Espacial', '2062-09-23', 'Shopping Espacial', 1, 'Sucesso', 'Jetsons visitam o shopping no espaço (desenho animado)');
GO

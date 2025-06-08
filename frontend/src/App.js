import { useEffect, useState } from 'react';
import axios from 'axios';
import './App.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import Header from './components/header.js';
import NaveControl from './components/naveControl.js';
import MissoesControl from './components/missoesControl.js';
import TripulantesControl from './components/tripulantesControl.js';

function App() {
  const [naves, setNaves] = useState([]);
  const [missoes, setMissoes] = useState([]);
  const [naveSelecionada, setNaveSelecionada] = useState(null);
  const [tripulantes, setTripulantes] = useState([]);
  const [apiError, setApiError] = useState(null);
  const [stagedMissions, setStagedMissions] = useState([]);
  const [stagedTripulantes, setStagedTripulantes] = useState([]);
  const [addNaveValidationMessage, setAddNaveValidationMessage] = useState('');

  const [novoTripulante, setNovoTripulante] = useState({
    nome_tripulante: '',
    data_de_nascimento: '',
    genero: '',
    nacionalidade: '',
    competencia: '',
    data_ingresso: '',
    status: ''
  });
  const [novaNave, setNovaNave] = useState({
    nome: '',
    tipo: '',
    fabricante: '',
    ano: '',
    status: ''
  });

  const [novaMissao, setNovaMissao] = useState({
    nome: '',
    data: '',
    destino: '',
    duracao: '',
    resultado: '',
    descricao: ''
  });

  // Carregar naves
  const carregarNaves = () => {
    setApiError(null);
    axios.get('http://localhost:5000/naves')
      .then(res => setNaves(res.data))
      .catch(error => {
        console.error("API Error:", error.response || error.message);
        const message = error.response?.data?.error || error.response?.data?.message || "Erro ao carregar naves.";
        setApiError(message);
      });
  };

  useEffect(() => {
    carregarNaves();
  }, []);

  // 🔥 Carregar tripulantes da nave selecionada
  const carregarTripulantes = (idNave) => {
    setApiError(null);
    axios.get(`http://localhost:5000/tripulantes/${idNave}`)
      .then(res => setTripulantes(res.data))
      .catch(error => {
        console.error("API Error:", error.response || error.message);
        const message = error.response?.data?.error || error.response?.data?.message || "Erro ao carregar tripulantes.";
        setApiError(message);
      });
  };

  // 🔥 Ao selecionar uma nave, também carrega os tripulantes dela
  const selecionarNave = (nave) => {
    setApiError(null);
    setNaveSelecionada(nave);
    axios.get(`http://localhost:5000/missoes/${nave.id_nave}`)
      .then(res => setMissoes(res.data))
      .catch(error => {
        console.error("API Error fetching missoes:", error.response || error.message);
        const message = error.response?.data?.error || error.response?.data?.message || "Erro ao carregar missões da nave.";
        setApiError(message);
      });
    carregarTripulantes(nave.id_nave); // This already has its own error handling
  };

  // Adicionar nave
  const adicionarNave = (e) => {
    e.preventDefault();
    setApiError(null); // Clear previous API errors
    setAddNaveValidationMessage(''); // Clear previous validation messages

    if (stagedMissions.length === 0 && stagedTripulantes.length === 0) {
      setAddNaveValidationMessage("A nave deve ser criada com pelo menos uma missão OU um tripulante.");
      return;
    }

    const payloadMissions = stagedMissions.map(mission => {
      const { tempId, nome, data, duracao, ...rest } = mission; // Exclude tempId, take specific fields for mapping
      return {
        ...rest,
        nome_missao: nome,
        data_lancamento: data,
        duracao_dias: duracao
      };
    });

    const payloadTripulantes = stagedTripulantes.map(tripulante => {
      const { tempId, ...rest } = tripulante; // Exclude tempId
      return rest;
    });

    const naveDetails = {
      ...novaNave,
      ano_construcao: novaNave.ano
    };
    delete naveDetails.ano;

    const payload = {
      ...naveDetails,
      missoes: payloadMissions,
      tripulantes: payloadTripulantes
    };

    axios.post('http://localhost:5000/naves', payload)
      .then(() => {
        carregarNaves();
        setNovaNave({ nome: '', tipo: '', fabricante: '', ano: '', status: '' });
        resetStagedNaveDependencies(); // Clears stagedMissions, stagedTripulantes, and addNaveValidationMessage
        // setApiError(null); // Already done at the beginning and by resetStagedNaveDependencies if it were to set it
      })
      .catch(error => {
        console.error("API Error adding nave with dependencies:", error.response || error.message);
        const message = error.response?.data?.error || error.response?.data?.message || "Erro ao adicionar nave com dependências.";
        setApiError(message);
      });
  };

  // Staging handlers
  const handleStageMission = (missionData) => {
    setStagedMissions(prev => [...prev, { ...missionData, tempId: Date.now() }]);
  };

  const handleRemoveStagedMission = (tempMissionId) => {
    setStagedMissions(prev => prev.filter(m => m.tempId !== tempMissionId));
  };

  const handleStageTripulante = (tripulanteData) => {
    setStagedTripulantes(prev => [...prev, { ...tripulanteData, tempId: Date.now() }]);
  };

  const handleRemoveStagedTripulante = (tempTripulanteId) => {
    setStagedTripulantes(prev => prev.filter(t => t.tempId !== tempTripulanteId));
  };

  const resetStagedNaveDependencies = () => {
    setStagedMissions([]);
    setStagedTripulantes([]);
    setAddNaveValidationMessage('');
    // Optionally reset novaNave state if the form is fully controlled here
    // setNovaNave({ nome: '', tipo: '', fabricante: '', ano: '', status: '' });
  };

  // Remover nave
  const removerNave = (id) => {
    setApiError(null);
    axios.delete(`http://localhost:5000/naves/${id}`)
      .then(() => {
        carregarNaves();
        if (naveSelecionada && naveSelecionada.id_nave === id) {
          setNaveSelecionada(null);
          setMissoes([]);
        }
      })
      .catch(error => {
        console.error("API Error:", error.response || error.message);
        const message = error.response?.data?.error || error.response?.data?.message || "Erro ao remover nave.";
        setApiError(message);
      });
  };

  // 🔥 Adicionar tripulante
  const adicionarTripulante = (e) => {
    e.preventDefault();
    if (!naveSelecionada) {
      alert("Selecione uma nave antes de adicionar um tripulante.");
      return;
    }
    setApiError(null);
    axios.post(`http://localhost:5000/tripulantes/${naveSelecionada.id_nave}`, novoTripulante)
      .then(() => {
        carregarTripulantes(naveSelecionada.id_nave);
        setNovoTripulante({
          nome_tripulante: '',
          data_de_nascimento: '',
          genero: '',
          nacionalidade: '',
          competencia: '',
          data_ingresso: '',
          status: ''
        });
      });
  };

  // 🔥 Remover tripulante
  const removerTripulante = (id_tripulante) => {
    if (!naveSelecionada) {
      alert("Nenhuma nave selecionada.");
      return;
    }
    setApiError(null);
    axios.delete(`http://localhost:5000/tripulantes/${naveSelecionada.id_nave}/${id_tripulante}`)
      .then(() => {
        if (naveSelecionada) {
          carregarTripulantes(naveSelecionada.id_nave);
        }
      })
      .catch(error => {
        console.error("API Error:", error.response || error.message);
        const message = error.response?.data?.error || error.response?.data?.message || "Erro ao remover tripulante.";
        setApiError(message);
      });
  };

  // Adicionar missão
  const adicionarMissao = (e) => {
    e.preventDefault();
    if (!naveSelecionada) {
      alert("Selecione uma nave antes de adicionar uma missão.");
      return;
    }
    const payload = {
      ...novaMissao,
      nome_missao: novaMissao.nome,
      data_lancamento: novaMissao.data,
      duracao_dias: novaMissao.duracao
    };
    delete payload.nome;
    delete payload.data;
    delete payload.duracao;
    setApiError(null);
    axios.post(`http://localhost:5000/missoes/${naveSelecionada.id_nave}`, payload)
      .then(() => {
        selecionarNave(naveSelecionada); // This will also clear apiError
        setNovaMissao({
          nome: '',
          data: '',
          destino: '',
          duracao: '',
          resultado: '',
          descricao: ''
        });
      });
  };

  // Remover missão
  const removerMissao = (id_missao) => {
    if (!naveSelecionada) {
      alert("Nenhuma nave selecionada.");
      return;
    }
    setApiError(null);
    axios.delete(`http://localhost:5000/missoes/${naveSelecionada.id_nave}/${id_missao}`)
      .then(() => selecionarNave(naveSelecionada)) // This will also clear apiError
      .catch(error => {
        console.error("API Error:", error.response || error.message);
        const message = error.response?.data?.error || error.response?.data?.message || "Erro ao remover missão.";
        setApiError(message);
      });
  };
  return (
    <div className="container my-5 bg-light p-4 rounded shadow text-dark" style={{ minHeight: '80vh' }}>
      <Header />
      {apiError && (
        <div className="alert alert-danger alert-dismissible fade show" role="alert">
          <strong>Error:</strong> {apiError}
          <button type="button" className="btn-close" onClick={() => setApiError(null)} aria-label="Close"></button>
        </div>
      )}
      <div className="row">
        <div className="col-12 col-md-5">
          <div className="naves">
            <NaveControl
              naves={naves}
              novaNave={novaNave}
              setNovaNave={setNovaNave}
              adicionarNave={adicionarNave}
              removerNave={removerNave}
              selecionarNave={selecionarNave}
              // Staging props
              stagedMissions={stagedMissions}
              onStageMission={handleStageMission}
              onRemoveStagedMission={handleRemoveStagedMission}
              stagedTripulantes={stagedTripulantes}
              onStageTripulante={handleStageTripulante}
              onRemoveStagedTripulante={handleRemoveStagedTripulante}
              validationMessage={addNaveValidationMessage}
              resetStagedNaveDependencies={resetStagedNaveDependencies}
            />
          </div>
        </div>
        <div className="col-md-4">
          <div className="missoes col12 col-md-12">
            <MissoesControl
              naveSelecionada={naveSelecionada}
              missoes={missoes}
              novaMissao={novaMissao}
              setNovaMissao={setNovaMissao}
              adicionarMissao={adicionarMissao}
              removerMissao={removerMissao}
            />
          </div>
        </div>
        <div className="col-md-3">
          <div className="tripulantes">
            <TripulantesControl
              naveSelecionada={naveSelecionada}
              tripulantes={tripulantes}
              novoTripulante={novoTripulante}
              setNovoTripulante={setNovoTripulante}
              adicionarTripulante={adicionarTripulante}
              removerTripulante={removerTripulante}
            />
          </div>
        </div>

      </div>
    </div>
  );

}

export default App;

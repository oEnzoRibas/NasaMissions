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
    axios.get('http://localhost:5000/naves')
      .then(res => setNaves(res.data));
  };

  useEffect(() => {
    carregarNaves();
  }, []);

  // 🔥 Carregar tripulantes da nave selecionada
  const carregarTripulantes = (idNave) => {
    axios.get(`http://localhost:5000/tripulantes/${idNave}`)
      .then(res => setTripulantes(res.data));
  };

  // 🔥 Ao selecionar uma nave, também carrega os tripulantes dela
  const selecionarNave = (nave) => {
    setNaveSelecionada(nave);
    axios.get(`http://localhost:5000/missoes/${nave.id}`)
      .then(res => setMissoes(res.data));
    carregarTripulantes(nave.id);
  };

  // Adicionar nave
  const adicionarNave = (e) => {
    e.preventDefault();
    axios.post('http://localhost:5000/naves', novaNave)
      .then(() => {
        carregarNaves();
        setNovaNave({ nome: '', tipo: '', fabricante: '', ano: '', status: '' });
      });
  };

  // Remover nave
  const removerNave = (id) => {
    axios.delete(`http://localhost:5000/naves/${id}`)
      .then(() => {
        carregarNaves();
        if (naveSelecionada && naveSelecionada.id === id) {
          setNaveSelecionada(null);
          setMissoes([]);
        }
      });
  };

  // 🔥 Adicionar tripulante
  const adicionarTripulante = (e) => {
    e.preventDefault();
    if (!naveSelecionada) {
      alert("Selecione uma nave antes de adicionar um tripulante.");
      return;
    }
    axios.post(`http://localhost:5000/tripulantes/${naveSelecionada.id}`, novoTripulante)
      .then(() => {
        carregarTripulantes(naveSelecionada.id);
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
  const removerTripulante = (id) => {
    axios.delete(`http://localhost:5000/tripulantes/${id}`)
      .then(() => {
        if (naveSelecionada) {
          carregarTripulantes(naveSelecionada.id);
        }
      })
      .catch(error => {
        console.error("Erro ao remover tripulante:", error);
        console.error("Erro ao remover tripulante:", error.response);
        alert("Erro ao remover tripulante.");
      });
  };

  // Adicionar missão
  const adicionarMissao = (e) => {
    e.preventDefault();
    if (!naveSelecionada) {
      alert("Selecione uma nave antes de adicionar uma missão.");
      return;
    }
    axios.post(`http://localhost:5000/missoes/${naveSelecionada.id}`, novaMissao)
      .then(() => {
        selecionarNave(naveSelecionada);
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
  const removerMissao = (id) => {
    axios.delete(`http://localhost:5000/missoes/${id}`)
      .then(() => selecionarNave(naveSelecionada));
  };

  return (
    <div className="container my-5 bg-light p-4 rounded shadow text-dark " style={{ minHeight: '80vh' }}>
      <Header />
      <div className="row">
        <NaveControl
          naves={naves}
          novaNave={novaNave}
          setNovaNave={setNovaNave}
          adicionarNave={adicionarNave}
          removerNave={removerNave}
          selecionarNave={selecionarNave}
        />
        <MissoesControl
          naveSelecionada={naveSelecionada}
          missoes={missoes}
          novaMissao={novaMissao}
          setNovaMissao={setNovaMissao}
          adicionarMissao={adicionarMissao}
          removerMissao={removerMissao}
        />
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
  );
}


export default App;

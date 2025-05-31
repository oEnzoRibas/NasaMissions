import { useEffect, useState } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [naves, setNaves] = useState([]);
  const [missoes, setMissoes] = useState([]);
  const [naveSelecionada, setNaveSelecionada] = useState(null);

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

  // Seleciona uma nave e carrega suas missões
  const selecionarNave = (nave) => {
    setNaveSelecionada(nave);
    axios.get(`http://localhost:5000/missoes/${nave.id}`)
      .then(res => setMissoes(res.data));
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
    <div className="App">
      <h1>🚀 NASA Mission Control</h1>
      <div className="container">

        {/* ===== Naves ===== */}
        <div className="naves">
          <h2>Naves</h2>
          <ul>
            {naves.map(n => (
              <li key={n.id}>
                <span onClick={() => selecionarNave(n)}>🚀 {n.nome} ({n.status})</span>
                <button onClick={() => removerNave(n.id)}>❌</button>
              </li>
            ))}
          </ul>

          {/* Formulário para adicionar nave */}
          <h3>Adicionar Nave</h3>
          <form onSubmit={adicionarNave}>
            <input placeholder="Nome" value={novaNave.nome} onChange={e => setNovaNave({ ...novaNave, nome: e.target.value })} required />
            <input placeholder="Tipo" value={novaNave.tipo} onChange={e => setNovaNave({ ...novaNave, tipo: e.target.value })} required />
            <input placeholder="Fabricante" value={novaNave.fabricante} onChange={e => setNovaNave({ ...novaNave, fabricante: e.target.value })} required />
            <input type="number" placeholder="Ano" value={novaNave.ano} onChange={e => setNovaNave({ ...novaNave, ano: e.target.value })} required />
            <input placeholder="Status" value={novaNave.status} onChange={e => setNovaNave({ ...novaNave, status: e.target.value })} required />
            <button type="submit">➕ Adicionar</button>
          </form>
        </div>

        {/* ===== Missões ===== */}
        <div className="missoes">
          <h2>Missões {naveSelecionada ? `- ${naveSelecionada.nome}` : ''}</h2>
          {naveSelecionada ? (
            <>
              <ul>
                {missoes.map(m => (
                  <li key={m.id}>
                    <span>🌌 {m.nome} ➝ {m.destino} ({m.resultado})</span>
                    <button onClick={() => removerMissao(m.id)}>❌</button>
                  </li>
                ))}
              </ul>

              {/* Formulário para adicionar missão */}
              <h3>Adicionar Missão</h3>
              <form onSubmit={adicionarMissao}>
                <input placeholder="Nome" value={novaMissao.nome} onChange={e => setNovaMissao({ ...novaMissao, nome: e.target.value })} required />
                <input type="date" placeholder="Data" value={novaMissao.data} onChange={e => setNovaMissao({ ...novaMissao, data: e.target.value })} />
                <input placeholder="Destino" value={novaMissao.destino} onChange={e => setNovaMissao({ ...novaMissao, destino: e.target.value })} />
                <input type="number" placeholder="Duração (dias)" value={novaMissao.duracao} onChange={e => setNovaMissao({ ...novaMissao, duracao: e.target.value })} />
                <input placeholder="Resultado" value={novaMissao.resultado} onChange={e => setNovaMissao({ ...novaMissao, resultado: e.target.value })} />
                <input placeholder="Descrição" value={novaMissao.descricao} onChange={e => setNovaMissao({ ...novaMissao, descricao: e.target.value })} />
                <button type="submit">➕ Adicionar</button>
              </form>
            </>
          ) : (
            <p>Selecione uma nave para ver e adicionar suas missões.</p>
          )}
        </div>

      </div>
    </div>
  );
}

export default App;

import { useEffect, useState } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [naves, setNaves] = useState([]);
  const [missoes, setMissoes] = useState([]);
  const [naveSelecionada, setNaveSelecionada] = useState(null);

  useEffect(() => {
    axios.get('http://localhost:5000/naves')
      .then(res => setNaves(res.data));
  }, []);

  const selecionarNave = (nave) => {
    setNaveSelecionada(nave);
    axios.get(`http://localhost:5000/missoes/${nave.id}`)
      .then(res => setMissoes(res.data));
  };

  return (
    <div className="App">
      <h1>NASA Mission Control</h1>
      <div className="container">
        <div className="naves">
          <h2>Naves</h2>
          <ul>
            {naves.map(n => (
              <li key={n.id} onClick={() => selecionarNave(n)}>
                🚀 {n.nome} ({n.status})
              </li>
            ))}
          </ul>
        </div>
        <div className="missoes">
          <h2>Missões {naveSelecionada ? `- ${naveSelecionada.nome}` : ''}</h2>
          {naveSelecionada ? (
            <ul>
              {missoes.map(m => (
                <li key={m.id}>
                  🌌 {m.nome} ➝ {m.destino} ({m.resultado})
                </li>
              ))}
            </ul>
          ) : (
            <p>Selecione uma nave para ver suas missões.</p>
          )}
        </div>
      </div>
    </div>
  );
}

export default App;

import React from 'react';
import { useState } from 'react';

function TripulantesControl({
  naveSelecionada,
  tripulantes,
  novoTripulante,
  setNovoTripulante,
  adicionarTripulante,
  removerTripulante
}) {
  const [mostrarFormulario, setMostrarFormulario] = useState(false);
  return (
    <div className="card bg-dark text-white h-100">
      <div className="card-body">
        <h2 className="card-title">
          Tripulantes {naveSelecionada ? `- ${naveSelecionada.nome}` : ''}
        </h2>

        {naveSelecionada ? (
          <>
            <ul className="list-group list-group-flush">
              {tripulantes.map(t => (
                <li key={t.id_tripulante} className="list-group-item d-flex justify-content-between align-items-center">
                  <span className="text-dark">🧑‍🚀 {t.nome_tripulante} - ({t.competencia}) - Status: {t.status}</span>
                  <button className="btn btn-danger btn-sm" onClick={() => removerTripulante(t.id_tripulante)}>❌</button>
                </li>
              ))}
            </ul>

            {!mostrarFormulario && (
                    <button
                      className="btn btn-primary w-100 mt-4"
                      onClick={() => setMostrarFormulario(true)}
                    >
                      ➕ Adicionar Tripulante
                    </button>
                  )}

                   {mostrarFormulario && (
                    <>

            <h4 className="mt-4">Adicionar Tripulante</h4>
            <form onSubmit={adicionarTripulante}>
              <label className="form-label">Nome</label>
              <input className="form-control my-1" placeholder="Nome do Tripulante" value={novoTripulante.nome_tripulante} onChange={e => setNovoTripulante({ ...novoTripulante, nome_tripulante: e.target.value })} required />
              <label className="form-label">Data de Nascimento</label>
              <input className="form-control my-1" placeholder="Data de Nascimento" type="date" value={novoTripulante.data_de_nascimento} onChange={e => setNovoTripulante({ ...novoTripulante, data_de_nascimento: e.target.value })} required />
              <input className="form-control my-1" placeholder="Gênero" value={novoTripulante.genero} onChange={e => setNovoTripulante({ ...novoTripulante, genero: e.target.value })} required />
              <input className="form-control my-1" placeholder="Nacionalidade" value={novoTripulante.nacionalidade} onChange={e => setNovoTripulante({ ...novoTripulante, nacionalidade: e.target.value })} required />
              <input className="form-control my-1" placeholder="Competência" value={novoTripulante.competencia} onChange={e => setNovoTripulante({ ...novoTripulante, competencia: e.target.value })} required />
              <input className="form-control my-1" placeholder="Data de Ingresso" type="date" value={novoTripulante.data_ingresso} onChange={e => setNovoTripulante({ ...novoTripulante, data_ingresso: e.target.value })} required />
              <input className="form-control my-1" placeholder="Status" value={novoTripulante.status} onChange={e => setNovoTripulante({ ...novoTripulante, status: e.target.value })} required />
              <button type="submit" className="btn btn-primary w-100 mt-2">➕ Adicionar</button>
              <div className="d-flex gap-2 mt-2">
                          <button type="button" className="btn btn-secondary w-100" onClick={() => setMostrarFormulario(false)}>Cancelar</button>
                        </div>

            </form>
            </>
                  )}
          </>
          
        ) : (
          <p>Selecione uma nave para ver e adicionar seus tripulantes.</p>
        )}
      </div>
    </div>
  );
}

export default TripulantesControl;

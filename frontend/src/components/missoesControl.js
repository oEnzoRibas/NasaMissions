import { use, useEffect, useState } from 'react';

function MissoesControl({ naveSelecionada, missoes, novaMissao, setNovaMissao, adicionarMissao, removerMissao }) {
  const [mostrarFormulario, setMostrarFormulario] = useState(false);

  return (
    <div className="col-sm-9">
      <div className="row">
        <div className="col-12">
          <div className="card bg-dark text-white h-100">
            <div className="card-body">
              <h2 className="card-title">
                Missões {naveSelecionada ? `- ${naveSelecionada.nome}` : ''}
              </h2>

              {naveSelecionada ? (
                <>
                  <ul className="list-group list-group-flush">
                    {missoes.map(m => (
                      <li key={m.id_missao} className="list-group-item d-flex justify-content-between align-items-center">
                        <span className="text-dark">
                          🌌 {m.nome} ➝ {m.destino} ({m.resultado})
                        </span>
                        <button className="btn btn-danger btn-sm" onClick={() => removerMissao(m.id_missao)}>❌</button>
                      </li>
                    ))}
                  </ul>

                  {!mostrarFormulario && (
                    <button
                      className="btn btn-primary w-100 mt-4"
                      onClick={() => setMostrarFormulario(true)}
                    >
                      ➕ Adicionar Missão

                    </button>
                  )}

                  {mostrarFormulario && (
                    <>
                      <h4 className="mt-4">Adicionar Missão</h4>
                      <form onSubmit={adicionarMissao}>
                        <div className="row">
                          <div className="col-6"><input className="form-control my-1" placeholder="Nome" value={novaMissao.nome} onChange={e => setNovaMissao({ ...novaMissao, nome: e.target.value })} required /></div>
                          <div className="col-6"><input type="date" className="form-control my-1" value={novaMissao.data} onChange={e => setNovaMissao({ ...novaMissao, data: e.target.value })} /></div>
                          <div className="col-6"><input className="form-control my-1" placeholder="Destino" value={novaMissao.destino} onChange={e => setNovaMissao({ ...novaMissao, destino: e.target.value })} /></div>
                          <div className="col-6"><input type="number" className="form-control my-1" placeholder="Duração (dias)" value={novaMissao.duracao} onChange={e => setNovaMissao({ ...novaMissao, duracao: e.target.value })} /></div>
                          <div className="col-6"><input className="form-control my-1" placeholder="Resultado" value={novaMissao.resultado} onChange={e => setNovaMissao({ ...novaMissao, resultado: e.target.value })} /></div>
                          <div className="col-6"><input className="form-control my-1" placeholder="Descrição" value={novaMissao.descricao} onChange={e => setNovaMissao({ ...novaMissao, descricao: e.target.value })} /></div>
                          <div className="col-12"><button type="submit" className="btn btn-primary w-100 mt-2">➕ Adicionar</button></div>
                        </div>
                        <div className="d-flex gap-2 mt-2">
                          <button type="button" className="btn btn-secondary w-100" onClick={() => setMostrarFormulario(false)}>Cancelar</button>
                        </div>
                      </form>
                    </>
                  )}
                </>
              ) : (
                <div className="alert alert-info" role="alert">
                  Selecione uma nave para ver as missões.
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default MissoesControl;

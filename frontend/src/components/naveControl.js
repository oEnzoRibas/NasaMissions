import { useEffect, useState } from 'react';

function NaveControl({ naves, novaNave, setNovaNave, adicionarNave, removerNave, selecionarNave }) {
  const [mostrarFormulario, setMostrarFormulario] = useState(false);

  return (
    <div className="col-sm-12">

      <div className="card bg-dark text-white h-100">
        <div className="card-body">
          <h2 className="card-title">Naves</h2>
          <ul
            className="list-group list-group-flush"
            style={{ maxHeight: '300px', overflowY: 'auto' }}
          >
            {naves.map(n => (
              <li key={n.id} className="list-group-item d-flex justify-content-between align-items-center">
                <span className="text-dark" onClick={() => selecionarNave(n)} style={{ cursor: 'pointer' }}>
                  🚀 {n.nome} ({n.status})
                </span>
                <button className="btn btn-danger btn-sm" onClick={() => removerNave(n.id)}>❌</button>
              </li>
            ))}
          </ul>

          {!mostrarFormulario && (
            <button
              className="btn btn-primary w-100 mt-4"
              onClick={() => setMostrarFormulario(true)}
            >
              ➕ Adicionar Nave
            </button>
          )}

          {mostrarFormulario && (
            <>
              <h4 className="mt-4">Adicionar Nave</h4>
              <form onSubmit={adicionarNave}>
                <input className="form-control my-1" placeholder="Nome" value={novaNave.nome} onChange={e => setNovaNave({ ...novaNave, nome: e.target.value })} required />
                <input className="form-control my-1" placeholder="Tipo" value={novaNave.tipo} onChange={e => setNovaNave({ ...novaNave, tipo: e.target.value })} required />
                <input className="form-control my-1" placeholder="Fabricante" value={novaNave.fabricante} onChange={e => setNovaNave({ ...novaNave, fabricante: e.target.value })} required />
                <input type="number" className="form-control my-1" placeholder="Ano" value={novaNave.ano} onChange={e => setNovaNave({ ...novaNave, ano: e.target.value })} required />
                <input className="form-control my-1" placeholder="Status" value={novaNave.status} onChange={e => setNovaNave({ ...novaNave, status: e.target.value })} required />
                <div className="d-flex gap-2 mt-2">
                  <button type="submit" className="btn btn-primary w-100">Adicionar</button>
                  <button type="button" className="btn btn-secondary w-100" onClick={() => setMostrarFormulario(false)}>Cancelar</button>
                </div>
              </form>
            </>
          )}
        </div>
      </div>
    </div>
  );
}

export default NaveControl;

function TripulantesControl({
  naveSelecionada,
  tripulantes,
  novoTripulante,
  setNovoTripulante,
  adicionarTripulante,
  removerTripulante
}) {
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
                <li key={t.id} className="list-group-item d-flex justify-content-between align-items-center">
                  <span className="text-dark">🧑‍🚀 {t.nome_tripulante} - ({t.competencia}) - Status: {t.status}</span>
                  <button className="btn btn-danger btn-sm" onClick={() => removerTripulante(t.id)}>❌</button>
                </li>
              ))}
            </ul>

            <h4 className="mt-4">Adicionar Tripulante</h4>
            <form onSubmit={adicionarTripulante}>
              <input className="form-control my-1" placeholder="Nome" value={novoTripulante.nome} onChange={e => setNovoTripulante({ ...novoTripulante, nome: e.target.value })} required />
              <input className="form-control my-1" placeholder="Cargo" value={novoTripulante.cargo} onChange={e => setNovoTripulante({ ...novoTripulante, cargo: e.target.value })} required />
              <input className="form-control my-1" placeholder="Idade" type="number" value={novoTripulante.idade} onChange={e => setNovoTripulante({ ...novoTripulante, idade: e.target.value })} required />
              <button type="submit" className="btn btn-primary w-100 mt-2">➕ Adicionar</button>
            </form>
          </>
        ) : (
          <p>Selecione uma nave para ver e adicionar seus tripulantes.</p>
        )}
      </div>
    </div>
  );
}

export default TripulantesControl;

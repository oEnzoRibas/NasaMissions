import { useState } from 'react';

function NaveControl({
  naves,
  novaNave,
  setNovaNave,
  adicionarNave, // This will be the main submit function from App.js
  removerNave,
  selecionarNave,
  // Props for staged items - to be fully implemented in App.js later
  stagedMissions = [], // Default to empty array for now
  onStageMission = () => console.warn("onStageMission not implemented"),
  onRemoveStagedMission = () => console.warn("onRemoveStagedMission not implemented"),
  stagedTripulantes = [], // Default to empty array
  onStageTripulante = () => console.warn("onStageTripulante not implemented"),
  onRemoveStagedTripulante = () => console.warn("onRemoveStagedTripulante not implemented"),
  validationMessage = "", // Placeholder for validation message from App.js
  resetStagedNaveDependencies = () => console.warn("resetStagedNaveDependencies not implemented")
}) {
  const [mostrarFormularioNave, setMostrarFormularioNave] = useState(false);
  const [showMissionForm, setShowMissionForm] = useState(false);
  const [showTripulanteForm, setShowTripulanteForm] = useState(false);

  const initialMissionState = {
    nome: '', data: '', destino: '', duracao: '', resultado: '', descricao: ''
  };
  const [currentMission, setCurrentMission] = useState(initialMissionState);

  const initialTripulanteState = {
    nome_tripulante: '', data_de_nascimento: '', genero: '', nacionalidade: '',
    competencia: '', data_ingresso: '', status: ''
  };
  const [currentTripulante, setCurrentTripulante] = useState(initialTripulanteState);

  const handleStageMissionInternal = () => {
    onStageMission(currentMission); // Pass currentMission state to App.js handler
    setCurrentMission(initialMissionState); // Reset mission form
    setShowMissionForm(false); // Optionally hide form after staging
  };

  const handleStageTripulanteInternal = () => {
    onStageTripulante(currentTripulante); // Pass currentTripulante state to App.js handler
    setCurrentTripulante(initialTripulanteState); // Reset tripulante form
    setShowTripulanteForm(false); // Optionally hide form after staging
  };

  const handleInputChange = (e, setState, state) => {
    setState({ ...state, [e.target.name]: e.target.value });
  };

  return (
    <div className="col-sm-12">
      <div className="card bg-dark text-white h-100">
        <div className="card-body">
          <h2 className="card-title">Naves</h2>
          <ul
            className="list-group list-group-flush"
            style={{ maxHeight: '200px', overflowY: 'auto' }} // Reduced height a bit
          >
            {naves.map(n => (
              <li key={n.id_nave} className="list-group-item d-flex justify-content-between align-items-center">
                <span className="text-dark" onClick={() => selecionarNave(n)} style={{ cursor: 'pointer' }}>
                  🚀 {n.nome} ({n.status})
                </span>
                <button className="btn btn-danger btn-sm" onClick={() => removerNave(n.id_nave)}>❌</button>
              </li>
            ))}
          </ul>

          {!mostrarFormularioNave && (
            <button
              className="btn btn-success w-100 mt-3" // Changed color for distinction
              onClick={() => setMostrarFormularioNave(true)}
            >
              ➕ Adicionar Nova Nave Completa
            </button>
          )}

          {mostrarFormularioNave && (
            <>
              <h4 className="mt-3">Adicionar Nave Principal</h4>
              <form onSubmit={adicionarNave}> {/* Main form submission */}
                {/* Nave Details Form Fields */}
                <input className="form-control my-1" placeholder="Nome da Nave" value={novaNave.nome} onChange={e => setNovaNave({ ...novaNave, nome: e.target.value })} required />
                <input className="form-control my-1" placeholder="Tipo" value={novaNave.tipo} onChange={e => setNovaNave({ ...novaNave, tipo: e.target.value })} required />
                <input className="form-control my-1" placeholder="Fabricante" value={novaNave.fabricante} onChange={e => setNovaNave({ ...novaNave, fabricante: e.target.value })} required />
                <input type="number" className="form-control my-1" placeholder="Ano" value={novaNave.ano} onChange={e => setNovaNave({ ...novaNave, ano: e.target.value })} required />
                <input className="form-control my-1" placeholder="Status da Nave" value={novaNave.status} onChange={e => setNovaNave({ ...novaNave, status: e.target.value })} required />

                {/* --- Staged Missions Section --- */}
                <h5 className="mt-3 text-info">Missões Iniciais</h5>
                {stagedMissions.length > 0 && (
                  <ul className="list-group my-2">
                    {stagedMissions.map((mission) => (
                      <li key={mission.tempId} className="list-group-item list-group-item-dark d-flex justify-content-between align-items-center">
                        <small>{mission.nome_missao || mission.nome} - {mission.destino}</small>
                        <button type="button" className="btn btn-outline-danger btn-sm py-0" onClick={() => onRemoveStagedMission(mission.tempId)}>➖</button>
                      </li>
                    ))}
                  </ul>
                )}
                <button type="button" className="btn btn-info btn-sm w-100 mb-2" onClick={() => setShowMissionForm(!showMissionForm)}>
                  {showMissionForm ? 'Fechar Formulário de Missão' : '➕ Adicionar Missão Inicial'}
                </button>
                {showMissionForm && (
                  <div className="card card-body bg-secondary mb-3">
                    <input className="form-control my-1" name="nome" placeholder="Nome da Missão" value={currentMission.nome} onChange={e => handleInputChange(e, setCurrentMission, currentMission)} />
                    <input type="date" className="form-control my-1" name="data" placeholder="Data Lançamento" value={currentMission.data} onChange={e => handleInputChange(e, setCurrentMission, currentMission)} />
                    <input className="form-control my-1" name="destino" placeholder="Destino" value={currentMission.destino} onChange={e => handleInputChange(e, setCurrentMission, currentMission)} />
                    <input type="number" className="form-control my-1" name="duracao" placeholder="Duração (dias)" value={currentMission.duracao} onChange={e => handleInputChange(e, setCurrentMission, currentMission)} />
                    <input className="form-control my-1" name="resultado" placeholder="Resultado" value={currentMission.resultado} onChange={e => handleInputChange(e, setCurrentMission, currentMission)} />
                    <textarea className="form-control my-1" name="descricao" placeholder="Descrição da Missão" value={currentMission.descricao} onChange={e => handleInputChange(e, setCurrentMission, currentMission)} />
                    <button type="button" className="btn btn-light mt-2" onClick={handleStageMissionInternal}>Stage Missão</button>
                  </div>
                )}

                {/* --- Staged Tripulantes Section --- */}
                <h5 className="mt-3 text-warning">Tripulantes Iniciais</h5>
                {stagedTripulantes.length > 0 && (
                  <ul className="list-group my-2">
                    {stagedTripulantes.map((tripulante) => (
                      <li key={tripulante.tempId} className="list-group-item list-group-item-dark d-flex justify-content-between align-items-center">
                        <small>{tripulante.nome_tripulante} - {tripulante.competencia}</small>
                        <button type="button" className="btn btn-outline-danger btn-sm py-0" onClick={() => onRemoveStagedTripulante(tripulante.tempId)}>➖</button>
                      </li>
                    ))}
                  </ul>
                )}
                <button type="button" className="btn btn-warning btn-sm w-100 mb-2" onClick={() => setShowTripulanteForm(!showTripulanteForm)}>
                  {showTripulanteForm ? 'Fechar Formulário de Tripulante' : '➕ Adicionar Tripulante Inicial'}
                </button>
                {showTripulanteForm && (
                  <div className="card card-body bg-secondary mb-3">
                    <input className="form-control my-1" name="nome_tripulante" placeholder="Nome do Tripulante" value={currentTripulante.nome_tripulante} onChange={e => handleInputChange(e, setCurrentTripulante, currentTripulante)} />
                    <input type="date" className="form-control my-1" name="data_de_nascimento" placeholder="Data de Nascimento" value={currentTripulante.data_de_nascimento} onChange={e => handleInputChange(e, setCurrentTripulante, currentTripulante)} />
                    <input className="form-control my-1" name="genero" placeholder="Gênero" value={currentTripulante.genero} onChange={e => handleInputChange(e, setCurrentTripulante, currentTripulante)} />
                    <input className="form-control my-1" name="nacionalidade" placeholder="Nacionalidade" value={currentTripulante.nacionalidade} onChange={e => handleInputChange(e, setCurrentTripulante, currentTripulante)} />
                    <input className="form-control my-1" name="competencia" placeholder="Competência" value={currentTripulante.competencia} onChange={e => handleInputChange(e, setCurrentTripulante, currentTripulante)} />
                    <input type="date" className="form-control my-1" name="data_ingresso" placeholder="Data de Ingresso" value={currentTripulante.data_ingresso} onChange={e => handleInputChange(e, setCurrentTripulante, currentTripulante)} />
                    <input className="form-control my-1" name="status" placeholder="Status do Tripulante" value={currentTripulante.status} onChange={e => handleInputChange(e, setCurrentTripulante, currentTripulante)} />
                    <button type="button" className="btn btn-light mt-2" onClick={handleStageTripulanteInternal}>Stage Tripulante</button>
                  </div>
                )}

                {validationMessage && <div className="alert alert-warning mt-2">{validationMessage}</div>}

                <div className="d-flex gap-2 mt-3">
                  <button type="submit" className="btn btn-success w-100">✔️ Adicionar Nave e Dependências</button>
                  <button type="button" className="btn btn-secondary w-100" onClick={() => {
                    setMostrarFormularioNave(false);
                    setShowMissionForm(false);
                    setShowTripulanteForm(false);
                    setCurrentMission(initialMissionState);
                    setCurrentTripulante(initialTripulanteState);
                    resetStagedNaveDependencies(); // Call the reset function from App.js
                  }}>Cancelar Adição Completa</button>
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

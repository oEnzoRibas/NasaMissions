CREATE OR REPLACE FUNCTION delete_nave_completely(p_id_nave INTEGER)
RETURNS VOID AS $$
BEGIN
  -- Desativa os triggers da tabela temporariamente
  -- ATENÇÃO: Isso só funciona se você for superusuário ou estiver no mesmo owner
  PERFORM set_config('session_replication_role', 'replica', true);

  -- Apaga os tripulantes da nave
  DELETE FROM tripulantes
  WHERE id_nave = p_id_nave;

  -- Apaga as missões da nave
  DELETE FROM missoes
  WHERE id_nave = p_id_nave;

  -- Apaga a própria nave
  DELETE FROM naves
  WHERE id_nave = p_id_nave;

  -- Reativa os triggers
  PERFORM set_config('session_replication_role', 'origin', true);

  RAISE NOTICE 'Nave e dependências deletadas com sucesso.';
END;
$$ LANGUAGE plpgsql;

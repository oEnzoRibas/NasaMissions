-- SCENARIO I: Delete one of many missions (nave still has other missions or crew).
-- EXPECTED OUTCOME: SUCCEED.
-- Requires: `create_nave_with_dependencies` function.

DO $$
DECLARE
    v_id_nave_test INT;
    v_id_missao_to_delete INT;
BEGIN
    -- Setup: Create a nave with multiple missions
    SELECT create_nave_with_dependencies(
        'Nave I Test', 'Cruiser', 'TestFab', 2024, 'Active',
        '[{"nome_missao": "Mission I1", "data_lancamento": "2024-01-01", "destino": "Alpha", "duracao_dias": 5, "resultado": "Done", "descricao": "Patrol 1"},
          {"nome_missao": "Mission I2", "data_lancamento": "2024-02-01", "destino": "Beta", "duracao_dias": 6, "resultado": "Done", "descricao": "Patrol 2"}]'::JSONB,
        NULL 
    ) INTO v_id_nave_test;

    SELECT id_missao INTO v_id_missao_to_delete FROM missoes WHERE id_nave = v_id_nave_test AND nome_missao = 'Mission I1' LIMIT 1;

    -- Delete one mission
    DELETE FROM missoes WHERE id_missao = v_id_missao_to_delete;

    -- Output success message
    RAISE NOTICE 'SUCCESS: Scenario I operations completed within transaction.';

    -- Verification
    PERFORM ensure_nave_has_minimum_dependencies(v_id_nave_test);
END;
$$;

-- Verification: Show remaining missions for the nave
SELECT COUNT(*) AS mission_count 
FROM missoes 
WHERE id_nave IN (
    SELECT id_nave FROM naves WHERE nome = 'Nave I Test'
);


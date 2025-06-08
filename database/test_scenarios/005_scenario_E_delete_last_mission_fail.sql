-- SCENARIO E: Delete the last mission of a nave (that has no crew).
-- EXPECTED OUTCOME: FAIL at COMMIT with error P0002.
-- Requires: `create_nave_with_dependencies` function.

DO $$
DECLARE
    v_id_nave_test INT;
    v_id_missao_test INT;
BEGIN
    -- Setup: Create a nave with only one mission
    SELECT create_nave_with_dependencies(
        'Nave E Test', 'Probe', 'TestFab', 2024, 'Active',
        '[{"nome_missao": "Solo Mission E", "data_lancamento": "2024-01-01", "destino": "Mars", "duracao_dias": 10, "resultado": "In Progress", "descricao": "Test mission"}]'::JSONB,
        NULL -- No tripulantes
    ) INTO v_id_nave_test;

    SELECT id_missao INTO v_id_missao_test FROM missoes WHERE id_nave = v_id_nave_test LIMIT 1;
    RAISE NOTICE 'Nave E Test ID: %, Solo Mission E ID: %', v_id_nave_test, v_id_missao_test;

    -- Attempt to delete the last mission
    RAISE NOTICE 'Attempting to DELETE the only mission (ID %) for Nave ID %...', v_id_missao_test, v_id_nave_test;
    DELETE FROM missoes WHERE id_missao = v_id_missao_test;

    RAISE NOTICE 'Attempting to COMMIT transaction... (should fail here)';
    -- If your trigger or constraint raises P0002, it will be caught below.
EXCEPTION
    WHEN SQLSTATE 'P0002' THEN
        RAISE NOTICE 'SUCCESS: Expected error P0002 (Nave would be orphaned) caught.';
        RAISE NOTICE '%', SQLERRM;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Scenario E FAILED: Unexpected error: %', SQLERRM;
END;
$$;


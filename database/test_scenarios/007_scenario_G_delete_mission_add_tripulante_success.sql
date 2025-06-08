-- SCENARIO G: Delete the last mission, but add a tripulante in the same transaction.
-- EXPECTED OUTCOME: SUCCEED.
-- Requires: `create_nave_with_dependencies` function.

DO $$
DECLARE
    v_id_nave_test INT;
    v_id_missao_test INT;
	v_mission_count INT;
    v_tripulante_count INT;
BEGIN
    BEGIN
        -- Setup: Create a nave with only one mission
        SELECT create_nave_with_dependencies(
            'Nave G Test', 'Explorer', 'TestFab', 2024, 'Active',
            '[{"nome_missao": "Only Mission G", "data_lancamento": "2024-01-01", "destino": "Jupiter", "duracao_dias": 100, "resultado": "Planned", "descricao": "Test mission"}]'::JSONB,
            NULL 
        ) INTO v_id_nave_test;

        SELECT id_missao INTO v_id_missao_test FROM missoes WHERE id_nave = v_id_nave_test LIMIT 1;
        RAISE NOTICE 'Nave G Test ID: %, Only Mission G ID: %', v_id_nave_test, v_id_missao_test;

        -- Delete the mission
        RAISE NOTICE 'Deleting mission ID %...', v_id_missao_test;
        DELETE FROM missoes WHERE id_missao = v_id_missao_test;

        -- Add a tripulante
        RAISE NOTICE 'Adding new tripulante "New Crew G"...';
        INSERT INTO tripulantes (id_nave, nome_tripulante, data_de_nascimento, genero, nacionalidade, competencia, data_ingresso, status)
        VALUES (v_id_nave_test, 'New Crew G', '1992-02-02', 'Feminino', 'Test', 'Scientist', '2023-02-02', 'Active');
        
        RAISE NOTICE 'Attempting to COMMIT transaction...';
        RAISE NOTICE 'SUCCESS: Scenario G operations completed within transaction.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Scenario G FAILED: Unexpected error: %', SQLERRM;
    END;
    
    -- Verification (outside the transaction block, only if it succeeded)
    RAISE NOTICE 'Verifying data for Nave G Test ID %:', v_id_nave_test;
    -- These SELECTs will show results in the Data Output tab in pgAdmin
    SELECT COUNT(*) INTO v_mission_count FROM missoes WHERE id_nave = v_id_nave_test;
    SELECT COUNT(*) INTO v_tripulante_count FROM tripulantes WHERE id_nave = v_id_nave_test;
    PERFORM ensure_nave_has_minimum_dependencies(v_id_nave_test); -- Should not raise error
    RAISE NOTICE 'Verification check passed for Nave G.';

END;
$$;

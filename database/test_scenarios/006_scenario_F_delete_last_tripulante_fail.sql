-- SCENARIO F: Delete the last tripulante of a nave (that has no missions).
-- EXPECTED OUTCOME: FAIL at DELETE with error P0002.

DO $$
DECLARE
    v_id_nave_test INT;
    v_id_tripulante_test INT;
BEGIN
    -- Setup: Create a nave with only one tripulante
    SELECT create_nave_with_dependencies(
        'Nave F Test', 'Shuttle', 'TestFab', 2024, 'Active',
        NULL, -- No missoes
        '[{"nome_tripulante": "Solo Crew F", "data_de_nascimento": "1990-01-01", "genero": "Masculino", "nacionalidade": "Test", "competencia": "Pilot", "data_ingresso": "2023-01-01", "status": "Active"}]'::JSONB
    ) INTO v_id_nave_test;

    SELECT id_tripulante INTO v_id_tripulante_test FROM tripulantes WHERE id_nave = v_id_nave_test LIMIT 1;
    RAISE NOTICE 'Nave F Test ID: %, Solo Crew F ID: %', v_id_nave_test, v_id_tripulante_test;

    -- Attempt to delete the last tripulante
    RAISE NOTICE 'Attempting to DELETE the only tripulante (ID %) for Nave ID %...', v_id_tripulante_test, v_id_nave_test;
    BEGIN
        DELETE FROM tripulantes WHERE id_tripulante = v_id_tripulante_test;
        RAISE NOTICE 'Attempting to COMMIT transaction... (should fail here if not caught by DO block)';
    EXCEPTION
        WHEN SQLSTATE 'P0002' THEN
            RAISE NOTICE 'SUCCESS: Expected error P0002 (Nave would be orphaned) caught.';
            RAISE NOTICE '%', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Scenario F FAILED: Unexpected error: %', SQLERRM;
    END;
END;
$$;

-- SCENARIO H: Delete the last tripulante, but add a mission in the same transaction.
-- EXPECTED OUTCOME: SUCCEED.
-- Requires: `create_nave_with_dependencies` function.

DO $$
DECLARE
    v_id_nave_test INT;
    v_id_tripulante_test INT;
    mission_count INT;
    tripulante_count INT;
BEGIN
    BEGIN -- Explicit sub-transaction block
        -- Setup: Create a nave with only one tripulante
        SELECT create_nave_with_dependencies(
            'Nave H Test', 'Freighter', 'TestFab', 2024, 'Active',
            NULL,
            '[{"nome_tripulante": "Only Crew H", "data_de_nascimento": "1980-03-03", "genero": "Masculino", "nacionalidade": "Test", "competencia": "Engineer", "data_ingresso": "2023-03-03", "status": "Active"}]'::JSONB
        ) INTO v_id_nave_test;

        SELECT id_tripulante INTO v_id_tripulante_test FROM tripulantes WHERE id_nave = v_id_nave_test LIMIT 1;
        RAISE NOTICE 'Nave H Test ID: %, Only Crew H ID: %', v_id_nave_test, v_id_tripulante_test;

        -- Delete the tripulante
        RAISE NOTICE 'Deleting tripulante ID %...', v_id_tripulante_test;
        DELETE FROM tripulantes WHERE id_tripulante = v_id_tripulante_test;

        -- Add a mission
        RAISE NOTICE 'Adding new mission "New Mission H"...';
        INSERT INTO missoes (id_nave, nome_missao, data_lancamento, destino, duracao_dias, resultado, descricao)
        VALUES (v_id_nave_test, 'New Mission H', '2024-03-03', 'Venus', 20, 'Planned', 'Supply run');
        
        RAISE NOTICE 'SUCCESS: Scenario H operations completed within transaction.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Scenario H FAILED: Unexpected error: %', SQLERRM;
    END;
    
    -- Verification
    SELECT COUNT(*) INTO mission_count FROM missoes WHERE id_nave = v_id_nave_test;
    SELECT COUNT(*) INTO tripulante_count FROM tripulantes WHERE id_nave = v_id_nave_test;
    PERFORM ensure_nave_has_minimum_dependencies(v_id_nave_test);
    RAISE NOTICE 'Verification: mission_count=%, tripulante_count=%', mission_count, tripulante_count;
    RAISE NOTICE 'Verification check passed for Nave H.';

END;
$$;

-- SCENARIO J: Delete one of many tripulantes (nave still has other crew or missions).
-- EXPECTED OUTCOME: SUCCEED.
-- Requires: `create_nave_with_dependencies` function.

DO $$
DECLARE
    v_id_nave_test INT;
    v_id_tripulante_to_delete INT;
BEGIN
    -- Setup: Create a nave with multiple tripulantes
    SELECT create_nave_with_dependencies(
        'Nave J Test', 'Carrier', 'TestFab', 2024, 'Active',
        NULL,
        '[{"nome_tripulante": "Crew J1", "data_de_nascimento": "1990-01-01", "genero": "M", "nacionalidade": "Test", "competencia": "Deck Officer", "data_ingresso": "2023-01-01", "status": "Active"},
          {"nome_tripulante": "Crew J2", "data_de_nascimento": "1991-01-01", "genero": "F", "nacionalidade": "Test", "competencia": "Navigator", "data_ingresso": "2023-01-01", "status": "Active"}]'::JSONB
    ) INTO v_id_nave_test;

    SELECT id_tripulante INTO v_id_tripulante_to_delete FROM tripulantes WHERE id_nave = v_id_nave_test AND nome_tripulante = 'Crew J1' LIMIT 1;

    -- Delete one tripulante
    DELETE FROM tripulantes WHERE id_tripulante = v_id_tripulante_to_delete;

    -- Verification: count remaining tripulantes
    RAISE NOTICE 'Tripulantes remaining for nave %: %', v_id_nave_test, (SELECT COUNT(*) FROM tripulantes WHERE id_nave = v_id_nave_test);

    -- Call verification function (if it raises, the block will fail)
    PERFORM ensure_nave_has_minimum_dependencies(v_id_nave_test);

    RAISE NOTICE 'Verification check passed for Nave J.';
END;
$$;
-- To see the remaining tripulantes, run:
SELECT * FROM tripulantes WHERE id_nave = (SELECT id_nave FROM naves WHERE nome_nave = 'Nave J Test');

CREATE OR REPLACE FUNCTION ensure_nave_has_minimum_dependencies(p_id_nave INT)
RETURNS VOID AS $$
DECLARE
    v_mission_count INTEGER;
    v_crew_count INTEGER;
BEGIN
    -- Count current missions for the given nave
    SELECT COUNT(*) INTO v_mission_count
    FROM missoes
    WHERE id_nave = p_id_nave;

    -- Count current tripulantes for the given nave
    SELECT COUNT(*) INTO v_crew_count
    FROM tripulantes
    WHERE id_nave = p_id_nave;

    -- Check if both counts are zero
    IF v_mission_count = 0 AND v_crew_count = 0 THEN
        RAISE EXCEPTION 'Nave ID % requires at least one mission or tripulante. This operation would leave it orphaned.', p_id_nave
        USING ERRCODE = 'P0002', HINT = 'Ensure the nave retains at least one mission or tripulante, or delete the nave itself.';
    END IF;
    
    -- If checks pass, function completes. VOID functions don't explicitly return a value.
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_nave_dependencies_for_constraint()
RETURNS TRIGGER AS $$
DECLARE
    mission_count INTEGER;
    crew_count INTEGER;
BEGIN
    -- Verifica se há missões e tripulantes para a nave recém-inserida
    SELECT COUNT(*) INTO mission_count FROM missoes WHERE id_nave = NEW.id_nave;
    SELECT COUNT(*) INTO crew_count FROM tripulantes WHERE id_nave = NEW.id_nave;

    IF mission_count = 0 AND crew_count = 0 THEN
        RAISE EXCEPTION 
            'Nave ID % must have at least one mission or crew member. Transaction rolled back.', 
            NEW.id_nave 
            USING ERRCODE = '23502';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

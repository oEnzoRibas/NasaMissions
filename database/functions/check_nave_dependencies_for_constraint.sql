/*
    Function: check_nave_dependencies_for_constraint

    Description:
    This trigger function ensures referential integrity for the 'nave' (spaceship) entity by verifying that any newly inserted or updated spaceship (nave) has at least one associated mission or crew member. 
    If both the number of missions and crew members associated with the spaceship are zero, the function raises an exception and rolls back the transaction.

    Returns:
    TRIGGER - Returns the NEW record if the constraint is satisfied; otherwise, raises an exception.

    Raises:
    - Exception with SQLSTATE '23502' if the spaceship does not have at least one mission or crew member.

    Usage:
    Intended to be used as a trigger on insert or update operations on the 'nave' table to enforce business rules regarding spaceship dependencies.
*/
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

-- Trigger function for tripulantes AFTER DELETE
CREATE OR REPLACE FUNCTION tripulantes_delete_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    -- Call the generic check function, passing the id_nave of the nave
    -- whose tripulante was just deleted.
    PERFORM ensure_nave_has_minimum_dependencies(OLD.id_nave);
    RETURN OLD; -- Content of OLD is largely irrelevant for AFTER DELETE that only checks.
END;
$$ LANGUAGE plpgsql;

-- Constraint Trigger on tripulantes table
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger WHERE tgname = 'tripulante_delete_orphans_nave'
    ) THEN
        CREATE CONSTRAINT TRIGGER tripulante_delete_orphans_nave
        AFTER DELETE ON tripulantes
        DEFERRABLE INITIALLY DEFERRED
        FOR EACH ROW
        EXECUTE FUNCTION tripulantes_delete_trigger_function();
    END IF;
END;
$$;

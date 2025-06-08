-- Trigger function for missoes AFTER DELETE
CREATE OR REPLACE FUNCTION missoes_delete_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    -- Call the generic check function, passing the id_nave of the nave
    -- whose mission was just deleted.
    PERFORM ensure_nave_has_minimum_dependencies(OLD.id_nave);
    RETURN OLD; -- Content of OLD is largely irrelevant for AFTER DELETE that only checks.
END;
$$ LANGUAGE plpgsql;

-- Create the constraint trigger only if it does not already exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_trigger
        WHERE tgname = 'missoes_delete_orphans_nave'
    ) THEN
        EXECUTE $trg$
            CREATE CONSTRAINT TRIGGER missoes_delete_orphans_nave
            AFTER DELETE ON missoes
            DEFERRABLE INITIALLY DEFERRED
            FOR EACH ROW
            EXECUTE FUNCTION missoes_delete_trigger_function();
        $trg$;
    END IF;
END;
$$;

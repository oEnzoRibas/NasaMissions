-- Drop the old trigger if it exists to avoid conflicts
-- This DROP statement might be better run manually by the user once before applying new scripts,
-- but including it here defensively.
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'after_insert_nave_check_dependencies') THEN
        DROP TRIGGER after_insert_nave_check_dependencies ON naves;
    END IF;
END
$$;

-- Create the new constraint trigger only if it does not exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger WHERE tgname = 'enforce_nave_dependencies'
    ) THEN
        CREATE CONSTRAINT TRIGGER enforce_nave_dependencies
        AFTER INSERT OR UPDATE ON naves
        DEFERRABLE INITIALLY DEFERRED
        FOR EACH ROW
        EXECUTE FUNCTION check_nave_dependencies_for_constraint();
    END IF;
END
$$;

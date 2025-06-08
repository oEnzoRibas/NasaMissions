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

-- Create the new constraint trigger
CREATE CONSTRAINT TRIGGER enforce_nave_dependencies
AFTER INSERT ON naves  -- Can add OR UPDATE if updates to 'naves' table could also violate the constraint
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_nave_dependencies_for_constraint();

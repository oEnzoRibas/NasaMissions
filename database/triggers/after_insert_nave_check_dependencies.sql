-- Trigger to execute the check after insert on naves
CREATE TRIGGER after_insert_nave_check_dependencies
AFTER INSERT ON naves
FOR EACH ROW
EXECUTE FUNCTION check_nave_dependencies();

-- SCENARIO A: Attempting to add a Nave WITHOUT missions or tripulants
-- EXPECTED OUTCOME: FAIL at COMMIT with error "Nave ID X must have at least one mission or crew member..."
-- Run this script using psql: psql -U your_username -d nasa_missions -f 001_scenario_A_nave_alone_fail.sql

BEGIN;

INSERT INTO naves (nome, tipo, fabricante, ano_construcao, status)
VALUES ('Test Nave Fail Script', 'Type A', 'Test Corp', 2024, 'Active');


-- The error from the DEFERRED constraint trigger should occur here.
COMMIT;

-- This SELECT should ideally not be reached if COMMIT fails and script execution stops.
-- If execution continues past a failed COMMIT (client dependent), this should return no rows.

SELECT * FROM naves WHERE nome = 'Test Nave Fail Script';

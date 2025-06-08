# Database Setup for Nasa_Missions Project

This guide provides instructions on how to set up the PostgreSQL database required for this project.

## 1. Prerequisites
- Ensure PostgreSQL is installed and running.

## 2. Create the Database
Before running any application code or specific SQL scripts, you need to create the `nasa_missions` database.

Connect to your PostgreSQL server (e.g., using `psql` client, typically connecting to the default `postgres` database or any other existing database available to your PostgreSQL user). Then, execute the following SQL command:

```sql
CREATE DATABASE nasa_missions;
```

## 3. Connect to the Newly Created Database
Once the `nasa_missions` database is created, you must connect to it before proceeding with schema creation or data insertion.

If using `psql`, you can connect like this:
```bash
psql -U your_username -d nasa_missions
```
Replace `your_username` with your actual PostgreSQL username.

## 4. Apply SQL Scripts
After connecting to the `nasa_missions` database, run the SQL scripts located in this `database` directory in the following specific order.

It's recommended to use a PostgreSQL client like `psql` to execute these files. For example:
`psql -U your_username -d nasa_missions -f path/to/script.sql`

### a. Data Definition Language (DDL) - Create Schema
These scripts create the table structures. Execute them in the numbered order.
- `DDL/001_create_naves.sql`
- `DDL/002_create_tripulantes.sql`
- `DDL/003_create_missoes.sql`
- `DDL/004_create_equipe_missoes.sql`

### b. Stored Functions

These scripts create stored functions used by the database.

#### `functions/check_nave_dependencies.sql`
*   **`check_nave_dependencies_for_constraint()`**:
    *   **Purpose:** This function is executed by the `enforce_nave_dependencies` constraint trigger on the `naves` table. It checks if a newly inserted nave has at least one mission or tripulante associated with it at the time of transaction commit.
    *   **Usage:** Internal use by the database trigger `enforce_nave_dependencies`. Not typically called directly by users or the application.

#### `functions/manage_nave_creation.sql`
*   **`create_nave_with_dependencies(p_nome TEXT, p_tipo TEXT, p_fabricante TEXT, p_ano_construcao INT, p_status TEXT, p_missoes JSONB DEFAULT NULL, p_tripulantes JSONB DEFAULT NULL)`**:
    *   **Purpose:** Creates a new nave along with its initial set of missions and/or tripulantes in a single, atomic transaction. This is the primary function used by the backend API and the consolidated DML script (`DML/000_consolidated_seed_data.sql`) for creating naves.
    *   **Parameters:**
        *   `p_nome`, `p_tipo`, `p_fabricante`, `p_ano_construcao`, `p_status`: Core fields for the nave.
        *   `p_missoes JSONB DEFAULT NULL`: A JSONB array of mission objects. Each object should contain keys like `nome_missao`, `data_lancamento` (YYYY-MM-DD), `destino`, `duracao_dias` (integer), `resultado`, `descricao`. Example: `[{"nome_missao": "Mission Alpha", "data_lancamento": "2024-08-15", ...}]`.
        *   `p_tripulantes JSONB DEFAULT NULL`: A JSONB array of tripulante objects. Each object should contain keys like `nome_tripulante`, `data_de_nascimento` (YYYY-MM-DD), `genero`, `nacionalidade`, `competencia`, `data_ingresso` (YYYY-MM-DD), `status`. Example: `[{"nome_tripulante": "Cmdr. Eva Rostova", ...}]`.
    *   **Validation:** The function requires that either `p_missoes` or `p_tripulantes` (or both) be provided and contain at least one element. It will raise an exception (ERRCODE P0001) if this condition is not met.
    *   **Returns:** The `id_nave` of the newly created nave.

#### `functions/ensure_nave_dependencies.sql`
*   **`ensure_nave_has_minimum_dependencies(p_id_nave INT)`**:
    *   **Purpose:** Checks if the specified `nave` (by `p_id_nave`) currently has at least one associated mission or tripulante record. This function is primarily used by `AFTER DELETE` triggers on the `missoes` and `tripulantes` tables to prevent operations that would leave a nave orphaned.
    *   **Parameters:**
        *   `p_id_nave INT`: The ID of the nave to check.
    *   **Behavior:** If the nave has no remaining missions AND no remaining tripulantes, the function raises an exception (ERRCODE P0002) to signal a violation.
    *   **Returns:** `VOID`.

### c. Triggers

These scripts create triggers that enforce database rules.

#### `triggers/after_insert_nave_check_dependencies.sql`
*   **`enforce_nave_dependencies`**:
    *   **Table:** `naves`
    *   **Event:** `AFTER INSERT`
    *   **Type:** `CONSTRAINT TRIGGER`, `DEFERRABLE INITIALLY DEFERRED`, `FOR EACH ROW`
    *   **Purpose:** Ensures that a newly inserted `nave` has at least one associated mission or tripulante. It calls the `check_nave_dependencies_for_constraint()` function at the end of the transaction. If the check fails, the transaction is rolled back, typically with error `23502` (not_null_violation, as per the original trigger's setup).

#### `triggers/manage_missoes_deletes.sql`
*   **`missoe_delete_orphans_nave`**:
    *   **Table:** `missoes`
    *   **Event:** `AFTER DELETE`
    *   **Type:** `CONSTRAINT TRIGGER`, `DEFERRABLE INITIALLY DEFERRED`, `FOR EACH ROW`
    *   **Purpose:** Ensures that deleting a mission does not leave the parent `nave` without any associated missions or tripulantes. It calls the `ensure_nave_has_minimum_dependencies` function for the affected nave's ID (`OLD.id_nave`) at the end of the transaction. If the check fails (i.e., the nave would be orphaned), the transaction is rolled back with error `P0002`.

#### `triggers/manage_tripulantes_deletes.sql`
*   **`tripulante_delete_orphans_nave`**:
    *   **Table:** `tripulantes`
    *   **Event:** `AFTER DELETE`
    *   **Type:** `CONSTRAINT TRIGGER`, `DEFERRABLE INITIALLY DEFERRED`, `FOR EACH ROW`
    *   **Purpose:** Ensures that deleting a tripulante does not leave the parent `nave` without any associated missions or tripulantes. It calls the `ensure_nave_has_minimum_dependencies` function for the affected nave's ID (`OLD.id_nave`) at the end of the transaction. If the check fails, the transaction is rolled back with error `P0002`.

### d. Data Manipulation Language (DML) - Seed Data (Optional)
These scripts populate the database with initial sample data. This step is optional if you prefer to start with an empty database (beyond the schema).

The seed data for naves, missions, and their initial crew members has been consolidated to ensure that each nave is created with its required dependencies in a single transaction, complying with database constraints.

1.  **`DML/000_consolidated_seed_data.sql`**: Populates `naves`, and their initial `missoes` and `tripulantes` by calling the `create_nave_with_dependencies` stored function for each nave. This ensures data is transactionally complete and consistent with application logic.
2.  **`DML/004_seed_equipe_missoes.sql`**: Populates the `equipe_missoes` table, linking tripulantes to their respective missoes based on nave association. This should be run after the consolidated data script.

(The individual files `DML/001_seed_naves.sql`, `DML/002_seed_missoes.sql`, and `DML/003_seed_tripulantes.sql` are superseded by `000_consolidated_seed_data.sql` for direct execution.)

---
### Custom Error Codes Used
*   **`P0001`**: (From `create_nave_with_dependencies` function) Indicates an attempt to create a nave without providing at least one initial mission or tripulante.
*   **`P0002`**: (From `ensure_nave_has_minimum_dependencies` function, called by delete triggers) Indicates that a delete operation on `missoes` or `tripulantes` would leave the parent nave without any missions or tripulantes.
*   **`23502`**: (Standard PostgreSQL, used by `enforce_nave_dependencies` constraint trigger on `naves` table) Indicates a violation when inserting a nave, typically if the deferred check finds no dependencies.
---

## 5. Verify Setup
After running the scripts, you can verify the tables and objects exist using your SQL client. For example, in `psql`:
- `\dt` to list tables.
- `\df` to list functions.
- `\d naves` to describe the naves table and see its triggers.

Your database should now be ready for the application.

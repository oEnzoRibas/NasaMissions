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
- `functions/check_nave_dependencies.sql`

### c. Triggers
These scripts create triggers that enforce database rules.
- `triggers/after_insert_nave_check_dependencies.sql`

### d. Data Manipulation Language (DML) - Seed Data (Optional)
These scripts populate the database with initial sample data. This step is optional if you prefer to start with an empty database (beyond the schema).
- `DML/001_seed_naves.sql`
- `DML/002_seed_missoes.sql`
- `DML/003_seed_tripulantes.sql`
- `DML/004_seed_equipe_missoes.sql`

## 5. Verify Setup
After running the scripts, you can verify the tables and objects exist using your SQL client. For example, in `psql`:
- `\dt` to list tables.
- `\df` to list functions.
- `\d naves` to describe the naves table and see its triggers.

Your database should now be ready for the application.

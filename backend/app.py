from flask import Flask, request, jsonify
from flask_cors import CORS
from flasgger import Swagger
from datetime import datetime
import psycopg2
import json
import os

app = Flask(__name__)
app.config['SWAGGER'] = {
    'title': 'NASA API',
    'uiversion': 3
}
CORS(app)
swagger = Swagger(app)

# Conexão com PostgreSQL
conn = psycopg2.connect(
    host="localhost",
    database="nasa_missions",
    user="postgres",
    password="sa123456"
)
cursor = conn.cursor()

print("Conectado ao banco:", conn.get_dsn_parameters())

def criar_tabelas():
    app.logger.info("Starting database schema setup...")
    
    # Define paths assuming execution from project root where 'database' is a top-level dir
    # If app.py is in 'backend/', adjust base_db_path: e.g., os.path.join("..", "database")
    # For this project structure, app.py is in backend/, so paths need adjustment.
    # Let's assume the script is run from the project root for now, or paths are adjusted.
    # If running `flask run` from project root, and app.py is in `backend`, then `database` is sibling to `backend`.
    # Thus, `../database` from `app.py`'s perspective, or `database` if CWD is project root.
    # The `open()` call will be relative to CWD. If Flask CLI sets CWD to project root, "database" is fine.
    # Let's assume CWD is project root when running the Flask app.
    base_db_path =  os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'database'))
    ddl_dir = os.path.join(base_db_path, "DDL")
    functions_dir = os.path.join(base_db_path, "functions")
    triggers_dir = os.path.join(base_db_path, "triggers")

    # Define file lists in execution order
    ddl_files = [
        os.path.join(ddl_dir, "001_create_naves.sql"),
        os.path.join(ddl_dir, "002_create_tripulantes.sql"),
        os.path.join(ddl_dir, "003_create_missoes.sql")
        #os.path.join(ddl_dir, "004_create_equipe_missoes.sql")
    ]
    # Corrected function file name based on previous steps
    function_files = [
        os.path.join(functions_dir, "check_nave_dependencies_for_constraint.sql"), # Contains check_nave_dependencies_for_constraint
        os.path.join(functions_dir, "create_nave_with_dependencies.sql"),      # Contains create_nave_with_dependencies
        os.path.join(functions_dir, "ensure_nave_has_minimum_dependencies.sql"),           # Contains ensure_nave_has_minimum_dependencies
        os.path.join(functions_dir, "delete_nave_completely.sql") # Contains delete_nave_completely
    ]
    trigger_files = [
        os.path.join(triggers_dir, "after_insert_nave_check_dependencies.sql"), # Uses check_nave_dependencies_for_constraint
        os.path.join(triggers_dir, "manage_missoes_deletes.sql"),          # Uses ensure_nave_has_minimum_dependencies
        os.path.join(triggers_dir, "manage_tripulantes_deletes.sql")       # Uses ensure_nave_has_minimum_dependencies
    ]

    all_sql_files = ddl_files + function_files + trigger_files

    try:
        for filepath in all_sql_files:
            # Check if path exists before trying to open, helpful for debugging path issues
            if not os.path.exists(filepath):
                app.logger.error(f"SQL file not found: {filepath}. Current CWD: {os.getcwd()}")
                # If running from 'backend' dir, path should be e.g. '../database/DDL/001_create_naves.sql'
                # Trying adjusted path assuming app.py is in 'backend'
                adjusted_filepath = os.path.join("..", filepath)
                if not os.path.exists(adjusted_filepath):
                    app.logger.error(f"Adjusted SQL file path also not found: {adjusted_filepath}")
                    raise FileNotFoundError(f"SQL file {filepath} (or {adjusted_filepath}) not found.")
                else:
                    filepath = adjusted_filepath # Use adjusted path

            app.logger.info(f"Processing SQL file: {filepath}")
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    sql_script = f.read()
                
                if sql_script.strip():
                    # Split script by semicolon only if it's not part of a DO $$...$$ block or FUNCTION/PROCEDURE body
                    # For simplicity here, we assume each file is one logical block or psql can handle it.
                    # PostgreSQL's cursor.execute() can often handle multi-statement strings if they are valid.
                    # However, complex function/trigger definitions with internal semicolons are best kept in their own files.
                    cursor.execute(sql_script)
                    app.logger.info(f"Successfully executed {filepath}")
                else:
                    app.logger.info(f"Skipped empty SQL file: {filepath}")

            except FileNotFoundError: # Should be caught by os.path.exists now, but as fallback.
                app.logger.error(f"SQL file not found during open: {filepath}. CWD: {os.getcwd()}")
                raise
            except psycopg2.Error as db_err:
                app.logger.error(f"Database error executing {filepath}: {db_err}")
                app.logger.error(f"Error details: pgcode={db_err.pgcode}, pgerror={db_err.pgerror}")
                conn.rollback() 
                raise 
            except Exception as e:
                app.logger.error(f"General error reading/executing {filepath}: {e}")
                raise 

        conn.commit()
        app.logger.info("✅ Database schema setup completed successfully!")

    except Exception as e:
        app.logger.error(f"❌ Database schema setup failed: {e}")
        # Ensure rollback if any re-raised exception wasn't a psycopg2.Error that already rolled back.
        # However, conn.rollback() might fail if connection is already closed or in an unusable state.
        try:
            conn.rollback()
            app.logger.info("Rolled back transaction due to overall schema setup failure.")
        except Exception as rb_err:
            app.logger.error(f"Rollback attempt failed after schema setup error: {rb_err}")

criar_tabelas()
# # ... rest of the routes ...

# ===== ROTAS API =====

# ---- Naves ----

@app.route('/naves', methods=['GET'])
def get_naves():
    """
    Lista todas as naves
    ---
    tags:
        - Naves
    responses: 
        200:
            description: Lista de naves
            examples:
                application/json: [
                    {
                        "id_nave": 1,
                        "nome": "Saturno V",
                        "tipo": "Foguete",
                        "fabricante": "NASA",
                        "ano_construcao": 1967,
                        "status": "Aposentada"
                    }
                ]
                
        500:
            description: Erro de banco de dados ou erro interno do servidor
            examples:
                application/json: {"error": "Database error occurred.", "detail": "Error details..."}
        401:
            description: Não autorizado
            examples:
                application/json: {"error": "Não autorizado"}
        404:
            description: Nenhuma nave encontrada
            examples:
                application/json: {"error": "Nenhuma nave encontrada"}

    """
    try:
      cursor.execute("SELECT * FROM naves")
      
      rows = cursor.fetchall()
      naves = [
          {'id_nave': r[0], 'nome': r[1], 'tipo': r[2], 'fabricante': r[3], 'ano_construcao': r[4], 'status': r[5]}
          for r in rows
      ]
      print("Naves:", naves)  # Debugging line to check fetched data
      return jsonify(naves), 200
    except psycopg2.Error as e:
        app.logger.error(f"Database error occurred: {e}")
        app.logger.error(f"PGCODE: {e.pgcode}, PGERROR: {e.pgerror}")
        app.logger.error(f"Diagnostics: {e.diag}")
        return jsonify({'error': 'Database error occurred.', 'detail': str(e)}), 500

@app.route('/naves/<int:id>', methods=['GET'])
def get_nave(id):
    """
    Obtém os detalhes de uma nave pelo ID
    ---
    tags:
        - Naves
    parameters:
        - in: path
          name: id
          type: integer
          required: true
          description: ID da nave a ser buscada
    responses:
        200:
            description: Detalhes da nave
            examples:
                application/json: {
                    "id_nave": 1,
                    "nome": "Saturno V",
                    "tipo": "Foguete",
                    "fabricante": "NASA",
                    "ano_construcao": 1967,
                    "status": "Aposentada"
                }
        404:
            description: Nave não encontrada
            examples:
                application/json: {"error": "Nave não encontrada"}
    """
    try:
        cursor.execute("SELECT * FROM naves WHERE id_nave = %s", (id,))
        row = cursor.fetchone()
        if not row:
            return jsonify({'error': 'Nave não encontrada'}), 404

        nave = {
            'id_nave': row[0],
            'nome': row[1],
            'tipo': row[2],
            'fabricante': row[3],
            'ano_construcao': row[4],
            'status': row[5]
        }
        return jsonify(nave), 200
    except psycopg2.Error as e:
        app.logger.error(f"Database error occurred: {e}")
        return jsonify({'error': 'Database error occurred.', 'detail': str(e)}), 500

        
@app.route('/naves', methods=['POST'])
def add_nave():
    """
    Adiciona uma nova nave com suas missões e/ou tripulantes.
    A nave deve ter pelo menos uma missão ou um tripulante associado na criação.
    ---
    tags:
    - Naves
    parameters:
      - in: body
        name: body
        description: Dados da nave e suas dependências (missões e/ou tripulantes)
        required: true
        schema:
          type: object
          required:
            - nome
            - tipo
            - fabricante
            - ano_construcao
            - status
          properties:
            nome:
              type: string
              example: "Enterprise-D"
            tipo:
              type: string
              example: "Exploradora"
            fabricante:
              type: string
              example: "Starfleet"
            ano_construcao:
              type: integer
              example: 2363
            status:
              type: string
              example: "Ativa"
            missoes:
              type: array
              items:
                type: object
                properties:
                  nome_missao: {type: string, example: "Explorar Sector Gama"}
                  data_lancamento: {type: string, format: date, example: "2364-02-04"}
                  destino: {type: string, example: "Sector Gama"}
                  duracao_dias: {type: integer, example: 730}
                  resultado: {type: string, example: "Em Andamento"}
                  descricao: {type: string, example: "Missão de exploração de longa duração."}
              nullable: true
            tripulantes:
              type: array
              items:
                type: object
                properties:
                  nome_tripulante: {type: string, example: "Jean-Luc Picard"}
                  data_de_nascimento: {type: string, format: date, example: "2305-07-13"}
                  genero: {type: string, example: "Masculino"}
                  nacionalidade: {type: string, example: "Francês, Terra"}
                  competencia: {type: string, example: "Comandante"}
                  data_ingresso: {type: string, format: date, example: "2363-01-01"}
                  status: {type: string, example: "Ativo"}
              nullable: true
          example:
            nome: "USS Voyager"
            tipo: "Intrepid-class"
            fabricante: "Starfleet"
            ano_construcao: 2371
            status: "Ativa"
            missoes:
              - nome_missao: "Retorno ao Quadrante Alfa"
                data_lancamento: "2371-01-01"
                destino: "Quadrante Alfa"
                duracao_dias: 25550 # approx 70 years
                resultado: "Em Andamento"
                descricao: "Perdida no Quadrante Delta, tentando retornar para casa."
            tripulantes:
              - nome_tripulante: "Kathryn Janeway"
                data_de_nascimento: "2295-05-20"
                genero: "Feminino"
                nacionalidade: "Humana, Terra"
                competencia: "Comandante"
                data_ingresso: "2371-01-01"
                status: "Ativa"
    responses:
        201:
            description: Nave adicionada com sucesso
            examples:
                application/json:
                    message: "Nave adicionada com sucesso"
                    id_nave: 123
        400:
            description: Erro de validação. Pode ser devido à ausência de missões/tripulantes (pgcode P0001) ou violação de constraint (pgcode 23502 - fallback).
            examples:
                application/json:
                    error: "A nave deve ser criada com pelo menos uma missão OU um tripulante."
                    detail: "PGERROR detail..." 
        500:
            description: Erro interno do servidor ou erro de banco de dados não tratado especificamente.
    """
    try:
        data = request.json

        nome = data.get('nome')
        tipo = data.get('tipo')
        fabricante = data.get('fabricante')
        ano_construcao = data.get('ano_construcao')
        status_nave = data.get('status')  # Renamed to avoid conflict with tripulante status

        if not all([nome, tipo, fabricante, ano_construcao, status_nave]):
            return jsonify({'error': 'Missing required nave fields: nome, tipo, fabricante, ano_construcao, status'}), 400

        missoes_data = data.get('missoes', [])
        tripulantes_data = data.get('tripulantes', [])

        # Convert mission and tripulante data to JSON strings for PostgreSQL
        missoes_json = json.dumps(missoes_data) if missoes_data else None
        tripulantes_json = json.dumps(tripulantes_data) if tripulantes_data else None

    except Exception as e:
        conn.rollback()
        app.logger.error(f"Error parsing request data: {e}")
        return jsonify({'error': 'Invalid input data.', 'detail': str(e)}), 400

    try:
        sql = """
            SELECT create_nave_with_dependencies(
                %s, %s, %s, %s, %s, 
                %s::jsonb, %s::jsonb
            );
        """
        cursor.execute(sql, (
            nome, tipo, fabricante, ano_construcao, status_nave,
            missoes_json,
            tripulantes_json
        ))
        new_nave_id = cursor.fetchone()[0]
        conn.commit()
        return jsonify({'message': 'Nave adicionada com sucesso', 'id': new_nave_id}), 201
    except psycopg2.Error as e:
        conn.rollback()
        app.logger.error(f"Database error occurred: {e}")
        app.logger.error(f"PGCODE: {e.pgcode}, PGERROR: {e.pgerror}")
        app.logger.error(f"Diagnostics: {e.diag}")

        if e.pgcode == 'P0001': # Custom error from our stored function
            # The actual user-facing error message from PostgreSQL for RAISE EXCEPTION
            # is often in e.pgerror or e.diag.message_primary.
            user_message = e.pgerror.split('ERROR:  ')[-1].split('\nHINT:')[0] if e.pgerror else 'A nave deve ser criada com pelo menos uma missão OU um tripulante.'
            return jsonify({'error': user_message}), 400
        elif e.pgcode == '23502': # Fallback for constraint trigger if function logic missed something
             # This is the not_null_violation from the deferred trigger
            user_message = e.pgerror.split('ERROR:  ')[-1].split('\nDETAIL:')[0] if e.pgerror else 'Nave must have at least one mission or crew member.'
            return jsonify({'error': user_message}), 400
        else:
            return jsonify({'error': 'Database error occurred.', 'detail': str(e)}), 500
    except Exception as e:
        conn.rollback()
        app.logger.error(f"An unexpected error occurred: {e}")
        return jsonify({'error': 'An unexpected server error occurred.', 'detail': str(e)}), 500

@app.route('/naves/<int:id>', methods=['DELETE'])
def delete_nave(id):
    """
    Remove uma nave pelo ID
    ---
    tags:
        - Naves
    parameters:
    - in: path
      name: id
      type: integer
      required: true
      description: ID da nave a ser removida
    responses:
        200:
            description: Nave removida com sucesso
            examples:
                application/json: {"message": "Nave removida"}
    """
    try:
        # Check if the nave exists before attempting to delete
        cursor.execute("SELECT 1 FROM naves WHERE id_nave = %s", (id,))
        exists = cursor.fetchone()
        if not exists:
            return jsonify({'error': 'Nave não encontrada'}), 404

        cursor.execute("SELECT delete_nave_completely(%s)", (id,))
        deleted = cursor.fetchone()
        conn.commit()
        return jsonify({'message': 'Nave removida com sucesso.'}), 200
    except psycopg2.Error as e:
        conn.rollback()
        app.logger.error(f"Database error occurred: {e}")
        return jsonify({'error': 'Erro no banco de dados.', 'detail': str(e)}), 500
    except Exception as e:
        conn.rollback()
        app.logger.error(f"Unexpected error occurred: {e}")
        return jsonify({'error': 'Erro inesperado no servidor.', 'detail': str(e)}), 500

# ---- Tripulantes ----

@app.route('/tripulantes', methods=['GET'])
def get_tripulantes_all():
    """
    Lista todos os tripulantes
    ---
    tags:
        - Tripulantes
    responses:
        200:
            description: Lista de tripulantes
            examples:
                application/json: [
                    {
                        "id_tripulante": 1,
                        "id_nave": 1,
                        "nome_tripulante": "Jean-Luc Picard",
                        "data_de_nascimento": "2305-07-13",
                        "genero": "Masculino",
                        "nacionalidade": "Francês, Terra",
                        "competencia": "Comandante",
                        "data_ingresso": "2363-01-01",
                        "status": "Ativo"
                    }
                ]
    """
    try:
        cursor.execute("SELECT * FROM Tripulantes")
        rows = cursor.fetchall()

        tripulantes = [
            {
                'id_tripulante': r[0],
                'id_nave': r[1],
                'nome_tripulante': r[2],
                'data_de_nascimento': r[3].isoformat() if r[3] else None,
                'genero': r[4],
                'nacionalidade': r[5],
                'competencia': r[6],
                'data_ingresso': r[7].isoformat() if r[7] else None,
                'status': r[8]
            }
            for r in rows
        ]

        return jsonify(tripulantes)
    except psycopg2.Error as e:
        conn.rollback()
        app.logger.error(f"Database error occurred: {e}")
        return jsonify({'error': 'Database error occurred.', 'detail': str(e)}), 500
    except Exception as e:
        conn.rollback()
        app.logger.error(f"Unexpected error occurred: {e}")
        return jsonify({'error': 'Unexpected server error occurred.', 'detail': str(e)}), 500

@app.route('/tripulantes/<int:id_nave>', methods=['GET'])
def get_tripulantes(id_nave):
    """
    Lista todos os tripulantes de uma nave
    ---
    tags:
        - Tripulantes
    parameters:
        - in: path
          name: id_nave
          type: integer
          required: true
          description: ID da nave para buscar os tripulantes
    responses:
        200:
            description: Lista de tripulantes da nave
    """
    try:
        cursor.execute("SELECT * FROM Tripulantes WHERE id_nave = %s", (id_nave,))
        rows = cursor.fetchall()
        tripulantes = [
            {
                'id_tripulante': r[0],
                'id_nave': r[1],
                'nome_tripulante': r[2],
                'data_de_nascimento': r[3].strftime('%Y-%m-%d') if r[3] else None,
                'genero': r[4],
                'nacionalidade': r[5],
                'competencia': r[6],
                'data_ingresso': r[7].strftime('%Y-%m-%d') if r[7] else None,
                'status': r[8]
            }
            for r in rows
        ]
        return jsonify(tripulantes)
    except psycopg2.Error as e:
        conn.rollback()
        app.logger.error(f"Database error occurred: {e}")
        return jsonify({'error': 'Database error occurred.', 'detail': str(e)}), 500
    except Exception as e:
        conn.rollback()
        app.logger.error(f"Unexpected error occurred: {e}")
        return jsonify({'error': 'Unexpected server error occurred.', 'detail': str(e)}), 500

@app.route('/tripulantes/<int:id_nave>', methods=['POST'])
def add_tripulante(id_nave):
    """
    Adiciona um novo tripulante a uma nave
    ---
    tags:
        - Tripulantes
    parameters:
        - in: path
          name: id_nave
          type: integer
          required: true
          description: ID da nave relacionada ao tripulante
        - in: body
          name: tripulante
          description: Dados do tripulante a ser adicionado
          required: true
          schema:
            type: object
            properties:
              nome_tripulante:
                type: string
              data_de_nascimento:
                type: string
                format: date
              genero:
                type: string
              nacionalidade:
                type: string
              competencia:
                type: string
              data_ingresso:
                type: string
                format: date
              status:
                type: string
    responses:
        200:
            description: Tripulante adicionado com sucesso
            examples:
                application/json: {"message": "Tripulante adicionado"}
    """
    try:
        data = request.json
        cursor.execute("""
            INSERT INTO Tripulantes (id_nave, nome_tripulante, data_de_nascimento, genero, nacionalidade, competencia, data_ingresso, status)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            id_nave,
            data['nome_tripulante'],
            data.get('data_de_nascimento'),
            data.get('genero'),
            data.get('nacionalidade'),
            data.get('competencia'),
            data.get('data_ingresso'),
            data.get('status')
        ))
        conn.commit()
        return jsonify({'message': 'Tripulante adicionado'})
    except psycopg2.Error as e:
        conn.rollback()
        app.logger.error(f"Database error occurred: {e}")
        return jsonify({'error': 'Database error occurred.', 'detail': str(e)}), 500
    except Exception as e:
        conn.rollback()
        app.logger.error(f"Unexpected error occurred: {e}")
        return jsonify({'error': 'Unexpected server error occurred.', 'detail': str(e)}), 500

@app.route('/tripulantes/<int:id_nave>/<int:id_tripulante>', methods=['DELETE'])
def delete_tripulante(id_nave, id_tripulante):
    """
    Remove um tripulante pelo ID da nave e ID do tripulante
    ---
    tags:
        - Tripulantes
    parameters:
        - in: path
          name: id_nave
          type: integer
          required: true
          description: ID da nave relacionada ao tripulante
        - in: path
          name: id_tripulante
          type: integer
          required: true
          description: ID do tripulante a ser removido
    responses:
        200:
            description: Tripulante removido com sucesso
            examples:
                application/json: {"message": "Tripulante removido"}
        404:
            description: Tripulante não encontrado
            examples:
                application/json: {"error": "Tripulante não encontrado"}
    """
    try:
        cursor.execute(
            "DELETE FROM Tripulantes WHERE id_nave = %s AND id_tripulante = %s RETURNING id_tripulante",
            (id_nave, id_tripulante)
        )
        deleted = cursor.fetchone()
        conn.commit()
        if deleted:
            return jsonify({'message': 'Tripulante removido'})
        else:
            return jsonify({'error': 'Tripulante não encontrado'}), 404
    except psycopg2.Error as e:
        conn.rollback()
        app.logger.error(f"Database error occurred: {e}")
        return jsonify({'error': 'Database error occurred.', 'detail': str(e)}, 500), 500
    except Exception as e:
        conn.rollback()
        app.logger.error(f"Unexpected error occurred: {e}")
        return jsonify({'error': 'Unexpected server error occurred.', 'detail': str(e)},500), 500

# ---- Missoes ----

@app.route('/missoes', methods=['GET'])
def get_missoes_all():
    """
    Lista todas as missões
    ---
    tags:
        - Missoes
    responses:
        200:
            description: Lista de todas as missões
            examples:
                application/json: [
                    {
                        "id": 1,
                        "id_nave": 1,
                        "nome": "Missão Lunar",
                        "data": "2023-01-01",
                        "destino": "Lua",
                        "duracao": 30,
                        "resultado": "Sucesso",
                        "descricao": "Primeira missão tripulada à Lua."
                    }
                ]
    """
    try:
        cursor.execute("SELECT * FROM Missoes")
        rows = cursor.fetchall()
        missoes = [
            {
                'id_missao': r[0],
                'id_nave': r[1],
                'nome': r[2],
                'data': r[3].strftime('%Y-%m-%d') if r[3] else None,
                'destino': r[4],
                'duracao': r[5],
                'resultado': r[6],
                'descricao': r[7]
            }
            for r in rows
        ]
        return jsonify(missoes)
    except psycopg2.Error as e:
        conn.rollback()
        app.logger.error(f"Database error occurred: {e}")
        return jsonify({'error': 'Database error occurred.', 'detail': str(e)}), 500
    except Exception as e:
        conn.rollback()
        app.logger.error(f"Unexpected error occurred: {e}")
        return jsonify({'error': 'Unexpected server error occurred.', 'detail': str(e)}), 500
@app.route('/missoes/<int:id_nave>', methods=['GET'])
def get_missoes(id_nave):
    """
    Lista todas as missões de uma nave
    ---
    tags:
        - Missoes
    parameters:
        - in: path
          name: id_nave
          type: integer
          required: true
          description: ID da nave para buscar as missões
    responses:
        200:
            description: Lista de missões da nave
    """
    try:
        cursor.execute("SELECT * FROM Missoes WHERE id_nave = %s", (id_nave,))
        rows = cursor.fetchall()
        missoes = [
            {'id_missao': r[0], 'id_nave': r[1], 'nome': r[2], 'data': r[3].strftime('%Y-%m-%d'), 'destino': r[4], 'duracao': r[5], 'resultado': r[6], 'descricao': r[7]}
            for r in rows
        ]
        return jsonify(missoes)
    except psycopg2.Error as e:
        conn.rollback()
        app.logger.error(f"Database error occurred: {e}")
        return jsonify({'error': 'Database error occurred.', 'detail': str(e)}), 500
    except Exception as e:
        conn.rollback()
        app.logger.error(f"Unexpected error occurred: {e}")
        return jsonify({'error': 'Unexpected server error occurred.', 'detail': str(e)}), 500

@app.route('/missoes/<int:id_nave>', methods=['POST'])
def add_missao(id_nave):
    """
    Adiciona uma nova missão para uma nave
    ---
    tags:
        - Missoes
    parameters:
        - in: path
          name: id_nave
          type: integer
          required: true
          description: ID da nave relacionada à missão
        - in: body
          name: missao
          description: Dados da missão a ser adicionada
          required: true
          schema:
            type: object
            properties:
              nome:
                type: string
              data:
                type: string
                format: date
              destino:
                type: string
              duracao:
                type: integer
              resultado:
                type: string
              descricao:
                type: string
    responses:
        200:
            description: Missão adicionada com sucesso
            examples:
                application/json: {"message": "Missão adicionada"}
    """
    try:
        data = request.json
        cursor.execute("""
            INSERT INTO Missoes (id_nave, nome_missao, data_lancamento, destino, duracao_dias, resultado, descricao)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            id_nave,
            data['nome'],
            data['data'],
            data['destino'],
            data['duracao'],
            data['resultado'],
            data.get('descricao')
        ))
        conn.commit()
        return jsonify({'message': 'Missão adicionada'})
    except psycopg2.Error as e:
        conn.rollback()
        app.logger.error(f"Database error occurred: {e}")
        return jsonify({'error': 'Database error occurred.', 'detail': str(e)}), 500
    except Exception as e:
        conn.rollback()
        app.logger.error(f"Unexpected error occurred: {e}")
        return jsonify({'error': 'Unexpected server error occurred.', 'detail': str(e)}), 500

@app.route('/missoes/<int:id_nave>/<int:id_missao>', methods=['DELETE'])
def delete_missao(id_nave, id_missao):
    """
    Remove uma missão pelo ID da nave e ID da missão
    ---
    tags:
        - Missoes
    parameters:
        - in: path
          name: id_nave
          type: integer
          required: true
          description: ID da nave relacionada à missão
        - in: path
          name: id_missao
          type: integer
          required: true
          description: ID da missão a ser removida
    responses:
        200:
            description: Missão removida com sucesso
            examples:
                application/json: {"message": "Missão removida"}
        
        409:
            description: Não é possível remover a missão porque a nave deve ter pelo menos uma missão ou tripulante.
            examples:
                application/json: {"error": "A nave deve ter pelo menos uma missão ou tripulante."}

        404:
            description: Missão não encontrada
            examples:
                application/json: {"error": "Missão não encontrada"}
        
        500:
            description: Erro interno do servidor ou erro de banco de dados não tratado especificamente.
            examples:
                application/json: {"error": "Database error occurred.", "detail": "Error details..."}
    """
    try:
        cursor.execute(
            "DELETE FROM Missoes WHERE id_nave = %s AND id_missao = %s RETURNING id_missao",
            (id_nave, id_missao)
        )
        deleted = cursor.fetchone()
        conn.commit()
        if deleted:
            return jsonify({'message': 'Missão removida'})
        else:
            return jsonify({'error': 'Missão não encontrada'}), 404
    except psycopg2.Error as e:
        conn.rollback()
        app.logger.error(f"Database error occurred: {e}")
        return jsonify({'error': 'Database error occurred.', 'detail': str(e)},500), 500
    except Exception as e:
        conn.rollback()
        app.logger.error(f"Unexpected error occurred: {e}")
        return jsonify({'error': 'Unexpected server error occurred.', 'detail': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)

from flask import Flask, request, jsonify
from flask_cors import CORS
from flasgger import Swagger
from datetime import datetime
import psycopg2
import json

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
    try:
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS Naves (
                id_nave SERIAL PRIMARY KEY,
                nome VARCHAR(100) NOT NULL,
                tipo VARCHAR(50) NOT NULL,
                fabricante VARCHAR(100) NOT NULL,
                ano_construcao INT NOT NULL,
                status VARCHAR(30) NOT NULL
            );
        ''')

        cursor.execute('''
            CREATE TABLE IF NOT EXISTS Missoes (
                id_missao SERIAL PRIMARY KEY,
                id_nave INT REFERENCES Naves(id_nave) ON DELETE CASCADE,
                nome_missao VARCHAR(100) NOT NULL,
                data_lancamento DATE NOT NULL,
                destino VARCHAR(100) NOT NULL,
                duracao_dias INT NOT NULL,
                resultado VARCHAR(50) NOT NULL,
                descricao VARCHAR(255)
            );
        ''')

        cursor.execute('''
            CREATE TABLE IF NOT EXISTS Tripulantes (
                id_tripulante SERIAL PRIMARY KEY,
                id_nave INT REFERENCES Naves(id_nave) ON DELETE CASCADE,
                nome_tripulante VARCHAR(100) NOT NULL,
                data_de_nascimento DATE,
                genero VARCHAR(20),
                nacionalidade VARCHAR(50),
                competencia VARCHAR(100),
                data_ingresso DATE,
                status VARCHAR(30)
            );
        ''')

        conn.commit()
        print("🛠️ Tabelas criadas/verificadas com sucesso!")

    except Exception as e:
        print("❌ Erro na criação das tabelas:", e)

criar_tabelas()

# ===== ROTAS API =====

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
                        "ano": 1967,
                        "status": "Aposentada"
                    }
                ]
    """
    cursor.execute("SELECT * FROM naves")
    
    rows = cursor.fetchall()
    naves = [
        {'id_nave': r[0], 'nome': r[1], 'tipo': r[2], 'fabricante': r[3], 'ano_construcao': r[4], 'status': r[5]}
        for r in rows
    ]

    return jsonify(naves)

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
    data = request.json
    
    nome = data.get('nome')
    tipo = data.get('tipo')
    fabricante = data.get('fabricante')
    ano_construcao = data.get('ano_construcao')
    status_nave = data.get('status') # Renamed to avoid conflict with tripulante status

    if not all([nome, tipo, fabricante, ano_construcao, status_nave]):
        return jsonify({'error': 'Missing required nave fields: nome, tipo, fabricante, ano_construcao, status'}), 400

    missoes_data = data.get('missoes', [])
    tripulantes_data = data.get('tripulantes', [])

    # Convert mission and tripulante data to JSON strings for PostgreSQL
    missoes_json = json.dumps(missoes_data) if missoes_data else None
    tripulantes_json = json.dumps(tripulantes_data) if tripulantes_data else None

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
        return jsonify({'message': 'Nave adicionada com sucesso', 'id_nave': new_nave_id}), 201
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
    cursor.execute("DELETE FROM Naves WHERE id_nave = %s", (id,))
    conn.commit()
    return jsonify({'message': 'Nave removida'})

# ---- Tripulantes ----
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
    data = request.json
    cursor.execute("""
        INSERT INTO Tripulantes (id_nave, nome_tripulante, data_de_nascimento, genero, nacionalidade, competencia, data_ingresso, status)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """, (id_nave, data['nome_tripulante'], data.get('data_de_nascimento'), data.get('genero'),
          data.get('nacionalidade'), data.get('competencia'), data.get('data_ingresso'), data.get('status')))
    conn.commit()
    return jsonify({'message': 'Tripulante adicionado'})

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
    cursor.execute("SELECT * FROM Missoes WHERE id_nave = %s", (id_nave,))
    rows = cursor.fetchall()
    missoes = [
        {'id': r[0], 'nome': r[2], 'data': r[3].strftime('%Y-%m-%d'),
         'destino': r[4], 'duracao': r[5],
         'resultado': r[6], 'descricao': r[7]}
        for r in rows
    ]
    return jsonify(missoes)

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
    data = request.json
    cursor.execute("""
        INSERT INTO Missoes (id_nave, nome_missao, data_lancamento, destino, duracao_dias, resultado, descricao)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """, (id_nave, data['nome'], data['data'], data['destino'],
          data['duracao'], data['resultado'], data.get('descricao')))
    conn.commit()
    return jsonify({'message': 'Missão adicionada'})

@app.route('/missoes/<int:id>', methods=['DELETE'])
def delete_missao(id):
    """
    Remove uma missão pelo ID
    ---
    tags:
        - Missoes
    parameters:
    - in: path
      name: id
      type: integer
      required: true
      description: ID da missão a ser removida
    responses:
        200:
            description: Missão removida com sucesso
            examples:
                application/json: {"message": "Missão removida"}
    """
    cursor.execute("DELETE FROM Missoes WHERE id_missao = %s", (id,))
    conn.commit()
    return jsonify({'message': 'Missão removida'})

if __name__ == '__main__':
    app.run(debug=True)

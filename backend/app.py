from flask import Flask, request, jsonify
from flask_cors import CORS
from flasgger import Swagger
from datetime import datetime
import psycopg2

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
    password="123456"
)
cursor = conn.cursor()

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
                        "id": 1,
                        "nome": "Saturno V",
                        "tipo": "Foguete",
                        "fabricante": "NASA",
                        "ano": 1967,
                        "status": "Aposentada"
                    }
                ]
    """
    cursor.execute("SELECT * FROM Naves")
    rows = cursor.fetchall()
    naves = [
        {'id': r[0], 'nome': r[1], 'tipo': r[2], 'fabricante': r[3], 'ano': r[4], 'status': r[5]}
        for r in rows
    ]
    return jsonify(naves)

@app.route('/naves', methods=['POST'])
def add_nave():
    """
    Adiciona uma nova nave
    ---
    tags:      
    - Naves
    parameters:
      - in: body
        name: nave
        description: Dados da nave a ser adicionada
        required: true
        schema:
          type: object
          properties:
            nome:
              type: string
            tipo:
              type: string
            fabricante:
              type: string
            ano:
              type: integer
            status:
              type: string
    responses:
        200:
            description: Nave adicionada com sucesso
            examples:
                application/json: 
                    message: "Nave adicionada com sucesso"
    """
    data = request.json
    cursor.execute("""
        INSERT INTO Naves (nome, tipo, fabricante, ano_construcao, status)
        VALUES (%s, %s, %s, %s, %s)
    """, (data['nome'], data['tipo'], data['fabricante'], data['ano'], data['status']))
    conn.commit()
    return jsonify({'message': 'Nave adicionada com sucesso'})

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

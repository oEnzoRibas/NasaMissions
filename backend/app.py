from flask import Flask, request, jsonify
from flask_cors import CORS
import pyodbc
from flasgger import Swagger
from datetime import datetime

app = Flask(__name__)
app.config['SWAGGER'] = {
    'title': 'NASA API',
    'uiversion': 3
}
# 
CORS(app)
swagger = Swagger(app)


# 🔗 Conexão com PGSQL
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    database="NASA_Missions",
    user="enzo",
    password="123456"
)
cursor = conn.cursor()

# 🚀 Função para criar as tabelas se não existirem
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

        conn.commit()
        print("🛠️ Tabelas criadas/verificadas com sucesso!")

    except Exception as e:
        print("❌ Erro na criação das tabelas:", e)

# 🔥 Chamando a função de migration
criar_tabelas()

# =============================
# ======= ROTAS API ===========
# =============================

# # ---- Naves ----
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
        {'id': r.id_nave, 'nome': r.nome, 'tipo': r.tipo,
         'fabricante': r.fabricante, 'ano': r.ano_construcao, 'status': r.status}
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
        VALUES (?, ?, ?, ?, ?)
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
    cursor.execute("DELETE FROM Naves WHERE id_nave = ?", (id,))
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
            examples:
                application/json: [
                    {
                        "id_tripulante": 1,
                        "id_nave": 1,
                        "nome_tripulante": "Neil Armstrong",
                        "data_de_nascimento": "1930-08-05",
                        "genero": "Masculino",
                        "nacionalidade": "Americano",
                        "competencia": "Piloto",
                        "data_ingresso": "1962-09-17",
                        "status": "Ativo"
                    }
                    ]
    """
    cursor.execute("SELECT * FROM Tripulantes WHERE id_nave = ?", (id_nave))
    rows = cursor.fetchall()
    tripulantes = [
        {
            'competencia': r.competencia,
            'data_de_nascimento': r.data_de_nascimento.strftime('%Y-%m-%d') if r.data_de_nascimento else None,
            'genero': r.genero,
            'id_nave': r.id_nave,
            'id_tripulante': r.id_tripulante,
            'nacionalidade': r.nacionalidade,
            'nome_tripulante': r.nome_tripulante,
            'data_ingresso': r.data_ingresso.strftime('%Y-%m-%d') if r.data_ingresso else None,
            'status': r.status
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
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, (id_nave, data['nome_tripulante'], data['data_de_nascimento'],
          data['genero'], data['nacionalidade'], data['competencia'], data['data_ingresso'], data['status']))
    conn.commit()
    return jsonify({'message': 'Tripulante adicionado'})

# ---- Missoes ----
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
            examples:
                application/json: [
                    {
                        "id": 1,
                        "nome": "Apollo 11",
                        "data": "1969-07-16",
                        "destino": "Lua",
                        "duracao": 8,
                        "resultado": "Sucesso",
                        "descricao": "Primeiro pouso tripulado na Lua"
                    }
                ]
    """
    cursor.execute("SELECT * FROM Missoes WHERE id_nave = ?", (id_nave,))
    rows = cursor.fetchall()
    missoes = [
        {'id': r.id_missao, 'nome': r.nome_missao, 'data': r.data_lancamento.strftime('%Y-%m-%d'),
         'destino': r.destino, 'duracao': r.duracao_dias,
         'resultado': r.resultado, 'descricao': r.descricao}
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
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, (id_nave, data['nome'], data['data'], data['destino'],
          data['duracao'], data['resultado'], data['descricao']))
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
    cursor.execute("DELETE FROM Missoes WHERE id_missao = ?", (id,))
    conn.commit()
    return jsonify({'message': 'Missão removida'})

# =============================
# ========= RUN ===============
# =============================
if __name__ == '__main__':
    app.run(debug=True)

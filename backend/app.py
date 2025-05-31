from flask import Flask, request, jsonify
from flask_cors import CORS
import pyodbc

app = Flask(__name__)
CORS(app)

# 🔗 Conexão com SQL Server
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=localhost;'  # Ajuste conforme sua instância
    'DATABASE=NASA_Missions;'
    'Trusted_Connection=yes;'  # Ou mude para UID e PWD se usa login/senha
)
cursor = conn.cursor()

# 🚀 Função para criar as tabelas se não existirem
def criar_tabelas():
    try:
        # Cria tabela Naves
        cursor.execute('''
            IF NOT EXISTS (
                SELECT * FROM INFORMATION_SCHEMA.TABLES 
                WHERE TABLE_NAME = 'Naves'
            )
            BEGIN
                CREATE TABLE Naves (
                    id_nave INT PRIMARY KEY IDENTITY(1,1),
                    nome VARCHAR(100) NOT NULL,
                    tipo VARCHAR(50) NOT NULL,
                    fabricante VARCHAR(100) NOT NULL,
                    ano_construcao INT NOT NULL,
                    status VARCHAR(30) NOT NULL
                )
            END
        ''')

        # Cria tabela Missoes
        cursor.execute('''
            IF NOT EXISTS (
                SELECT * FROM INFORMATION_SCHEMA.TABLES 
                WHERE TABLE_NAME = 'Missoes'
            )
            BEGIN
                CREATE TABLE Missoes (
                    id_missao INT PRIMARY KEY IDENTITY(1,1),
                    id_nave INT FOREIGN KEY REFERENCES Naves(id_nave) ON DELETE CASCADE,
                    nome_missao VARCHAR(100) NOT NULL,
                    data_lancamento DATE NOT NULL,
                    destino VARCHAR(100) NOT NULL,
                    duracao_dias INT NOT NULL,
                    resultado VARCHAR(50) NOT NULL,
                    descricao VARCHAR(255)
                )
            END
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

# ---- Naves ----
@app.route('/naves', methods=['GET'])
def get_naves():
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
    data = request.json
    cursor.execute("""
        INSERT INTO Naves (nome, tipo, fabricante, ano_construcao, status)
        VALUES (?, ?, ?, ?, ?)
    """, (data['nome'], data['tipo'], data['fabricante'], data['ano'], data['status']))
    conn.commit()
    return jsonify({'message': 'Nave adicionada com sucesso'})

@app.route('/naves/<int:id>', methods=['DELETE'])
def delete_nave(id):
    cursor.execute("DELETE FROM Naves WHERE id_nave = ?", (id,))
    conn.commit()
    return jsonify({'message': 'Nave removida'})

# ---- Missoes ----
@app.route('/missoes/<int:id_nave>', methods=['GET'])
def get_missoes(id_nave):
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
    cursor.execute("DELETE FROM Missoes WHERE id_missao = ?", (id,))
    conn.commit()
    return jsonify({'message': 'Missão removida'})

# =============================
# ========= RUN ===============
# =============================
if __name__ == '__main__':
    app.run(debug=True)

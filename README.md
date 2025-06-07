# 🚀 NASA Mission Control

Gerenciamento de naves espaciais e suas missões!  
Projeto desenvolvido para a disciplina de Banco de Dados, utilizando SQL Server, Python (Flask) e React.

---

## 🌌 Funcionalidades

- 📦 CRUD de Naves Espaciais
- 🛰️ CRUD de Missões associadas às Naves
- 🎯 Interface no formato Mestre-Detalhe (Seleciona uma nave ➝ Visualiza suas missões)

---

## 🛠️ Tecnologias Utilizadas

- 🔹 **Backend:** Python + Flask + PyODBC
- 🔸 **Frontend:** React + Axios
- 🗄️ **Banco de Dados:** SQL Server
- 🔗 API REST conectando Frontend e Backend

---

## 🔥 Instalação e Execução

### ⚙️ Pré-requisitos

- ✔ Python 3.x instalado
- ✔ Node.js e npm instalados
- ✔ SQL Server instalado e rodando
- ✔ Driver ODBC para SQL Server ([Download aqui](https://learn.microsoft.com/sql/connect/odbc/download-odbc-driver-for-sql-server))

---

## 📄 Database Setup

This project requires a PostgreSQL database. For detailed instructions on how to set up the database, create the schema, and optionally seed data, please refer to the [Database Setup Guide](database/README.md).

Previously, this project used SQL Server. The original SQL Server script is no longer maintained but can be found in the project history if needed. The current setup uses PostgreSQL.

---

## 🐍 Backend (Python + Flask)
### 1. Instalação das Dependências

```bash
cd backend
pip install -r requirements.txt
```

### 🔸 Executando o backend:
```bash
cd backend
python app.py
```

---

## ⚛️ Frontend (React)
### 1. Instalação das Dependências

```bash
cd frontend
npm install
```
### 🔸 Executando o frontend:
```bash 
npm start
```
### 🔸 Acessando a aplicação:
Abra o navegador e acesse:
```
http://localhost:3000
```

---

## 🔗 API Endpoints

### 🚀 Naves
- `GET /naves` — Lista todas as naves
- `POST /naves` — Adiciona uma nova nave
- `DELETE /naves/{id}` — Remove uma nave

### 🛰️ Missões
- `GET /missoes/{id_nave}` — Lista missões de uma nave
- `POST /missoes/{id_nave}` — Adiciona uma missão
- `DELETE /missoes/{id}` — Remove uma missão


## 📚 Documentação
Para mais detalhes sobre a API, consulte a documentação gerada pelo Swagger:
```
http://localhost:5000/apidocs/
```

## 📑 Diagrama DER


>🌟 Missão dada, missão cumprida.
>⭐ Explore o universo dos bancos de dados!
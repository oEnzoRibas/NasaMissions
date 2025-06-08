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

- 📦 **Gerenciamento de dependências:** Utilize `pip install -r requirement.txt` para instalar as dependências do backend.

- 🔹 **Backend:** Python + Flask + PyODBC
- 🔸 **Frontend:** React + Axios
- 🗄️ **Banco de Dados:** PostgresSQL
- 🔗 API REST conectando Frontend e Backend

---

## 🔥 Instalação e Execução

### ⚙️ Pré-requisitos

- ✔ Python 3.x instalado
- ✔ Node.js e npm instalados
- ✔ PostgresSQL instalado e rodando

---

## 📄 Configuração do Banco de Dados

Este projeto requer um banco de dados PostgreSQL. Para instruções detalhadas sobre como configurar o banco, criar o schema e, opcionalmente, popular dados iniciais, consulte o [Guia de Configuração do Banco de Dados](database/README.md).

Anteriormente, este projeto utilizava SQL Server. O script original para SQL Server não é mais mantido, mas pode ser encontrado no histórico do projeto, se necessário. A configuração atual utiliza PostgreSQL.

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
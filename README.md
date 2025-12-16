# CU_PLUS_WEBAPP

RECOMMENDED TOOLS:

Chat-gpt

Visual Studio Code (for text-editing)
    - Extra Extension in vs code
        * Prettier (To make code style the same for everyone)

        * GitHub Copilot (for code assistant)

        * Indent-rainbow (read indentation easier)


Git & GitHub (GUI or terminal version)

JIRA (To track tasks)


CLONE BOTH REPO INTO ONE FOLDER
FOR EXAMPLE:

    mkdir CU_PROJECT
    git clone https://github.com/TBoggs05/CU_PLUS_WEBAPP.git

    git clone https://github.com/TBoggs05/CU_PLUS_WEBAPP_BACKEND.git


Naming Rules:
just follow other files, codes, folders structure


FOR MAC
1.  PostgresSQL

    Install PostgreSQL (through homebrew, I used PostgreSQL v.17)

    Extra guides: 
    (Using Terminal)
    brew install postgresql@17
    psql --version
    brew services start postgresql@17

    (if psql command not found common on macOS)
    echo 'export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"' >> ~/.zshrc

    source ~/.zshrc
    
    psql --version

    (create a database in Terminal)
    createdb cu_plus
    (confirm it exists)
    psql -l


2.  NodeJs

    A. Initialize Node project 
        cd CU_PLUS_WEBAPP_BACKEND
        npm init -y

    B. Install core dependencies
        npm i express cors dotenv
        npm i -D nodemon

    C. Add Prisma + Postgres driver
        npm i prisma @prisma/client pg
        npx prisma init

    D. Set your DATABASE_URL
        Open CU_PLUS_WEBAPP_BACKEND/.env and set:
        
        DATABASE_URL="postgresql://YOUR_MAC_USERNAME@localhost:5432/cu_plus?schema=public"
        PORT=4000

        To get your Mac username (In terminal):
        whoami

    E. (Optional) open Prisma Studio:
        npx prisma studio

    F. Running node js
        cd CU_PLUS_WEBAPP_BACKEND
        npm run dev


3.  Create first dummy account
    In terminal:

    curl -X POST http://localhost:4000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@student.edu","password":"password123","name":"Test Student"}'
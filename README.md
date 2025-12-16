# CU_PLUS_WEBAPP

A Flutter web and mobile application used by the CU project. This repository contains the Flutter frontend for the CU_PLUS_WEBAPP system. The backend lives in a separate repository named `CU_PLUS_WEBAPP_BACKEND`.

## Table of Contents
- [Recommended Tools](#recommended-tools)
- [Repository Setup](#repository-setup)
- [Naming Rules](#naming-rules)
- [Backend Setup (macOS)](#backend-setup-macos)
- [Create a Dummy Account](#create-a-dummy-account)

## Recommended Tools

- **Visual Studio Code** — recommended extensions: Prettier, GitHub Copilot, Indent Rainbow
- **Git & GitHub** — CLI or GUI
# CU_PLUS_WEBAPP

A Flutter web and mobile application used by the CU project. This repository contains the Flutter frontend for the CU_PLUS_WEBAPP system. The backend lives in a separate repository named `CU_PLUS_WEBAPP_BACKEND`.

## Table of Contents
- [Recommended Tools](#recommended-tools)
- [Repository Setup](#repository-setup)
- [Naming Rules](#naming-rules)
- [Backend Setup (macOS)](#backend-setup-macos)
- [Backend Setup (Windows)](#backend-setup-windows)
- [Create a Dummy Account](#create-a-dummy-account)

## Recommended Tools

- **Visual Studio Code** — recommended extensions: Prettier, GitHub Copilot, Indent Rainbow
- **Git & GitHub** — CLI or GUI
- **JIRA** — task tracking and sprint planning
- **ChatGPT** — debugging, explanations, and learning support

## Repository Setup

⚠️ **IMPORTANT:**  
Clone BOTH repositories into the **same parent folder**.

Example:

```bash
mkdir CU_PROJECT
cd CU_PROJECT

git clone https://github.com/TBoggs05/CU_PLUS_WEBAPP.git
git clone https://github.com/TBoggs05/CU_PLUS_WEBAPP_BACKEND.git
```

Expected layout:

```
CU_PROJECT/
├── CU_PLUS_WEBAPP
└── CU_PLUS_WEBAPP_BACKEND
```

## Naming Rules

- Follow existing file and folder naming conventions
- Do NOT rename files or folders without team discussion
- Dart files: snake_case
- Class names: PascalCase

## Backend Setup (macOS)

This project uses Node.js + PostgreSQL + Prisma for the backend. Those instructions belong in the `CU_PLUS_WEBAPP_BACKEND` repo, but are reproduced here for convenience.

1) Install PostgreSQL (Homebrew example)

```bash
brew install postgresql@17
brew services start postgresql@17
psql --version
```

If `psql` is not found on macOS (Apple Silicon), add the Homebrew binary path and reload your shell:

```bash
echo 'export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Create the database:

```bash
createdb cu_plus
psql -l
```

2) Backend (Node.js + Prisma)

```bash
cd CU_PLUS_WEBAPP_BACKEND
npm init -y
npm i express cors dotenv
npm i -D nodemon
npm i prisma @prisma/client pg
npx prisma init
```

3) Configure `.env`

Open `CU_PLUS_WEBAPP_BACKEND/.env` and set:

```
DATABASE_URL="postgresql://YOUR_MAC_USERNAME@localhost:5432/cu_plus?schema=public"
PORT=4000
```

To get your macOS username:

```bash
whoami
```

4) (Optional) Open Prisma Studio

```bash
npx prisma studio
```

5) Run the backend

```bash
cd CU_PLUS_WEBAPP_BACKEND
npm run dev
```

## Backend Setup (Windows)

These instructions mirror the macOS steps but target Windows environments (PowerShell, Command Prompt, or Git Bash). Install PostgreSQL via the official Windows installer or using Chocolatey if you prefer.

1) Install PostgreSQL

- Option A — Official installer: download and run the installer from the PostgreSQL website and follow the prompts (choose a password for the `postgres` user).
- Option B — Chocolatey (PowerShell as Admin):

```powershell
choco install postgresql
```

After installation, ensure `psql` is on your PATH and check the version:

```powershell
psql --version
```

Create the database:

```powershell
createdb cu_plus
psql -l
```

If `createdb` is not available in your shell, open the `psql` shell and run:

```sql
CREATE DATABASE cu_plus;
\l
```

2) Backend (Node.js + Prisma)

Install Node.js (from nodejs.org or using nvm for Windows). Then run the same backend setup commands from the `CU_PLUS_WEBAPP_BACKEND` folder:

```powershell
cd CU_PLUS_WEBAPP_BACKEND
npm init -y
npm i express cors dotenv
npm i -D nodemon
npm i prisma @prisma/client pg
npx prisma init
```

3) Configure `.env`

Open `CU_PLUS_WEBAPP_BACKEND/.env` and set (include the DB user and password you created during Postgres installation):

```
DATABASE_URL="postgresql://postgres:YOUR_DB_PASSWORD@localhost:5432/cu_plus?schema=public"
PORT=4000
```

4) Run migrations and (optional) Prisma Studio

```powershell
npx prisma migrate dev --name init
npx prisma studio
```

5) Run the backend

```powershell
cd CU_PLUS_WEBAPP_BACKEND
npm run dev
```

## Create a Dummy Account

To create an initial test user you can use Git Bash or macOS-style curl, or PowerShell's web cmdlets.

- Git Bash / POSIX curl:

```bash
curl -X POST http://localhost:4000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@student.edu","password":"password123","name":"Test Student"}'
```

- PowerShell (Invoke-RestMethod):

```powershell
Invoke-RestMethod -Method POST -Uri http://localhost:4000/auth/register -ContentType 'application/json' -Body '{"email":"test@student.edu","password":"password123","name":"Test Student"}'
```
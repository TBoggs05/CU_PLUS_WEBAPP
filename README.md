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
- **JIRA** — task tracking and sprint planning
- **ChatGPT** — debugging, explanations, and learning support

## Repository Setup

Important: clone both frontend and backend repositories into the same parent folder.

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

## Create a Dummy Account

To create an initial test user (example curl):

```bash
curl -X POST http://localhost:4000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@student.edu","password":"password123","name":"Test Student"}'
```

---

If you'd like, I can:

- add badges (build, license)
- link to the backend README
- add instructions for running the Flutter app locally

Tell me which of those you'd like next.
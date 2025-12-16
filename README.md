# CU_PLUS_WEBAPP

## Table of Contents
- [Recommended Tools](#recommended-tools)
- [Install Flutter (macOS)](#install-flutter-macos)
- [Install Flutter (Windows)](#install-flutter-windows)
- [Repository Setup](#repository-setup)
- [Running the App](#running-the-app)
- [Naming Rules](#naming-rules)
- [Troubleshooting](#troubleshooting)

## Overview
This repository hosts only the Flutter frontend. Backend setup and API docs now live in `CU_PLUS_WEBAPP_BACKEND/README.md`.

## Recommended Tools

- **Visual Studio Code** — recommended extensions: Prettier, GitHub Copilot, Indent Rainbow
- **Git & GitHub** — CLI or GUI
- **JIRA** — task tracking and sprint planning
- **ChatGPT** — debugging, explanations, and learning support

## Install Flutter (macOS)

1. Install Homebrew if missing:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install Flutter via `brew`:
   ```bash
   brew install --cask flutter
   ```

3. Add Flutter to PATH (Apple Silicon default):
   ```bash
   echo 'export PATH="$PATH:/opt/homebrew/Caskroom/flutter/latest/flutter/bin"' >> ~/.zshrc
   source ~/.zshrc
   ```

4. Run Flutter Doctor:
   ```bash
   flutter doctor
   ```

Follow doctor’s guidance for missing Xcode/iOS/Android tooling.

## Install Flutter (Windows)

1. Download the Windows Flutter SDK (zip) from [flutter.dev](https://docs.flutter.dev/get-started/install/windows) and extract to `C:\src\flutter`.
2. Add `C:\src\flutter\bin` to your PATH:
   - Start → “Edit the system environment variables” → Environment Variables → Path → New → `C:\src\flutter\bin`
3. Enable execution policy if needed (PowerShell as Admin):
   ```powershell
   Set-ExecutionPolicy RemoteSigned
   ```
4. Run Flutter Doctor:
   ```powershell
   flutter doctor
   ```

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

## Running the App

  ```bash
  flutter run
  ```

## Naming Rules

- Follow existing file and folder naming conventions
- Do NOT rename files or folders without team discussion
- Dart files: snake_case
- Class names: PascalCase

## Troubleshooting

- Run `flutter doctor -v` and resolve outstanding issues.
- Delete `pubspec.lock` and rerun `flutter pub get` if dependencies glitch.
- `flutter clean && flutter pub get` can resolve caching issues.
- For platform-specific build errors, open the platform project (`ios/Runner.xcworkspace` or `android/`) in the native IDE and check logs.

---
# CU_PLUS_WEBAPP

## Table of Contents
- [Recommended Tools](#recommended-tools)
- [Install Flutter (macOS)](#install-flutter-macos)
- [Install Flutter (Windows)](#install-flutter-windows)
- [Repository Setup](#repository-setup)
- [Running the App](#running-the-app)
- [Naming Rules](#naming-rules)
- [Troubleshooting](#troubleshooting)
- [Folder Structure](#frontend-structure)
- [How to create add your own features](#frontend-structure)
- [Adding more images or other assets](#quick-tips)


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

## Frontend Structure

```
CU_PLUS_WEBAPP/
├── lib/
│   ├── core/
│   │   ├── config/            # Global constants (API base URLs, themes, etc.)
│   │   └── network/           # ApiClient and shared HTTP helpers
│   ├── features/
│   │   └── auth/
│   │       ├── api/           # API wrappers (e.g., auth_api.dart)
│   │       └── ui/            # Screens/widgets (LoginPage, HomePage, etc.)
│   └── main.dart              # App entry point
├── assets/                    # Images, icons, fonts
├── pubspec.yaml               # Dependencies and asset declarations
└── README.md
```

### Add More API Calls
- Create a new api method inside the relevant `features/<feature>/api/*.dart` file.
- Use `ApiClient` from `lib/core/network/api_client.dart` to keep authentication headers and base URLs consistent.
- Keep feature-specific logic inside its folder; don’t mix unrelated APIs into `auth_api.dart`.

### Add New UI Pages
- Create a widget file inside `features/<feature>/ui/`, following the existing naming convention (e.g., `settings_page.dart`).
- Wire navigation from the appropriate screen using `Navigator.push`/`pushReplacement`.
- Share common widgets via a dedicated `widgets/` subfolder if a feature grows.

### Quick Tips
- Register new features by importing them in `main.dart` or the relevant coordinator widget.
- Update `assets/` and `pubspec.yaml` when you add images or fonts.
- Keep each feature self-contained: `data` → API, `models` → payloads, `ui` → screens.

### Adding New Features (e.g., Dashboard)

Create a new folder under `lib/features/` for each feature. For a dashboard, use `lib/features/dashboard/` with its own `api/`, and `ui/` subdirectories. Keep authentication-specific screens in `features/auth/` and place dashboard pages in `features/dashboard/ui/`. This keeps APIs, models, and widgets scoped to their feature and makes future maintenance much easier.


---
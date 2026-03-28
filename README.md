# HDFC DesignKit Playground

An interactive, browser-based component explorer for the [HDFC DesignKit](https://github.com/Assam-Internship-2025-2026-BS5/designkit), built during the Assam Internship Programme 2025–2026 (Batch BS5).

---

## What is this?

Playground is a Flutter web app that lets you browse, configure, and preview every DesignKit component in real time. It has three panels:

- **Left** — component list grouped by category (Pages, Atoms, Molecules, Organisms) with search
- **Centre** — live preview of the selected component
- **Right** — property controls (sliders, colour pickers, toggles, text inputs) that update the preview instantly, plus a **View Code** tab that generates copy-ready Dart code

---

## Components in the Playground

| Category | Components |
|---|---|
| Pages | HomePage |
| Atoms | Button, Text, Icon, Image, Checkbox, TextButton, Primary Button |
| Molecules | QR Scan, ActionItems |
| Organisms | AppHeader, AuthSection, BottomNav |

---

## Run Locally

```bash
# Clone the repo
git clone https://github.com/Assam-Internship-2025-2026-BS5/playground.git
cd playground

# Install dependencies
flutter pub get

# Run in Chrome
flutter run -d chrome

# Or run on any connected device
flutter run
```

---

## Build for Web

```bash
flutter build web
# Output: build/web/
```

---

## Docker

```bash
# Build the image
docker build -t playground .

# Run locally
docker run -p 8080:80 playground
# Open http://localhost:8080
```

---

## Project Structure

```
lib/
├── main.dart                 ← app entry point
├── playground_screen.dart    ← three-panel UI
├── component_registry.dart   ← all components registered here
└── component_metadata.dart   ← ComponentMetadata class

assets/                       ← shared images
web/                          ← Flutter web entry point
Dockerfile                    ← multi-stage build (Flutter → Nginx)
nginx.conf                    ← web server config
```

---

## Adding a New Component

Open `component_registry.dart` and add an entry to the `componentRegistry` list:

```dart
ComponentMetadata(
  name: 'MyComponent',
  category: 'Atoms',            // Atoms | Molecules | Organisms | Pages
  defaultProps: {
    'text': 'Hello',
    'fontSize': 20.0,
    'enabled': true,
  },
  builder: (props, {onPropChanged}) {
    return MyComponent(
      text: props['text'] ?? 'Hello',
      fontSize: (props['fontSize'] as num?)?.toDouble() ?? 20.0,
      enabled: props['enabled'] ?? true,
    );
  },
  codeBuilder: (props) {
    return "MyComponent(\n"
        "  text: '${props['text']}',\n"
        "  fontSize: ${props['fontSize']},\n"
        ")";
  },
),
```

That's it — the sidebar, preview, property panel, and code tab all update automatically.

---

## Built With

- [Flutter](https://flutter.dev) — stable channel, web target
- Dart 3.x (null-safe)
- [Docker](https://docker.com) — Nginx Alpine serving the web build
- GitHub Actions — CI/CD and security scanning

---

*Assam Internship Programme 2025–2026 · Batch BS5 · HDFC Bank*
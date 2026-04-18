# CosmoNet Reader
**Lettore PDF open source, senza pubblicità — by [cosmonet.info](https://www.cosmonet.info)**

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Funzionalità v1.0
- 📄 Apri qualsiasi PDF dal dispositivo
- 🕐 Cronologia file recenti (20 file, con swipe per rimuovere)
- 📖 Navigazione pagine con frecce + barra di avanzamento
- 🔍 Pinch-to-zoom nativo
- 🌙 Tema scuro con branding CosmoNet
- 💬 "Vai a pagina" tap sul counter
- 📤 Android: accetta PDF da "Apri con..." di altri app

---

## Stack
| Libreria | Uso |
|---|---|
| `pdfx` | Rendering PDF nativo multi-platform |
| `file_picker` | Selezione file da storage |
| `shared_preferences` | Cronologia recenti |
| `path` | Gestione percorsi file |

---

## Build

### Prerequisiti
```bash
flutter --version   # >= 3.3.0
flutter doctor      # tutto verde
```

### Android (APK debug)
```bash
flutter build apk --debug
# output: build/app/outputs/flutter-apk/app-debug.apk
```

### Android (APK release)
```bash
flutter build apk --release --split-per-abi
# output: build/app/outputs/flutter-apk/
#   app-arm64-v8a-release.apk  ← usa questo per dispositivi moderni
#   app-armeabi-v7a-release.apk
#   app-x86_64-release.apk
```

### Android (AAB per Play Store)
```bash
flutter build appbundle --release
```

### Windows
```bash
flutter build windows
# output: build/windows/x64/runner/Release/
```

### Linux
```bash
flutter build linux
# output: build/linux/x64/release/bundle/
```

### macOS
```bash
flutter build macos
```

---

## Installazione Android (sideload)
1. Abilita **"Origini sconosciute"** in Impostazioni → Sicurezza
2. Copia `app-arm64-v8a-release.apk` sul telefono
3. Tocca il file → Installa

---

## Roadmap futura
- [ ] Segnalibri per pagina
- [ ] Evidenziatore testo
- [ ] Ricerca nel testo (Ctrl+F)
- [ ] Modalità doppia pagina (tablet/landscape)
- [ ] Condivisione PDF
- [ ] iOS support

---

## Struttura progetto
```
cosmonet_reader/
├── lib/
│   ├── main.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── pdf_viewer_screen.dart
│   ├── services/
│   │   └── recent_files_service.dart
│   └── widgets/
│       └── cosmonet_logo.dart
├── android/
│   └── app/src/main/AndroidManifest.xml
└── pubspec.yaml
```

---

MIT License — cosmonet.info

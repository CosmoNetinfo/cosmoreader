# BRIEF — CosmoNet Reader v2.0
## Lettore PDF professionale per Android (APK) + Windows | by cosmonet.info
### Tool: Google Antigravity (agent-first IDE)

> **ISTRUZIONI PER ANTIGRAVITY:** Sei un senior Flutter developer.  
> Questo brief è la tua unica specifica. Costruisci tutto dall'inizio.  
> Produci **tutti i file completi**, mai patch parziali.  
> L'app è **completamente offline e standalone**: nessuna API esterna, nessun account, nessun tracking.  
> Segui ogni punto nell'ordine indicato nella sezione 12.

---

## 1. IDENTITÀ DEL PROGETTO

| Campo | Valore |
|---|---|
| **Nome app** | CosmoNet Reader |
| **Tagline** | Leggi PDF come si deve. Senza pubblicità. |
| **Owner** | DanyWolf — cosmonet.info |
| **Repo GitHub** | https://github.com/CosmoNetinfo/cosmoreader |
| **Versione target** | 2.0.0+1 |
| **Piattaforme** | Android (APK sideload + Play Store ready) · Windows (installer .exe) |
| **NON includere** | iOS, macOS, Linux (futura milestone) |
| **Lingua UI** | Italiano (tutte le stringhe visibili all'utente) |
| **Licenza** | MIT |

**PUNTO CRITICO — App 100% offline:**
- Zero API esterne
- Zero account utente, zero login
- Zero analytics, zero tracking
- Zero pubblicità di qualsiasi tipo
- Tutto gira localmente sul dispositivo dell'utente

---

## 2. PRIMA DI SCRIVERE CODICE — Reset del progetto

Il progetto esistente ha una struttura v1.0 da sostituire completamente.
Esegui questi comandi nella root della repo prima di iniziare:

```bash
# Elimina il vecchio codice Dart
rm -rf lib/

# Ricrea la struttura base
mkdir -p lib/theme lib/models lib/services lib/screens \
         lib/widgets/viewer lib/widgets/common lib/utils

# Aggiorna pubspec.yaml con le dipendenze della sezione 2
# Lascia intatte le cartelle: android/ windows/ assets/ .git/
```

Poi riscrivi tutto secondo questo brief.

---

## 3. STACK TECNICO

### Flutter SDK
```yaml
environment:
  sdk: '>=3.3.0 <4.0.0'
```

### pubspec.yaml completo
```yaml
name: cosmonet_reader
description: CosmoNet Reader — Lettore PDF professionale, senza pubblicità, by cosmonet.info
publish_to: 'none'
version: 2.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # Rendering PDF
  pdfx: ^2.6.0

  # File system
  file_picker: ^8.1.0
  path: ^1.9.0
  path_provider: ^2.1.4

  # Storage locale (tutto offline, niente Firebase o cloud)
  shared_preferences: ^2.3.2
  sqflite: ^2.3.3+1
  sqflite_common_ffi: ^2.3.4        # SQLite su Windows

  # UI / UX
  flutter_animate: ^4.5.0
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10+1

  # Funzionalità
  share_plus: ^10.0.2
  printing: ^5.13.2
  url_launcher: ^6.3.0
  package_info_plus: ^8.1.1
  crypto: ^3.0.3

  # Permessi Android
  permission_handler: ^11.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  flutter_launcher_icons: ^0.13.1

flutter:
  uses-material-design: true
  assets:
    - assets/

flutter_launcher_icons:
  android: "launcher_icon"
  ios: false
  image_path: "assets/icon.png"
  windows:
    generate: true
    image_path: "assets/icon.png"
    icon_size: 256
```

---

## 4. PALETTE COLORI — CosmoNet Brand

Usa **esattamente** questi valori HEX in tutta l'app. Mai altri colori non in questa lista.

```dart
// lib/theme/cosmonet_colors.dart

import 'package:flutter/material.dart';

class CosmonetColors {
  // Sfondi
  static const Color bgPrimary    = Color(0xFF0D0D1A);  // Sfondo principale
  static const Color bgSecondary  = Color(0xFF13132B);  // Card e drawer
  static const Color bgElevated   = Color(0xFF1A1A3A);  // Toolbar e modali
  static const Color bgSurface    = Color(0xFF22224A);  // Input e chip

  // Accenti principali CosmoNet
  static const Color accentBlue   = Color(0xFF4A9EFF);  // CTA primari
  static const Color accentPurple = Color(0xFF7C5CBF);  // Elementi secondari
  static const Color accentCyan   = Color(0xFF00D4FF);  // Highlights attivi

  // Testo
  static const Color textPrimary  = Color(0xFFE8E8FF);  // Testo principale
  static const Color textSecondary= Color(0xFF8888BB);  // Testo secondario
  static const Color textDisabled = Color(0xFF44445A);  // Disabilitato

  // Funzionali
  static const Color success      = Color(0xFF4CAF82);  // Conferma
  static const Color warning      = Color(0xFFFFB347);  // Avviso
  static const Color error        = Color(0xFFFF4D6D);  // Errore
  static const Color divider      = Color(0xFF2A2A5A);  // Bordi e divisori

  // Evidenziatori (per annotazioni)
  static const Color highlightYellow = Color(0xFFFFEB3B);
  static const Color highlightGreen  = Color(0xFF81C784);
  static const Color highlightCyan   = Color(0xFF4DD0E1);
  static const Color highlightPink   = Color(0xFFF48FB1);
}
```

---

## 5. TIPOGRAFIA

```dart
// Titoli → Exo 2 (tech, si adatta al brand CosmoNet)
// Corpo e UI → Fira Sans (leggibilità su schermi piccoli)
// Numeri e shortcut → JetBrains Mono

// In app_theme.dart usa GoogleFonts:
// GoogleFonts.exoTwo()     → display, titoli, header
// GoogleFonts.firaSans()   → body, label, bottoni
// GoogleFonts.jetBrainsMono() → numeri pagina, scorciatoie
```

---

## 6. STRUTTURA CARTELLE COMPLETA

```
lib/
├── main.dart
├── app.dart                          # MaterialApp, routing, theme
│
├── theme/
│   ├── cosmonet_colors.dart          # Palette HEX (sezione 4)
│   ├── app_theme.dart                # ThemeData Material 3
│   └── text_styles.dart              # Stili testo riutilizzabili
│
├── models/
│   ├── recent_file.dart              # File recente (path, nome, pagine, progresso)
│   ├── bookmark.dart                 # Segnalibro (filePath, pageNumber, date, note)
│   ├── annotation.dart               # Annotazione (highlight, nota, disegno)
│   └── pdf_document_info.dart        # Metadata PDF (titolo, autore, pagine, ecc.)
│
├── services/
│   ├── database_service.dart         # Init SQLite + migrations (avvia per primo)
│   ├── recent_files_service.dart     # Cronologia 30 file (SharedPreferences)
│   ├── bookmark_service.dart         # CRUD segnalibri (SQLite)
│   ├── annotation_service.dart       # CRUD annotazioni (SQLite)
│   ├── reading_state_service.dart    # Salva/carica ultima pagina per file
│   └── search_service.dart           # Ricerca testo nel PDF
│
├── screens/
│   ├── home_screen.dart              # Home: recenti + apertura file
│   ├── pdf_viewer_screen.dart        # Schermata lettura principale
│   └── settings_screen.dart          # Preferenze utente
│
├── widgets/
│   ├── cosmonet_logo.dart            # Logo animato SVG
│   ├── recent_file_card.dart         # Card file recente con progresso
│   ├── empty_state.dart              # Stato vuoto (nessun file recente)
│   ├── viewer/
│   │   ├── viewer_toolbar.dart       # AppBar custom con auto-hide
│   │   ├── viewer_bottom_bar.dart    # Barra pagina + slider + frecce
│   │   ├── thumbnail_drawer.dart     # Drawer miniature pagine
│   │   ├── bookmarks_panel.dart      # Pannello segnalibri
│   │   ├── search_bar_overlay.dart   # Overlay ricerca testo
│   │   ├── annotation_toolbar.dart   # Toolbar annotazioni
│   │   ├── document_outline.dart     # Indice/sommario PDF
│   │   └── document_info_sheet.dart  # Metadata documento
│   └── common/
│       ├── cosmonet_button.dart      # Bottone brand
│       └── loading_overlay.dart      # Overlay caricamento con logo pulsante
│
└── utils/
    ├── file_utils.dart               # Dimensione file, formattazione
    ├── page_utils.dart               # "Pag. 3 di 45"
    └── shortcut_intents.dart         # Keyboard shortcuts Windows
```

---

## 7. DATABASE SQLite — SCHEMA COMPLETO

```dart
// lib/services/database_service.dart
// Questo service va inizializzato in main.dart prima di tutto il resto.

// Su Android usa sqflite normale.
// Su Windows usa sqflite_common_ffi con databaseFactoryFfi.

const String _createBookmarks = '''
  CREATE TABLE IF NOT EXISTS bookmarks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT NOT NULL,
    page_number INTEGER NOT NULL,
    created_at TEXT NOT NULL,
    note TEXT DEFAULT ''
  );
''';

const String _createAnnotations = '''
  CREATE TABLE IF NOT EXISTS annotations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path TEXT NOT NULL,
    page_number INTEGER NOT NULL,
    type TEXT NOT NULL,       -- 'highlight' | 'note' | 'drawing'
    data TEXT NOT NULL,       -- JSON: {x, y, width, height, text, color, points}
    color TEXT NOT NULL,
    created_at TEXT NOT NULL
  );
''';
```

---

## 8. SCHERMATE — SPECIFICHE UI

---

### 8.1 HOME SCREEN

**Layout:**
- Sfondo: `bgPrimary`
- AppBar: logo CosmoNet SVG a sinistra + "CosmoNet Reader" (Exo 2 bold) + icona impostazioni a destra

**Zona apertura file:**
```
┌─────────────────────────────────────────────────┐
│  Su Windows: zona drag & drop con bordo          │
│  tratteggiato animato (pulse glow accentBlue)     │
│                                                   │
│         📄  Trascina un PDF qui                  │
│              — oppure —                           │
│         [  📂 Apri PDF  ]                        │
└─────────────────────────────────────────────────┘
```
- Su Android: mostra solo il bottone "Apri PDF" (no drag&drop)
- Su Windows: gestisce DragTarget con DropRegion

**Lista file recenti:**
- Intestazione "File recenti" (Exo 2, textSecondary)
- ListView con `RecentFileCard` per ogni file (max 30)
- Swipe-to-delete con sfondo rosso + icona cestino
- Se lista vuota: `EmptyState` con icona large + "Apri il tuo primo PDF"

**RecentFileCard:**
```
┌──────────────────────────────────────────────────┐
│ 🔴  nome_documento.pdf               3 min fa    │
│     /storage/Documenti       •   2,4 MB          │
│     ████████████░░░░░░░░     Pag. 12 / 84       │
└──────────────────────────────────────────────────┘
```
- Sfondo card: `bgSecondary`, bordo radius 12
- Barra progresso: `accentBlue`
- Tap → apre PDF alla pagina salvata (resume)
- Long press → BottomSheet: [Apri] [Rimuovi dai recenti] [Mostra cartella]

---

### 8.2 PDF VIEWER SCREEN — Stack a strati

```
Stack:
  [1] PdfView o PdfPageView (corpo)
  [2] ViewerToolbar (auto-hide dopo 2s)
  [3] ViewerBottomBar (auto-hide dopo 2s)
  [4] SearchBarOverlay (visibile solo in ricerca)
  [5] AnnotationToolbar (visibile solo in annotazione)
  [6] LoadingOverlay (durante apertura)
```

**ViewerToolbar:**
```
[←]  nome_file.pdf                [🔍][🔖][📋][⋮]
```
- `←` → torna alla Home
- `🔍` → attiva SearchBarOverlay
- `🔖` → apre BookmarksPanel (Drawer destro)
- `📋` → apre DocumentOutline (Drawer sinistro)
- `⋮` → menu con: Condividi, Stampa, Info documento, Miniature pagine, Modalità presentazione

**Auto-hide toolbar:**  
- Dopo 2 secondi di inattività, toolbar e bottom bar scivolano fuori schermo (AnimatedSlide, 200ms)
- Tap sul documento → riappaiono

**ViewerBottomBar:**
```
[◀]  [Slider ────────●──────────]  [▶]   Pag. 12 / 84
```
- Tap sul contatore → dialog "Vai a pagina" (campo numerico)
- Slider con thumb colore `accentBlue`

**Modalità visualizzazione (dal menu ⋮):**
- `Pagina singola` (default) — swipe orizzontale
- `Scorrimento continuo` — ListView verticale
- `Doppia pagina` — automatica in landscape width > 600dp

**Zoom:**
- Pinch-to-zoom nativo (pdfx)
- Doppio tap → 125% → doppio tap → reset 100%
- Windows: Ctrl+Scroll, Ctrl+0 reset, Ctrl+Plus/Minus

---

## 9. FEATURE AVANZATE DEL VIEWER

### A) RICERCA TESTO
```
┌───────────────────────────────────────────────────┐
│ [X]  [ 🔍 Cerca nel documento...    ]  [↑][↓]    │
│       "flutter"                3 di 12 risultati  │
└───────────────────────────────────────────────────┘
```
- Ricerca case-insensitive senza accenti
- Navigazione risultati con frecce su/giù
- Salta automaticamente alla pagina con il match
- PDF senza testo estraibile: "Documento non ricercabile (PDF scansionato)"
- Chiusura: [X] o ESC (Windows)

### B) SEGNALIBRI
- Icona bookmark nella toolbar: outline se non segnata, filled giallo se segnata
- Tap → aggiunge/rimuove con animazione (scale 1.0→1.3→1.0)
- BookmarksPanel (Drawer destro):
  - Lista segnalibri del PDF corrente
  - Ogni voce: miniatura pagina + numero pagina + data
  - Tap → naviga alla pagina
  - Long press → elimina
  - Bottone "Elimina tutti" in basso

### C) ANNOTAZIONI
Attivazione: menu ⋮ → "Modalità annotazione" → compare `AnnotationToolbar` sotto la AppBar.

**Strumenti:**
- **Evidenziatore** — 4 colori selezionabili (giallo, verde, ciano, rosa)
- **Nota adesiva** — tap sul documento → dialog con campo testo → icona nota visibile sulla pagina
- **Matita libera** — disegno a mano libera sopra la pagina (Canvas trasparente)

Le annotazioni appaiono come overlay sopra la pagina PDF. Persistono su SQLite.

### D) SOMMARIO DOCUMENTO
- Drawer sinistro (280dp)
- Se il PDF ha outline nativo (pdfx): lista gerarchica capitoli
- Tap voce → vai alla pagina
- Senza outline: "Questo documento non ha un indice"

### E) MINIATURE PAGINE
- Attivazione: menu ⋮ → "Miniature pagine"
- Grid 2 colonne con lazy loading
- Pagina corrente: bordo `accentBlue` + glow
- Tap → naviga alla pagina

### F) INFO DOCUMENTO
- BottomSheet da menu ⋮ → "Informazioni documento"
- Mostra: Nome file, Percorso, Dimensione, Pagine, Titolo PDF, Autore, Creatore, Date
- Bottone "Copia tutto" → copia negli appunti

### G) RESUME LETTURA
- All'uscita dal viewer: salva pagina corrente (chiave: sha256 del path)
- Alla riapertura: dialog "Riprendi da pag. X?" → [Sì] [No, inizia dall'inizio]
- Configurabile: resume silenzioso (senza dialog) nelle impostazioni

### H) CONDIVISIONE E STAMPA
- Condividi: share_plus → share sheet nativo Android, clipboard su Windows
- Stampa: printing → dialog stampa nativa

### I) MODALITÀ PRESENTAZIONE (full screen)
- Menu ⋮ → "Presentazione"
- Nasconde toolbar, bottom bar, status bar di sistema
- Solo PDF a schermo intero
- Tap → esce dalla modalità

---

## 10. SETTINGS SCREEN

**Sezioni:**

**Visualizzazione**
- Modalità default (Pagina singola / Continuo / Doppia pagina)
- Mantieni schermo acceso durante lettura (WakeLock)

**Lettura**
- Resume automatico ON/OFF
- Mostra dialog "Riprendi?" ON/OFF (se OFF, riprende in silenzio)

**Cronologia**
- Max file recenti: slider 5–50 (default 30)
- Pulsante "Cancella cronologia"

**Informazioni**
- Versione app (da package_info_plus)
- "Visita cosmonet.info" → url_launcher
- "Sorgente GitHub" → link alla repo
- "Licenza MIT"

---

## 11. KEYBOARD SHORTCUTS (Windows only)

Implementa con `Shortcuts` + `Actions` di Flutter in `shortcut_intents.dart`.

| Shortcut | Azione |
|---|---|
| `Ctrl+O` | Apri file PDF |
| `←` / `→` | Pagina precedente / successiva |
| `Home` | Prima pagina |
| `End` | Ultima pagina |
| `Ctrl+F` | Attiva ricerca testo |
| `ESC` | Chiudi ricerca / Esci da presentazione |
| `Ctrl+P` | Stampa |
| `Ctrl+D` | Aggiungi/rimuovi segnalibro pagina corrente |
| `F11` | Modalità presentazione |
| `Ctrl++` | Zoom in |
| `Ctrl+-` | Zoom out |
| `Ctrl+0` | Zoom reset 100% |

---

## 12. ANIMAZIONI (flutter_animate)

Regola: **veloci e sottili**, mai fastidiose. Durate massime: 300ms.

- Apertura app: logo fade-in + slide-up 300ms → home con stagger card recenti
- Apertura PDF: loading overlay con logo pulsante → fade-out quando pronto
- Toolbar auto-hide: AnimatedSlide + FadeTransition 200ms
- Aggiunta segnalibro: scale 1.0→1.3→1.0 + cambio colore 250ms
- Swipe-to-delete: sfondo rosso con icona cestino che appare gradualmente
- Hover card (Windows): glow subtile su MouseRegion

---

## 13. ANDROID — MANIFEST

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32"/>
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>

    <application
        android:label="CosmoNet Reader"
        android:name="${applicationName}"
        android:icon="@mipmap/launcher_icon"
        android:requestLegacyExternalStorage="true">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>

            <!-- Apri con: da file manager, email, WhatsApp, ecc. -->
            <intent-filter>
                <action android:name="android.intent.action.VIEW"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <category android:name="android.intent.category.BROWSABLE"/>
                <data android:scheme="file" android:mimeType="application/pdf"/>
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.VIEW"/>
                <category android:name="android.intent.category.DEFAULT"/>
                <category android:name="android.intent.category.BROWSABLE"/>
                <data android:scheme="content" android:mimeType="application/pdf"/>
            </intent-filter>

        </activity>
    </application>
</manifest>
```

---

## 14. BUILD ANDROID — APK RELEASE

```bash
# Build APK ottimizzato (arm64 = dispositivi moderni)
flutter build apk --release --split-per-abi

# Output:
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk  ← principale
# build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
# build/app/outputs/flutter-apk/app-x86_64-release.apk

# AAB per Google Play Store
flutter build appbundle --release
```

---

## 15. BUILD WINDOWS — INSTALLER con Inno Setup

```ini
; installer.iss — aggiornato v2.0

[Setup]
AppName=CosmoNet Reader
AppVersion=2.0.0
AppPublisher=CosmoNet.info
AppPublisherURL=https://www.cosmonet.info
DefaultDirName={autopf}\CosmoNet Reader
DefaultGroupName=CosmoNet Reader
OutputBaseFilename=CosmoNetReader_2.0.0_Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
SetupIconFile=assets\icon.ico
UninstallDisplayIcon={app}\cosmonet_reader.exe

[Languages]
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\CosmoNet Reader"; Filename: "{app}\cosmonet_reader.exe"
Name: "{group}\Disinstalla CosmoNet Reader"; Filename: "{uninstallexe}"
Name: "{commondesktop}\CosmoNet Reader"; Filename: "{app}\cosmonet_reader.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Crea icona sul desktop"; GroupDescription: "Icone aggiuntive:"; Flags: unchecked

[Run]
Filename: "{app}\cosmonet_reader.exe"; Description: "Avvia CosmoNet Reader"; Flags: nowait postinstall skipifsilent
```

---

## 16. GITHUB ACTIONS — WORKFLOW CORRETTO

Il workflow precedente falliva per questi motivi risolti qui:
- ✅ Firma APK Android corretta con secrets GitHub
- ✅ Versione Flutter esplicita e stabile
- ✅ Inno Setup installato nel runner Windows prima della build
- ✅ Permissions corretti per creare GitHub Releases
- ✅ APK unsigned disponibile anche senza keystore (per test)

```yaml
# .github/workflows/build.yml

name: Build & Release CosmoNet Reader

on:
  push:
    tags:
      - 'v*.*.*'        # Si attiva solo su tag tipo v2.0.0

permissions:
  contents: write       # Necessario per creare Release su GitHub

jobs:

  # ─── BUILD ANDROID ──────────────────────────────────────────────
  build-android:
    name: Build APK Android
    runs-on: ubuntu-latest

    steps:
      - name: Checkout codice
        uses: actions/checkout@v4

      - name: Setup Java 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Setup Flutter 3.24.0
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Install dipendenze
        run: flutter pub get

      - name: Analisi statica (opzionale, non blocca)
        run: flutter analyze --no-fatal-infos || true

      - name: Build APK release (senza firma — per sideload e test)
        run: |
          flutter build apk --release --split-per-abi

      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-*-release.apk
          retention-days: 7

  # ─── BUILD WINDOWS ──────────────────────────────────────────────
  build-windows:
    name: Build Windows Installer
    runs-on: windows-latest

    steps:
      - name: Checkout codice
        uses: actions/checkout@v4

      - name: Setup Flutter 3.24.0
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Install dipendenze
        run: flutter pub get

      - name: Build Windows release
        run: flutter build windows --release

      - name: Installa Inno Setup
        run: choco install innosetup --yes

      - name: Compila installer .exe
        run: iscc installer.iss

      - name: Upload installer artifact
        uses: actions/upload-artifact@v4
        with:
          name: windows-installer
          path: Output\*.exe
          retention-days: 7

  # ─── CREA RELEASE SU GITHUB ─────────────────────────────────────
  create-release:
    name: Crea GitHub Release
    needs: [build-android, build-windows]
    runs-on: ubuntu-latest

    steps:
      - name: Download APK
        uses: actions/download-artifact@v4
        with:
          name: android-apk
          path: artifacts/android

      - name: Download Installer Windows
        uses: actions/download-artifact@v4
        with:
          name: windows-installer
          path: artifacts/windows

      - name: Crea Release su GitHub
        uses: softprops/action-gh-release@v2
        with:
          name: "CosmoNet Reader ${{ github.ref_name }}"
          body: |
            ## CosmoNet Reader ${{ github.ref_name }}

            Lettore PDF professionale senza pubblicità — by [cosmonet.info](https://www.cosmonet.info)

            ### Download
            - **Android (APK):** Scarica `app-arm64-v8a-release.apk` per dispositivi moderni
            - **Windows:** Scarica `CosmoNetReader_*_Setup.exe` per installazione guidata

            ### Installazione Android
            1. Abilita *Origini sconosciute* in Impostazioni → Sicurezza
            2. Apri l'APK e installa

            ### Note versione
            Vedi CHANGELOG.md per i dettagli delle modifiche.
          draft: false
          prerelease: false
          files: |
            artifacts/android/*.apk
            artifacts/windows/*.exe
```

**Come usare il workflow:**
Per pubblicare una nuova versione, crea un tag Git e fai push:
```bash
git tag v2.0.0
git push origin v2.0.0
```
GitHub Actions si attiva automaticamente, compila tutto e crea la Release.

---

## 17. REGOLE ASSOLUTE

```
✅ DEVI fare:
- Consegnare ogni file COMPLETO, dall'inizio alla fine
- Commentare il codice in italiano dove utile
- Usare esattamente i colori HEX della sezione 4
- Usare i font Exo 2, Fira Sans, JetBrains Mono (sezione 5)
- Inizializzare DatabaseService in main.dart prima di tutto
- Gestire TUTTI gli errori con try/catch + messaggio UI (SnackBar o Dialog)
- Usare permission_handler per i permessi storage Android
- Separare nettamente logica (services) da UI (widgets/screens)
- Gestire il caso di PDF protetto da password (mostrare dialog password)
- Gestire il caso di PDF corrotto (mostrare errore user-friendly)

❌ NON devi:
- Aggiungere pubblicità di qualsiasi tipo
- Aggiungere analytics, tracking, Firebase, o qualsiasi servizio cloud
- Aggiungere login o account utente
- Aggiungere API esterne (l'app funziona 100% offline)
- Scrivere patch parziali (sempre file completi)
- Usare font di sistema o colori non in palette
- Lasciare import inutilizzati
- Usare setState dove ValueNotifier o Service è più appropriato
- Richiedere permessi che non servono
```

---

## 18. ORDINE DI IMPLEMENTAZIONE

**Fase 1 — Core:**
1. `cosmonet_colors.dart`
2. `app_theme.dart` + `text_styles.dart`
3. `database_service.dart` (SQLite init)
4. `recent_files_service.dart`
5. `reading_state_service.dart`
6. `home_screen.dart` + `recent_file_card.dart` + `empty_state.dart`
7. `pdf_viewer_screen.dart` (viewer base)
8. `viewer_toolbar.dart` + `viewer_bottom_bar.dart`

**Fase 2 — Feature:**
9. `bookmark_service.dart` + `bookmarks_panel.dart`
10. `search_service.dart` + `search_bar_overlay.dart`
11. `annotation_service.dart` + `annotation_toolbar.dart`
12. `thumbnail_drawer.dart`
13. `document_outline.dart` + `document_info_sheet.dart`

**Fase 3 — Rifinitura:**
14. `settings_screen.dart`
15. `shortcut_intents.dart` (Windows keyboard shortcuts)
16. Animazioni con `flutter_animate`
17. `installer.iss` aggiornato (sezione 15)
18. `.github/workflows/build.yml` (sezione 16)

---

## 19. CHECKLIST FINALE

```
□ flutter analyze → 0 errori, 0 warning
□ flutter build apk --release → OK
□ flutter build windows → OK
□ Apertura PDF da file picker funziona
□ "Apri con..." da file manager Android funziona
□ Drag & drop PDF su Windows funziona
□ Resume lettura: riapre alla pagina corretta dopo cold start
□ Segnalibri persistono dopo chiusura app
□ Ricerca testo: gestisce PDF senza testo (no crash)
□ Annotazioni visibili e persistenti tra sessioni
□ Tutte le stringhe UI in italiano
□ SQLite si inizializza senza errori alla prima apertura
□ WakeLock attivo durante lettura
□ Installer Windows include tutti i file della build
□ GitHub Actions workflow crea Release senza errori
□ Nessuna chiamata a servizi esterni/internet nell'app
□ Tutti i colori dalla palette CosmoNet (sezione 4)
□ Font corretti: Exo 2 / Fira Sans / JetBrains Mono
```

---

*Brief — CosmoNet Reader v2.0 per Google Antigravity*  
*cosmonet.info — DanyWolf — Maggio 2026*

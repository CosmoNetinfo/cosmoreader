$ErrorActionPreference = "Continue"
Write-Host "Inizio procedura automatica..."

# 1. Clona Flutter
if (-not (Test-Path C:\flutter_temp\flutter)) {
    Write-Host "Clonazione Flutter..."
    git clone -b stable https://github.com/flutter/flutter.git C:\flutter_temp\flutter
}

# Imposta il PATH per questa sessione
$env:PATH += ";C:\flutter_temp\flutter\bin"

# Inizializza Flutter
Write-Host "Inizializzazione Flutter SDK..."
flutter --version

# 2. Crea la directory di build su C: e copia il progetto
if (Test-Path C:\cosmonet_build) { Remove-Item -Recurse -Force C:\cosmonet_build }
New-Item -ItemType Directory -Path C:\cosmonet_build | Out-Null
Write-Host "Copia del progetto su C:..."
Copy-Item -Path L:\cosmonet_reader -Destination C:\cosmonet_build -Recurse

# 3. Vai nella cartella su C:
Set-Location C:\cosmonet_build\cosmonet_reader

# 4. Genera Icone
Write-Host "Aggiornamento dipendenze e generazione icone..."
flutter pub get
dart run flutter_launcher_icons:main

# 5. Build Android
Write-Host "Compilazione Android APK..."
flutter build apk --release --split-per-abi

# 6. Build Windows
Write-Host "Compilazione Windows EXE..."
flutter build windows --release

# 7. Inno Setup
Write-Host "Compilazione Installer Inno Setup..."
$iscc = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if (Test-Path $iscc) {
    & $iscc installer.iss
} else {
    Write-Host "ERRORE: Inno Setup non trovato in $iscc"
}

# 8. Copia in output su L:
Write-Host "Ricopia i binari completati nella cartella originale..."
if (-not (Test-Path L:\cosmonet_reader\output)) { New-Item -ItemType Directory -Path L:\cosmonet_reader\output | Out-Null }
Copy-Item .\output\* L:\cosmonet_reader\output\ -Force -Recurse

Write-Host "Pulizia C:\cosmonet_build..."
Set-Location C:\
Remove-Item -Recurse -Force C:\cosmonet_build

Write-Host "COMPLETATO CON SUCCESSO!"

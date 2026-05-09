; installer.iss — aggiornato v2.0

[Setup]
AppName=CosmoNet Reader
AppVersion=2.0.1
AppPublisher=CosmoNet.info
AppPublisherURL=https://www.cosmonet.info
DefaultDirName={autopf}\CosmoNet Reader
DefaultGroupName=CosmoNet Reader
OutputBaseFilename=CosmoNetReader_2.0.1_Setup
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
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

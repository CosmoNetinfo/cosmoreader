[Setup]
AppName=CosmoNet Reader
AppVersion=1.0.0
DefaultDirName={autopf}\CosmoNet Reader
DefaultGroupName=CosmoNet Reader
OutputBaseFilename=CosmoNetReader_Setup
OutputDir=output
Compression=lzma
SolidCompression=yes
SetupIconFile=windows\runner\resources\app_icon.ico

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\CosmoNet Reader"; Filename: "{app}\cosmonet_reader.exe"
Name: "{commondesktop}\CosmoNet Reader"; Filename: "{app}\cosmonet_reader.exe"

[Run]
Filename: "{app}\cosmonet_reader.exe"; Description: "Avvia CosmoNet Reader"; Flags: postinstall

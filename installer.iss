[Setup]
AppName=CosmoNet Reader
AppVersion=1.0.0
DefaultDirName={autopf}\CosmoNet Reader
DefaultGroupName=CosmoNet Reader
OutputBaseFilename=CosmoNetReader_Setup
OutputDir=C:\cosmonet_build\output
Compression=lzma
SolidCompression=yes

[Files]
Source: "C:\cosmonet_build\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\CosmoNet Reader"; Filename: "{app}\cosmonet_reader.exe"
Name: "{commondesktop}\CosmoNet Reader"; Filename: "{app}\cosmonet_reader.exe"

[Run]
Filename: "{app}\cosmonet_reader.exe"; Description: "Avvia CosmoNet Reader"; Flags: postinstall

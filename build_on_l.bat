@echo off
set "PUB_CACHE=L:\pub_cache"
if not exist "L:\pub_cache" mkdir "L:\pub_cache"
echo Configurazione Ambiente...
echo PUB_CACHE impostata su L:\pub_cache
cd /d "L:\cosmonet_reader"
call "L:\cosmonet_flutter_sdk\bin\flutter.bat" clean
call "L:\cosmonet_flutter_sdk\bin\flutter.bat" pub get
echo Inizio Lancio CosmoNet Reader...
call "L:\cosmonet_flutter_sdk\bin\flutter.bat" run -d windows
pause

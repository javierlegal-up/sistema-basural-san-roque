@echo off
title Mapa Limpio
cd /d "%~dp0"
if not exist "%~dp0index.html" echo No se encontro index.html en esta carpeta.& pause& exit /b

echo.
echo   MAPA LIMPIO
echo   ===========
echo.
echo   1. Abrir en esta computadora
echo   2. Ver en el celular (con QR, por wifi)
echo.
choice /c 12 /n /m "  Elegi 1 o 2: "
if errorlevel 2 (
  title Mapa Limpio - Ver en el celular
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0servidor-celular.ps1"
  echo.
  echo   El servidor se cerro.
  pause
  exit /b
)

rem --- Opcion 1: abrir en esta computadora ---
set "URL=file:///%~dp0index.html"
set "URL=%URL:\=/%"
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" start "" "%ProgramFiles%\Google\Chrome\Application\chrome.exe" "%URL%"& exit /b
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" start "" "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" "%URL%"& exit /b
if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" start "" "%LocalAppData%\Google\Chrome\Application\chrome.exe" "%URL%"& exit /b
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" start "" "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" "%URL%"& exit /b
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" start "" "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" "%URL%"& exit /b
explorer.exe "%~dp0index.html"

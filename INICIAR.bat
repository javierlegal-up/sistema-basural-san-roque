@echo off
title Mapa Limpio
cd /d "%~dp0"
if not exist "%~dp0index.html" echo No se encontro index.html en esta carpeta.& pause& exit /b
set "URL=file:///%~dp0index.html"
set "URL=%URL:\=/%"
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" start "" "%ProgramFiles%\Google\Chrome\Application\chrome.exe" "%URL%"& exit /b
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" start "" "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" "%URL%"& exit /b
if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" start "" "%LocalAppData%\Google\Chrome\Application\chrome.exe" "%URL%"& exit /b
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" start "" "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" "%URL%"& exit /b
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" start "" "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" "%URL%"& exit /b
explorer.exe "%~dp0index.html"

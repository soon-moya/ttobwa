@echo off
setlocal enabledelayedexpansion

echo Building Flutter Web...

cd /d C:\Users\lasd7\Documents\ttobwa_app

set PATH=C:\src\flutter\bin;%PATH%

echo Flutter version:
flutter --version

echo Getting dependencies...
flutter pub get

echo Building web release...
flutter build web --release

echo.
echo Build complete! Web files are in: build\web
echo.
pause

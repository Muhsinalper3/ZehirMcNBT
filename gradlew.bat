@echo off
setlocal
cd /d "%~dp0"
set "GRADLE_VERSION=9.7.1"
set "GRADLE_HOME=%USERPROFILE%\.gradle\wrapper\dists\gradle-%GRADLE_VERSION%-bin"
set "GRADLE_DIR=%GRADLE_HOME%\gradle-%GRADLE_VERSION%"
set "GRADLE_ZIP=%TEMP%\gradle-%GRADLE_VERSION%-bin.zip"
set "GRADLE_URL=https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip"

if exist "%GRADLE_DIR%\bin\gradle.bat" goto run

echo Gradle %GRADLE_VERSION% bulunamadi. Indiriliyor...
if not exist "%GRADLE_HOME%" mkdir "%GRADLE_HOME%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%GRADLE_URL%' -OutFile '%GRADLE_ZIP%'"
if errorlevel 1 exit /b 1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%GRADLE_ZIP%' -DestinationPath '%GRADLE_HOME%' -Force"
if errorlevel 1 exit /b 1
del /q "%GRADLE_ZIP%" >nul 2>nul

:run
call "%GRADLE_DIR%\bin\gradle.bat" %*
exit /b %ERRORLEVEL%

@echo off
setlocal
title ZehirMcNBT Builder
cd /d "%~dp0"

echo.
echo ==========================================
echo        ZehirMcNBT - Otomatik Derleyici
echo ==========================================
echo.

echo [1/3] Proje derleniyor...
if exist "gradlew.bat" (
    call gradlew.bat clean build
    if errorlevel 1 goto :error
) else (
    where gradle >nul 2>nul
    if errorlevel 1 (
        echo [HATA] Gradle bulunamadi.
        echo Bu proje icin Gradle kurulumu gerekli.
        echo.
        pause
        exit /b 1
    )
    call gradle clean build
    if errorlevel 1 goto :error
)

echo.
echo [2/3] JAR bulunuyor ve kopyalaniyor...
if not exist "dist" mkdir "dist"

set "JAR="

if exist "build\libs\ZehirMcNBT.jar" set "JAR=build\libs\ZehirMcNBT.jar"

if not defined JAR (
    for /f "delims=" %%F in ('dir /b /a-d "build\libs\*.jar" 2^>nul') do (
        if not defined JAR set "JAR=build\libs\%%F"
    )
)

if not defined JAR (
    echo [HATA] build\libs klasorunde JAR bulunamadi.
    echo.
    echo build\libs icerigi:
    if exist "build\libs" (
        dir /b "build\libs"
    ) else (
        echo Klasor mevcut degil.
    )
    goto :error
)

echo Bulunan JAR: %JAR%
copy /Y "%JAR%" "dist\ZehirMcNBT.jar" >nul
if errorlevel 1 goto :error

copy /Y "%JAR%" ".\ZehirMcNBT.jar" >nul
if errorlevel 1 goto :error

if not exist "ZehirMcNBT.jar" (
    echo [HATA] JAR kopyalanamadi.
    goto :error
)

echo.
echo [3/3] Tamamlandi.
echo JAR HAZIR: %CD%\ZehirMcNBT.jar
echo DIST JAR: %CD%\dist\ZehirMcNBT.jar
echo.
pause
exit /b 0

:error
echo.
echo ==========================================
echo ISLEM BASARISIZ!
echo ==========================================
echo.
pause
exit /b 1

@echo off
setlocal
title ZehirMcNBT Builder
cd /d "%~dp0"

echo.
echo ==========================================
echo        ZehirMcNBT - Otomatik Derleyici
echo ==========================================
echo.

if exist "gradlew.bat" (
    echo [1/3] Gradle Wrapper bulundu.
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
    echo [1/3] Sistem Gradle bulundu.
    call gradle clean build
    if errorlevel 1 goto :error
)

echo.
echo [2/3] JAR kopyalaniyor...
if not exist "dist" mkdir "dist"

for %%F in ("build\libs\ZehirMcNBT-*.jar") do (
    copy /Y "%%~fF" "dist\ZehirMcNBT.jar" >nul
    copy /Y "%%~fF" ".\ZehirMcNBT.jar" >nul
)

if not exist "ZehirMcNBT.jar" (
    echo [HATA] JAR olusturulamadi.
    goto :error
)

echo.
echo [3/3] Tamamlandi.
echo JAR HAZIR: %CD%\ZehirMcNBT.jar
echo.
pause
exit /b 0

:error
echo.
echo ==========================================
echo DERLEME BASARISIZ!
echo ==========================================
echo.
pause
exit /b 1

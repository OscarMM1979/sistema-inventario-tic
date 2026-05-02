@echo off
echo ==========================================
echo Instalador Agente de Monitoreo TIC
echo Alcaldia de Santiago de Cali
echo ==========================================
echo.

echo Verificando Node.js...
node -v >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js no esta instalado
    echo Descargalo de: https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js detectado correctamente
echo.

echo Instalando dependencias...
cd /d "%~dp0"
npm install

echo.
echo Configurando servicio...
echo Creando tarea programada...
schtasks /create /tn "AgenteMonitoreoTIC" /tr "node %~dp0src\sender.js" /sc minute /mo 5 /f >nul 2>&1

echo.
echo ==========================================
echo Instalacion completada
echo El agente se ejecutara cada 5 minutos
echo ==========================================
pause
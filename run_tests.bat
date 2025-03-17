@echo off
echo Executando testes de automação...

REM Ativar o ambiente virtual
call venv\Scripts\activate

REM Executar os testes do Robot Framework
robot -d results tests\crud_tests.robot

echo Testes finalizados! Verifique a pasta "results".
pause
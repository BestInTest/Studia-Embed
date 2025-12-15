:: Skrypt do omijania błędu SDCC
:: Dzięki temu CLion zaciągnie konfiguracje z sdcc.yaml
:: Trzeba wrzucić do C:\Program Files (x86)\SDCC\bin\sdcc_wrapper.bat
@echo off
setlocal

:: Szukamy flagi "-c" w argumentach
set "IS_COMPILE=0"
for %%a in (%*) do (
    if "%%a"=="-c" set "IS_COMPILE=1"
)

:: JEŚLI TO KOMPILACJA (-c): Uruchom prawdziwe SDCC
if "%IS_COMPILE%"=="1" (
    "C:\Program Files (x86)\SDCC\bin\sdcc.exe" %*
    exit /b %errorlevel%
)

:: JEŚLI TO NIE KOMPILACJA (tylko pytania CLiona):
:: Oszukujemy CLiona że jesteśmy GCC.
echo gcc version 9.9.9 (SDCC Wrapper)
exit /b 0
@echo off
rem Build Star Battles with QB64 Phoenix Edition on Windows.
rem Usage: set QB64PE=C:\qb64pe\qb64pe.exe  then  build-qb64pe.cmd [output-subfolder]
rem (port helper, not part of the 1990 original)
cd /d "%~dp0"
if "%QB64PE%"=="" set QB64PE=qb64pe.exe
set OUT=%~1
if "%OUT%"=="" set OUT=game
if not exist "%OUT%" mkdir "%OUT%"
for %%P in (STARBAT SB SB2 SBCREATE) do (
  echo == %%P
  "%QB64PE%" -x -q "%~dp0PE_%%P.BAS" -o "%~dp0%OUT%\%%P.exe" || exit /b 1
)
copy /y SBINST.DOC "%OUT%" >nul
copy /y SBCRINST.DOC "%OUT%" >nul
copy /y CREATION.DOC "%OUT%" >nul
echo Done. Run STARBAT.exe from %OUT% (or SBCREATE.exe to make a scenario).

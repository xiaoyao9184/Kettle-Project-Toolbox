@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2017-08-21
::FILE RUN_SPOON
::DESC run spoon with customize KETTLE_HOME
::PARAM none
::--------------------
::CHANGE 2018-12-28
::remove current_folder
::--------------------


:v

set tip=Kettle-Project-Toolbox: Run Spoon
set ver=1.0
::interactive
echo %cmdcmdline% | find /i "%~0" >nul
if not errorlevel 1 ( set interactive=0 ) else ( set interactive=1 )
::set kettle environment
if exist "%~dp0SET_ENVIRONMENT.bat" (
    call %~dp0SET_ENVIRONMENT.bat
)


:title

title %tip% %ver%
echo %tip%
echo Will auto close
echo ...


:begin

::goto engine path
%~d0
cd %~dp0
cd..
cd data-integration
set pdiPath=%cd%
set projectPath=%~dp0

::print info
if %interactive% equ 0 cls
echo ===========================================================
echo Kettle engine path is: %pdiPath%
echo Kettle project path is: %projectPath%
echo KETTLE_HOME is: %KETTLE_HOME%
echo KETTLE_REPOSITORY is: %KETTLE_REPOSITORY%
echo ===========================================================
echo Running...      Ctrl+C for exit

::run
call Spoon.bat


:done

if %errorlevel% equ 0 (
    echo Ok, run done!
) else (
    echo Sorry, some error make failure!
    if %interactive% equ 0 pause
)


:end

exit /b %errorlevel%
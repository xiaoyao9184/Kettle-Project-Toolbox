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


::var
:v

set tip=Kettle-Project-Toolbox: Run Spoon
set ver=1.0
::interactive
set interactive=1
::default is inter call
::check double-clicking(outer call) and set 0
::double-clicking use cmdline like this: cmd /d ""{scriptfile}" "
::check cmdcmdline include ""{scriptfile}" "
echo %cmdcmdline% | find /i "%~0" >nul
if not errorlevel 1 set interactive=0
::set kettle environment
if exist "%~dp0SET_ENVIRONMENT.bat" (
    call %~dp0SET_ENVIRONMENT.bat
)


::title
:title

title %tip% %ver%
echo %tip%
echo Will auto close
echo ...


::begin
:begin

::goto engine
%~d0
cd %~dp0
cd..
cd data-integration

::print info
if _%interactive%_ equ _0_ cls
echo ===========================================================
echo Kettle engine path is: %cd%
echo Kettle project path is: %~dp0
echo KETTLE_HOME is: %KETTLE_HOME%
echo KETTLE_REPOSITORY is: %KETTLE_REPOSITORY%
echo ===========================================================
echo Running...      Ctrl+C for exit

::spoon
call Spoon.bat


::done

if %ERRORLEVEL% equ 0 (
    if _%interactive%_ equ _0_ exit /b 0
)

echo Press enter to exit
pause


::end
:end

exit /b 0
@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2017-08-22
::FILE INIT_PROJECT_PATH
::DESC init file repository as project directory
::PARAM none
::--------------------
::CHANGE 2018-12-31
::english
::--------------------


:v

set tip=Kettle-Project-Toolbox: Init project
set ver=1.0
::interactive
set interactive=1
::default is inter call
::check double-clicking(outer call) and set 0
::double-clicking use cmdline like this: cmd /d ""{scriptfile}" "
::check cmdcmdline include ""{scriptfile}" "
echo %cmdcmdline% | find /i "%~0" >nul
if not errorlevel 1 set interactive=0
::current info
set current_path=%~dp0
%~d0
cd %~dp0
cd..
set parent_path=%cd%
::tip info
set echo_rName=Need input KPT project name
set eset_rName=Please input KPT project name:
::defult param
set rName=
set pdi_path=%parent_path%\data-integration


:title

title %tip% %ver%
echo %tip%
echo Can be closed after the run ends
echo ...


:check

if "%rName%"=="" (
	echo %echo_rName%
	set /p rName=%eset_rName%
)
if _%interactive%_ equ _0_ (
	set isOpenShell="true"
) else (
    set isOpenShell="false"
)


:begin

::goto work path
cd %current_path%

::print info
if _%interactive%_ equ _0_ cls
echo ===========================================================
echo Kettle work path is: %current_path%
echo Kettle engine path is: %pdi_path%
echo Kettle init project: %rName%
echo Kettle project will init at: %parent_path%
echo ===========================================================
echo Running...      Ctrl+C for exit

::create command run
set c=%pdi_path%\kitchen -file:%current_path%CreateProjectRepository.kjb "-param:rName=%rName%" "-param:isOpenShell=%isOpenShell%"
if _%interactive%_ neq _0_ echo %c%
call %c%

:done

if %errorlevel% equ 0 (
    echo Ok, run done!
) else (
    echo Sorry, some error make failure!
)


:end

if _%interactive%_ equ _0_ pause
exit /b %errorlevel%
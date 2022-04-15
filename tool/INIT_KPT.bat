@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-06-10
::FILE INIT_KPT
::DESC create a workspace for Kettle-Project-Toolbox using junction
::PARAM params for the workspace path and PDI path
::  1: workspacePath 
::  2: pdiPath
::--------------------
::CHANGE 2018-12-31
::english
::--------------------


:v

set tip=Kettle-Project-Toolbox: link KPT
set ver=1.0
::interactive 1 for true
echo %cmdcmdline% | find /i "%~0" >nul
if not errorlevel 1 ( set interactive=0 ) else ( set interactive=1 )
::current info
set current_path=%~dp0
%~d0
cd %~dp0
cd..
set parent_path=%cd%
::tip info
set echo_workspacePath=Need input workspace path for link KPT's paths(tool,default,Windows)
set eset_workspacePath=Please input path or drag path in:
::defult param
set workspacePath=%1
set pdiPath=%2
set kptPath=%parent_path%


:title

title %tip% %ver%
echo %tip%
echo Can be closed after the run ends
echo ...


:check

if "%workspacePath%"=="" (
	echo %echo_workspacePath%
	set /p workspacePath=%eset_workspacePath%
)
if not exist %workspacePath% (
    md %workspacePath%
)


:begin

::goto work path
cd %current_path%

::print info
echo ===========================================================
echo Work path is: %current_path%
echo Kettle workspace path is: %workspacePath%
echo Kettle KPT path is: %kptPath%
echo ===========================================================
echo Running...      Ctrl+C for exit

::create param
if %interactive% equ 0 (
	cls
) else  (
	echo Conflict Policy: Force replacement of an existing entity directory or link directory
    set param=noskip force
)

::run
echo ===========================================================
echo link KPT tool path...
call LINK_FOLDER.bat "%workspacePath%\tool" "%kptPath%\tool" %param%
echo. 
echo.
echo.
echo.
echo ===========================================================
echo link KPT defalut path...
call LINK_FOLDER.bat "%workspacePath%\default" "%kptPath%\default" %param%
echo.
echo.
echo.
echo.
echo ===========================================================
echo link KPT Windows path on windows system...
call LINK_FOLDER.bat "%workspacePath%\Windows" "%kptPath%\Windows" %param%
echo.
echo.
echo.
echo.
echo ===========================================================
echo link PDI path...
if "%pdiPath%"=="" (
	call LINK_FOLDER.bat "%workspacePath%\data-integration"
) else (
	call LINK_FOLDER.bat "%workspacePath%\data-integration" "%pdiPath%" %param%
)


:done

if %errorlevel% equ 0 (
    echo Ok, run done!
) else (
    echo Sorry, some error make failure!
)


:end

if %interactive% equ 0 pause
exit /b %errorlevel%
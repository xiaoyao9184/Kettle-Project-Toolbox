@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2021-08-19


:v

set tip=Kettle-Project-Toolbox: link KPT
set ver=1.0
::interactive
echo %cmdcmdline% | find /i "%~0" >nul
if not errorlevel 1 ( set interactive=0 ) else ( set interactive=1 )
::current info
set current_path=%~dp0

::tip info
set echo_workspacePath=Need input workspace path for link KPT's paths(tool,default,Windows)
set eset_workspacePath=Please input path or drag path in:
::defult param
set workspacePath=%1

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
    echo "%workspacePath% must exist!"
    exit /b 1
)
set toolPath=%workspacePath%\tool

:begin

::goto tool path
cd %toolPath%

::print info
echo ===========================================================
echo Work path is: %current_path%
echo Kettle workspace path is: %workspacePath%
echo Kettle KPT tool path is: %toolPath%
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
echo init canal-kafka-to-pgsql project...
call INIT_PROJECT.bat canal-kafka-to-pgsql
echo. 
echo.
echo.
echo.
echo ===========================================================
echo link canal-kafka-to-pgsql/mysql-log path...
call LINK_FOLDER.bat "%workspacePath%\canal-kafka-to-pgsql\mysql-log" "%current_path%\mysql-log" %param%
echo.
echo.
echo.
echo.
echo ===========================================================
echo copy files and profile...
copy "%current_path%\config.xml" "%workspacePath%\canal-kafka-to-pgsql\config.xml"
copy "%current_path%\db_kpt_bin_log_pgsql_writer.kdb" "%workspacePath%\canal-kafka-to-pgsql\db_kpt_bin_log_pgsql_writer.kdb"
copy "%workspacePath%\canal-kafka-to-pgsql\.profile\.profile" "%workspacePath%\canal-kafka-to-pgsql\.profile\default.profile"
echo.
echo.
echo.
echo.
echo ===========================================================


:done

if %errorlevel% equ 0 (
    echo Ok, run done!
) else (
    echo Sorry, some error make failure!
)


:end

if %interactive% equ 0 pause
exit /b %errorlevel%
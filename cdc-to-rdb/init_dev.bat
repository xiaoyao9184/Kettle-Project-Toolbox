@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2021-08-19


:v

set tip=Kettle-Project-Toolbox: init cdc dev env
set ver=1.0
::interactive
set interactive=1
::default is inter call
::no parameters will set 0
if "%1" equ "" set interactive=0
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
if not exist %toolPath% (
    echo "%toolPath% must exist, use KPT/tool/INIT_KPT to init workspace!"
    exit /b 1
)

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
if _%interactive%_ equ _0_ (
	cls
) else  (
	echo Conflict Policy: Force replacement of an existing entity directory or link directory
    set param=noskip force
)

::run

echo ===========================================================
echo init kpt-cdc-to-rdb project...
call INIT_PROJECT.bat kpt-cdc-to-rdb
echo. 
echo.
echo.
echo.
echo ===========================================================
echo link kpt-cdc-to-rdb path...
for /d %%i in (%current_path%*) do (
echo "%%i"
    for %%f in (%%i) do (
        set name=%%~nf
        echo "Link of !name!"
        call LINK_FOLDER.bat "%workspacePath%\kpt-cdc-to-rdb\!name!" "%%i" %param%
    )
)
echo.
echo.
echo.
echo ===========================================================
echo copy files and profile...
copy "%current_path%\config.xml" "%workspacePath%\kpt-cdc-to-rdb\config.xml"
copy "%current_path%\db_kpt_cdc_event_pgsql_writer.kdb" "%workspacePath%\kpt-cdc-to-rdb\db_kpt_cdc_event_pgsql_writer.kdb"
copy "%workspacePath%\kpt-cdc-to-rdb\.profile\.profile" "%workspacePath%\kpt-cdc-to-rdb\.profile\default.profile"
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

if _%interactive%_ equ _0_ pause
exit /b %errorlevel%
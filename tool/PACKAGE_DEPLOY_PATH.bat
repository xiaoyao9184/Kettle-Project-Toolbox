@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2021-04-09
::FILE PACKAGE_DEPLOY_PATH
::DESC create a zip file for deploy on filesystem path
::PARAM none
::--------------------
::CHANGE 2021-04-09
::init
::--------------------


:v

set tip=Kettle-Project-Toolbox: Package deploy zip for path
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
set echo_srcPath=Need input path for create deploy zip
set eset_srcPath=Please input path or drag path in:
::defult param
set srcPath=%1
set pdi_path=%parent_path%\data-integration


:title

title %tip% %ver%
echo %tip%
echo Can be closed after the run ends
echo ...


:check

if "%srcPath%"=="" (
	echo %echo_srcPath%
	set /p srcPath=%eset_srcPath%
)
if %interactive% equ 0 (
	set isOpenShell="true"
) else (
    set isOpenShell="false"
)


:begin

::goto work path
cd %current_path%

::print info
if %interactive% equ 0 cls
echo ===========================================================
echo Kettle engine path is: %pdi_path%
echo Kettle deploy path is: %srcPath%
echo Kettle deploy file create at: %parent_path%
echo ===========================================================
echo Running...      Ctrl+C for exit

::create command run
set c=%pdi_path%\kitchen -file:%current_path%\Deploy\PackageZipDeploy4Path.kjb "-param:srcPath=%srcPath%" "-param:fExcludeRegex=.*\.backup$|.*\.log$|.*\.git\\.*|.*db\.cache.*|.*data-integration.*" "-param:fIncludeRegex=.*" "-param:isOpenShell=%isOpenShell%"
if %interactive% neq 0 echo %c%
call %c%


:done

if %errorlevel% equ 0 (
    echo Ok, run done!
) else (
    echo Sorry, some error make failure!
)


:end

if %interactive% equ 0 pause
exit /b %errorlevel%
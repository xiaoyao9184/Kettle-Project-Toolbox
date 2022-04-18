@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2021-04-09
::FILE PACKAGE_DEPLOY_KETTLE_HOME
::DESC create a zip file for deploy on kettle home
::PARAM none
::--------------------
::CHANGE 2021-04-09
::init
::--------------------


:v

set tip=Kettle-Project-Toolbox: Package deploy zip for kettle home
set ver=1.0
::interactive
echo %cmdcmdline% | find /i "%~0" >nul
if not errorlevel 1 ( set interactive=0 ) else ( set interactive=1 )
::current info
set current_path=%~dp0
%~d0
cd %~dp0
cd..
set parent_path=%cd%
::tip info
set echo_rName=Need input name of repository for deploy zip
set eset_rName=Please input name of repository for deploy zip:
::defult param
set rName=%1
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
echo Kettle deploy repository is: %rName%
echo Kettle deploy file create at: %parent_path%
echo ===========================================================
echo Running...      Ctrl+C for exit

::create command run
set c=%pdi_path%\kitchen -file:%current_path%\Deploy\PackageZipDeploy4KettleHome.kjb "-param:rNameRegex=%rName%" "-param:fExcludeRegex=.*\.backup$|.*\.log$|.*\.git\\.*|.*db\.cache.*|.*data-integration.*" "-param:fIncludeRegex=.*" "-param:isOpenShell=%isOpenShell%"
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
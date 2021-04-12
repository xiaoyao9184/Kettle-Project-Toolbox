@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2021-04-09
::FILE PACKAGE_DEPLOY_FILE_REPOSITORY_PATH
::DESC create a zip file for deploy on repository path
::PARAM none
::--------------------
::CHANGE 2021-04-09
::init
::--------------------


:v

set tip=Kettle-Project-Toolbox: Package deploy zip for file repository path
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
echo Kettle engine path is: %pdi_path%
echo Kettle deploy repository is: %rName%
echo Kettle deploy file create at: %parent_path%
echo ===========================================================
echo Running...      Ctrl+C for exit

::create command run
set c=%pdi_path%\kitchen -file:%current_path%\Deploy\PackageZipDeploy4FileRepositoryPath.kjb "-param:rNameRegex=%rName%" "-param:fExcludeRegex=.*\.backup$|.*\.log$|.*\.git\\.*|.*db\.cache.*|.*data-integration.*" "-param:fIncludeRegex=.*" "-param:isOpenShell=%isOpenShell%"
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
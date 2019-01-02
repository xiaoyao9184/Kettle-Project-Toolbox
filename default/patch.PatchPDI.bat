@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0
::TIME 2017-08-26
::FILE RUN_REPOSITORY_JOB_OR_TRANSFORMATION
::DESC run a job or transformation in filesystem repositorie 
::PARAM params for the job or transformation 
::  1: ProfileName
::--------------------
::CHANGE 2018-11-20
::english
::CHANGE 2018-11-20
::use more special character judgment inter active
::--------------------


:v

set tip=Kettle-Project-Toolbox: Run kitchen or pan
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
set current_script_name=%~n0
::tip info
set echo_rName=Need input kettle repository name!
set eset_rName=Please input kettle repository name:
set echo_jName=Need input kettle repository job or transformation name!
set eset_jName=Please input kettle repository job or transformation name:
set echo_jFile=The kettle job path is:
set echo_pList=Enter parameters setting script!
set echo_kCommand=Run job^(J^) or transformation^(T^)?
::set kettle environment
if exist "%current_path%SET_ENVIRONMENT.bat" (
    call %current_path%SET_ENVIRONMENT.bat
)
::default param
set rName=%KETTLE_REPOSITORY%
set jName=
set pList=
set kCommand=
set loglevel=Detailed


:title

title %tip% %ver%
echo %tip%
echo Can be closed after the run ends
echo ...


:check

::repository name
echo %rName%
if "%rName%"=="" (
    echo %echo_rName%
    set /p rName=%eset_rName%
)

::job or transformation name
goto notfound

:finding

echo finding file in this path: %fileName%.%extName%
if exist "%fileName%.%extName%" (
    set jName=%fileName%
    goto found
) else (
    set fileName=%fileName:.=\%
    echo finding file in sub path: !fileName!.%extName%
    if exist "!fileName!.%extName%" (
        set jName=!fileName:.=/!
        goto found
    ) else (
        goto notfound
    )
)

:notfound

if "%extName%"=="" (
    set kCommand=kitchen
    set fileName=%current_script_name%
    set extName=kjb
    goto finding
)
if "%extName%"=="kjb" (
    set kCommand=pan
    set fileName=%current_script_name%
    set extName=ktr
    goto finding
)
if "%extName%"=="ktr" (
    echo %echo_jName%
    set /p jName=%eset_jName%
    set kCommand=""
)

:found

::command is use kitchen or pan
if "%kCommand%"=="" (
    choice /c JT /m !echo_kCommand!
    if !errorlevel! equ 1 set kCommand=kitchen
    if !errorlevel! equ 2 set kCommand=pan
)

::param
if _%1_ neq __ (
    set pList= "-param:ProfileName=%1"
)
if exist "%~n0.SET_PARAM.bat" (
    echo %echo_pList% %~n0.SET_PARAM.bat
    call %~n0.SET_PARAM.bat
)

::log
set d=%date:~0,10%
set t=%time:~0,8%
set logfile=%current_path%log\%~n0%d:/=-%_%t::=-%.log


:begin

::goto engine path
%~d0
cd %~dp0
cd..
cd data-integration

::print info
if _%interactive%_ equ _0_ cls
echo ===========================================================
echo Kettle engine path is: %cd%
echo Kettle project path is: %current_path%
echo Kettle command is: %kCommand%
echo Kettle run it: %rName%:%jName%
echo Kettle parameters is: %pList% 
echo Kettle log level is: %loglevel%
echo Kettle log location is: %logfile%
echo ===========================================================
echo Running...      Ctrl+C for exit

::create command
set c=%kCommand% -rep:%rName% -user:admin -pass:admin -level:%loglevel% -job:%jName%%pList%
if _%interactive%_ neq _0_ echo %c%

::log output run
if _%JENKINS_HOME%_ neq __ (
    echo Used in Jenkins no log file!
    call %c%
) else (
    call %c%>>%logfile%
)


:done

if %errorlevel% equ 0 (
    echo Ok, run done!
) else (
    echo Sorry, some error make failure!
)


:end

if _%interactive%_ equ _0_ pause
exit /b %errorlevel%
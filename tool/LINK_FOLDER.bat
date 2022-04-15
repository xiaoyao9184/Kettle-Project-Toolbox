@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2017-09-05
::FILE LINK_FOLDER
::DESC create a symbolic link for directory
::PARAM params for the link path and target path
::  1: linkPath 
::  2: targetPath
::  3: skipConflictCheck
::  4: forceConflictReplace
::--------------------
::CHANGE 2018-12-31
::english
::--------------------

:v

set tip=Kettle-Project-Toolbox: Link directory
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
set echo_linkPath=Need input link path
set eset_linkPath=Please input path or drag path in:
set echo_targetPath=Need input target path
set eset_targetPath=Please input path or drag path in:
::defult param
set linkPath=%1
set targetPath=%2
set skipConflictCheck=%3
set forceConflictReplace=%4

:title

title %tip% %ver%
echo %tip%
echo Can be closed after the run ends
echo ...


:check

if "%linkPath%"=="" (
	echo %echo_linkPath%
	set /p linkPath=%eset_linkPath%
) else (
    set linkPath=%linkPath:"=%
)
if "%targetPath%"=="" (
	echo %echo_targetPath%
	set /p targetPath=%eset_targetPath%
) else (
    set targetPath=%targetPath:"=%
)
if "%skipConflictCheck%"=="skip" (
	goto begin
)

::check conflict
if exist %linkPath% (
	for %%i in (%linkPath%) do (
		for /f %%j in ('echo %%~ai^|find /i "-l"') do (
			echo Is already symbolic link!
			if "!forceConflictReplace!" equ "force" goto replace
			choice /c dre /m "Dele^(D^), Replace^(R^), None^(E^)?" /t 10  /d e
			if !errorlevel! equ 1 goto dele
			if !errorlevel! equ 2 goto replace
			if !errorlevel! equ 3 goto quit
		)
	)
	
	echo The folder already exists!
	if "!forceConflictReplace!" equ "force" goto replace
	choice /c yn /m "Dele folder and link^(Y^), cancel^(N^)?" /t 10  /d n
	if !errorlevel! equ 1 goto replace
	if !errorlevel! equ 2 goto quit
	
:quit
	echo user select stop option!
	goto end
:dele
	rd /s /q %linkPath%
	goto quit
:replace
	rd /s /q %linkPath%
)


:begin

::goto work path
cd %current_path%

::print info
echo ===========================================================
echo Work path is: %current_path%
echo Kettle link path is: %linkPath%
echo Kettle target path is: %targetPath%
echo ===========================================================
echo Running...      Ctrl+C for exit

::create command run
set c=mklink /j %linkPath% %targetPath% 
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
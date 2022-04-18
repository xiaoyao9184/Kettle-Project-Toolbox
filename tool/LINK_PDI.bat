@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2015-06-10
::FILE LINK_PDI
::DESC create a symbolic link(in this parent directory) for data-integration directory
::PARAM params for the PDI path
::  1: pdiPath 
::  2: skipConflictCheck
::  3: forceConflictReplace
::--------------------
::CHANGE 2018-12-31
::english
::--------------------


:v

set tip=Kettle-Project-Toolbox: Link PDI
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
set echo_pdiPath=Need input kettle engine data-integration path
set eset_pdiPath=Please input path or drag path in:
::defult param
set pdiPath=%1
set skipConflictCheck=%2
set forceConflictReplace=%3
set linkPath=%parent_path%\data-integration


:title

title %tip% %ver%
echo %tip%
echo Can be closed after the run ends
echo ...


:check

if "%pdiPath%"=="" (
	echo %echo_pdiPath%
	set /p pdiPath=%eset_pdiPath%
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
echo Kettle link PDI path is: %linkPath%
echo Kettle engine(data-integration) path is: %pdiPath%
echo ===========================================================
echo Running...      Ctrl+C for exit

::create command run
set c=mklink /j %linkPath% %pdiPath% 
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
exit /b
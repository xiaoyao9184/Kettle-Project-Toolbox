@echo off
Setlocal enabledelayedexpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2021-04-09
::FILE COPY_REPOSITORY_PATH
::DESC copy one or more repository meta(s) and file(s)
::PARAM none
::--------------------
::CHANGE 2021-04-09
::init
::--------------------

:v

set tip=Kettle-Project-Toolbox: Copy Repository path
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
set echorName=Need input name for copy, default: dev.*
set esetrName="Please input name for copy:"

set echorNameRegex=Need input match regex of repository name, default: dev.*
set esetrNameRegex="Please input match regex of repository name:"

set echorPathTarget=Need input path of copy target
set esetrPathTarget="Please input path of copy target:"

set echorMetaSource=Need input path of read repository meta
set esetrMetaSource="Please input path of read repository meta:"

::defult param
set pdi_path=%parent_path%\data-integration
set rNameRegex=
set rPathTarget=
set rPathType=
set rMetaSource=

:title

title %tip% %ver%
echo %tip%
echo Can be closed after the run ends
echo ...


:check

choice /c yn /m "copy one(Y), copy more(N, default)?" /t 10 /d n
	if !errorlevel! equ 1 goto one
	if !errorlevel! equ 2 goto more
	
:one
	set tempOm=one
	if "%rNameRegex%"=="" (
		echo %echorName%
		set /p rNameRegex=%esetrName%
	)

	goto omend

:more
	set tempOm=more
	if "%rNameRegex%"=="" (
		echo %echorNameRegex%
		set /p rNameRegex=%esetrNameRegex%
	)

:omend

choice /c yn /m "config repository path? (default is use name for path name)" /t 10 /d n
	if !errorlevel! equ 1 goto path
	if !errorlevel! equ 2 goto pathend

:path
	if "%rPathTarget%"=="" (
		echo "NOTE: if use \ suffix, will be judged as a fuzzy path and used as the parent path of the new repository)"
		echo %echorPathTarget%
		set /p rPathTarget=%esetrPathTarget%
	)
	
	echo %rPathTarget%end|findstr /o /r /c:\\end >cmd.tmp
	for /f %%i in (cmd.tmp) do (
		set isDir=%%i
	)
	del cmd.tmp

	if not "%isDir%"=="" (
		choice /c yn /m "copy repository path name, same as old path name(Y), or as repository name(N,default)?" /t 15 /d n
			if !errorlevel! equ 1 set rPathType=1
			if !errorlevel! equ 2 set rPathType=0
	)
:pathend

choice /c yn /m "need change kettle home path? (default is not)" /t 10 /d n
	if !errorlevel! equ 1 goto user
	if !errorlevel! equ 2 goto default

:user
	set tempUser=user
	if "%rMetaSource%"=="" (
		echo %echorMetaSource%
		set /p rMetaSource=%esetrMetaSource%
	)

	goto uesrend

:default
	set tempUser=default

:uesrend

:begin

set tempParam="-param:rNameRegex=%rNameRegex%"

if "%tempUser%"=="default" (
	echo "Kettle will use the repository meta in the user.kettle path as the input and output location"
)else (
	echo "Kettle will read repository meta from:" %rMetaSource%
	set tempParam=%tempParam% "-param:rMetaSource=%rMetaSource%"
)

if "%tempOm%"=="one" (
	echo "Kettle will copy one repository:" %rNameRegex%
)else (
	echo "Kettle will copy multiple repositories: " %rNameRegex%
)

if "%rPathTarget%"=="" (
	echo "Kettle will modify the meta path to be in the same path as the old meta, and have configured the name to name the path" 
)else (
	echo "Kettle will modify the meta(parent) path to:" %rPathTarget%
	if "%rPathType%"=="1" (
		echo "Kettle will use the old meta path name"
		set tempParam=!tempParam! "-param:rPathType=%rPathType%"
	)else (
		echo "Kettle will modify the meta path name to be the same as the path name"
		set tempParam=!tempParam! "-param:rPathType=%rPathType%"
	)
	set tempParam=!tempParam! "-param:rPathTarget=%rPathTarget% "
)

::goto work path
cd %current_path%

::print info
if %interactive% equ 0 cls
echo ===========================================================
echo Kettle engine path is: %pdi_path%
echo Kettle copy params is: %tempParam%
echo ===========================================================
echo Running...      Ctrl+C for exit

::create command run
set c=%pdi_path%\kitchen -file:%current_path%\Repository\CopyFileRepositoryPath.kjb %tempParam%
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
@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2015-06-10
::FILE INIT_WORKSPACE
::DESC create a workspace for Kettle-Project-Toolbox using LINK_FOLDER
::SYNTAX INIT_WORKSPACE [kpt_workspace_path [pdi_engine_path [kpt_repository_path]]]


:init_variable

::version
SET tip=Kettle-Project-Toolbox: init workspace
SET ver=1.0
SET NL=^


REM two empty line required

::interactive
::same as caller
IF "%interactive%"=="" (
    ::double-clicking with no caller will true:1
    ECHO %CMDCMDLINE% | FIND /I "%~0" >NUL
    IF %ERRORLEVEL% EQU 0 ( SET interactive=1 ) ELSE ( SET interactive=0 )
    IF NOT "!JENKINS_HOME!"=="" SET interactive=0
    IF NOT "!DEBUG!"=="" SET interactive=0
)

::script info
SET current_script_dir=%~dp0
SET current_script_name=%~n0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

::tip info
SET tip_kpt_workspace_path_input=Need input 'kpt_workspace_path' or drag path in:
SET tip_kpt_workspace_path_miss=Missing param 'kpt_workspace_path' at position 1.
SET tip_pdi_engine_path_input=Need input 'pdi_engine_path' or drag path in:
SET tip_pdi_engine_path_miss=Missing param 'pdi_engine_path' at position 2.
SET tip_pdi_engine_path_wrong=Wrong param 'pdi_engine_path' at position 2.
SET tip_kpt_repository_path_input=Need input 'kpt_repository_path' or drag path in:
SET tip_kpt_repository_path_miss=Missing param 'kpt_repository_path' at position 3.
SET tip_kpt_workspace_exist_strategy=KPT workspace exist strategy: replace of exist symbolic link directory

::defult param
SET kpt_workspace_path=%1
SET pdi_engine_path=%2
SET kpt_repository_path=%3
SET default_link_path_list=tool;shell;default


:tip_version

IF %interactive% EQU 1 ( TITLE %tip% %ver% ) ELSE ( ECHO %tip% )


:loop_check_variable

IF "%kpt_workspace_path%"=="" (
    IF %interactive% EQU 1 (
        SET /P kpt_workspace_path=%tip_kpt_workspace_path_input%
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_kpt_workspace_path_miss%
        EXIT /B 1
    )
)

IF "%pdi_engine_path%"=="" (
    IF %interactive% EQU 1 (
        SET /P pdi_engine_path=%tip_pdi_engine_path_input%
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_pdi_engine_path_miss%
        EXIT /B 1
    )
)
IF NOT EXIST "%pdi_engine_path%\Spoon.bat" (
    IF %interactive% EQU 1 (
        ECHO wrong path %pdi_engine_path%
        SET pdi_engine_path=
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_pdi_engine_path_wrong%
        EXIT /B 1
    )
)

IF "%kpt_repository_path%"=="" (
    @REM ::auto discover kpt
    IF EXIST "%parent_folder_dir%.git" (
        SET kpt_repository_path=%parent_folder_dir%
        GOTO:loop_check_variable
    )
    IF %interactive% EQU 1 (
        SET /P kpt_repository_path=%tip_kpt_repository_path_input%
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_kpt_repository_path_miss%
        EXIT /B 1
    )
)

SET default_link_path_list=!default_link_path_list:;=^

!
REM newline symbol two empty line required


:begin

::print info
ECHO ==========%current_script_name%==========
ECHO Script directory is: %current_script_dir%
ECHO Kettle engine path is: %pdi_engine_path%
ECHO KPT workspace path is: %kpt_workspace_path%
ECHO KPT repository path is: %kpt_repository_path%
ECHO KPT link path list is: !NL!!default_link_path_list!
ECHO -----------------NOTE--------------------
ECHO windows not support hard link target to directory;
ECHO use 'junction'[soft link] for all, it can link across hard drives.
ECHO __________%current_script_name%__________

::create workspace
IF NOT EXIST "%kpt_workspace_path%" (
    ECHO create directory for not exist %kpt_workspace_path%
    MD "%kpt_workspace_path%"
)

::create exist_strategy
IF %interactive% EQU 1 (
    ECHO:
) ELSE  (
    ECHO %tip_kpt_workspace_exist_strategy%
    SET exist_strategy=replace
)

SET _result_code=0

::link kpt source path
FOR /F "delims=" %%P IN ("!default_link_path_list!") DO (
    SET link_name=%%P
    SET _step=Step: link '!link_name!'
    ECHO:
    ECHO:
    ECHO ==========!_step!==========
    CALL %current_script_dir%LINK_FOLDER.bat "%kpt_workspace_path%\!link_name!" "%kpt_repository_path%\!link_name!" junction %exist_strategy%
    IF !ERRORLEVEL! NEQ 0 SET _result_code=1
    ECHO ##########!_step!##########
)

::link pdi engine path
SET _step=Step: link PDI engine path
ECHO:
ECHO:
ECHO ==========%_step%==========
CALL %current_script_dir%LINK_FOLDER.bat "%kpt_workspace_path%\data-integration" "%pdi_engine_path%" junction %exist_strategy%
IF !ERRORLEVEL! NEQ 0 SET _result_code=1
ECHO ##########%_step%##########

::done command
ECHO:
IF %_result_code% EQU 0 (
    ECHO Ok, run done!
) ELSE (
    ECHO Sorry, some error '%_result_code%' make failure!
)
ECHO ##########%current_script_name%##########


:end

IF %interactive% EQU 1 PAUSE
EXIT /B %_result_code%
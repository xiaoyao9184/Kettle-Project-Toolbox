@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-26
::FILE create_project
::DESC create project in kpt workspace
::SYNTAX create_project [kpt_project_name [kpt_workspace_path [pdi_engine_path]]]


:init_variable

::version
SET tip=Kettle-Project-Toolbox: create project
SET ver=1.0

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
SET tip_kpt_project_name_input=Need input 'kpt_project_name' or drag path in:
SET tip_kpt_project_name_miss=Missing param 'kpt_project_name' at position 1.
SET tip_kpt_project_name_exist=keep this name[Y], or input new one[N]?(default N after 10 seconds)
SET tip_kpt_workspace_path_input=Need input 'kpt_workspace_path' or drag path in:
SET tip_kpt_workspace_path_miss=Missing param 'kpt_workspace_path' at position 2.
SET tip_kpt_workspace_path_wrong=Wrong param 'kpt_workspace_path' at position 2.
SET tip_pdi_engine_path_input=Need input 'pdi_engine_path' or drag path in:
SET tip_pdi_engine_path_miss=Missing param 'pdi_engine_path' at position 3.
SET tip_pdi_engine_path_wrong=Wrong param 'pdi_engine_path' at position 3.

::defult param
SET kpt_project_name=%~1
SET kpt_workspace_path=%~2
SET pdi_engine_path=%~3
SET open_project_path=


:tip_version

IF %interactive% EQU 1 ( TITLE %tip% %ver% ) ELSE ( ECHO %tip% )


:loop_check_variable

IF "%kpt_workspace_path%"=="" (
    @REM ::auto discover pdi
    IF EXIST "%parent_folder_dir%data-integration\Spoon.bat" (
        SET kpt_workspace_path=%parent_folder_dir%
        GOTO:loop_check_variable
    )
    IF %interactive% EQU 1 (
        SET /P kpt_workspace_path=%tip_kpt_workspace_path_input%
        GOTO:loop_check_variable
    ) ELSE (
        ECHO %tip_kpt_workspace_path_miss%
        EXIT /B 1
    )
)
IF NOT EXIST "%kpt_workspace_path%" (
    IF %interactive% EQU 1 (
        ECHO not exist %kpt_workspace_path%
        SET kpt_workspace_path=
        GOTO:loop_check_variable
    ) ELSE (
        ECHO %tip_kpt_workspace_path_wrong%
        EXIT /B 1
    )
)

IF "%kpt_project_name%"=="" (
    IF %interactive% EQU 1 (
        SET /P kpt_project_name=%tip_kpt_project_name_input%
        GOTO:loop_check_variable
    ) ELSE (
        ECHO %tip_kpt_project_name_miss%
        EXIT /B 1
    )
)
IF "%skip_kpt_project_name_exist%"=="" IF EXIST "%kpt_workspace_path%\%kpt_project_name%" (
    ECHO exist %kpt_workspace_path%\%kpt_project_name%
    IF %interactive% EQU 1 (
        CHOICE /C yn /M "%tip_kpt_project_name_exist%" /T 10 /D n
        IF !ERRORLEVEL! EQU 2 (
            SET kpt_project_name=
            GOTO:loop_check_variable
        )
        SET skip_kpt_project_name_exist=true
    )
)

IF "%pdi_engine_path%"=="" (
    @REM ::auto discover pdi
    IF EXIST "%kpt_workspace_path%\data-integration\Spoon.bat" (
        SET pdi_engine_path=%kpt_workspace_path%\data-integration
        GOTO:loop_check_variable
    )
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

IF %interactive% EQU 1 (
    SET open_project_path=start
)


:begin

SET KPT_COMMAND=kitchen
SET KPT_ENGINE_PATH=%pdi_engine_path%
SET KPT_KETTLE_FILE=%current_script_dir%Project\CreateProject.kjb
SET KPT_KETTLE_PARAM_rName=%kpt_project_name%
SET KPT_KETTLE_PARAM_oCommand=%open_project_path%

CALL "%kpt_workspace_path%\shell\KPT_RUN_COMMAND.bat"
IF !ERRORLEVEL! NEQ 0 SET _result_code=1

SET KPT_COMMAND=
SET KPT_ENGINE_PATH=
SET KPT_KETTLE_FILE=
SET KPT_KETTLE_PARAM_rName=
SET KPT_KETTLE_PARAM_oCommand=


:end

IF %interactive% EQU 1 PAUSE
EXIT /B %_result_code%
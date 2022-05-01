@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-25
::FILE link_project
::DESC create a project and link to KPT source code
::SYNTAX link_project [kpt_project_name [kpt_workspace_path [pdi_engine_path [target_project_path [link_item_name_list [copy_item_name_list]]]]]]
::SYNTAX_DESC target_project_path: project path for link to
::SYNTAX link_item_name_list: name[;name]...
::SYNTAX copy_item_name_list: name[;name]...


:init_variable

::version
SET tip=Kettle-Project-Toolbox: link project
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
SET tip_kpt_project_name_input=Need input 'kpt_project_name' or drag path in:
SET tip_kpt_project_name_miss=Missing param 'kpt_project_name' at position 1.
SET tip_kpt_project_name_exist=keep this name[Y], or input new one[N]?(default N after 10 seconds)
SET tip_kpt_workspace_path_input=Need input 'kpt_workspace_path' or drag path in:
SET tip_kpt_workspace_path_miss=Missing param 'kpt_workspace_path' at position 2.
SET tip_kpt_workspace_path_wrong=Wrong param 'kpt_workspace_path' at position 2.
SET tip_pdi_engine_path_input=Need input 'pdi_engine_path' or drag path in:
SET tip_pdi_engine_path_miss=Missing param 'pdi_engine_path' at position 3.
SET tip_pdi_engine_path_wrong=Wrong param 'pdi_engine_path' at position 3.
SET tip_target_project_path_input=Need input 'target_project_path' or drag path in:
SET tip_target_project_path_miss=Missing param 'target_project_path' at position 4.
SET tip_target_project_path_wrong=Wrong param 'target_project_path' at position 4.
SET tip_link_item_name_input_first=Please input 'link_item_name' or use default[all folder] with empty input:
SET tip_link_item_name_input_again=Again input 'link_item_name' or end with empty input:
SET tip_link_item_name_miss=Missing param 'link_item_name' at position 5.
SET tip_copy_item_name_input_first=Please input 'copy_item_name' or use default[all file] with empty input:
SET tip_copy_item_name_input_again=Again input 'copy_item_name' or end with empty input:
SET tip_copy_item_name_miss=Missing param 'copy_item_name' at position 6.

::defult param
SET kpt_project_name=%kpt_project_name%
SET kpt_workspace_path=%kpt_workspace_path%
SET pdi_engine_path=%pdi_engine_path%
SET target_project_path=%target_project_path%
SET link_item_name_list=%link_item_name_list%
SET copy_item_name_list=%copy_item_name_list%
IF NOT "%1"=="" SET kpt_project_name=%~1
IF NOT "%2"=="" SET kpt_workspace_path=%~2
IF NOT "%3"=="" SET pdi_engine_path=%~3
IF NOT "%4"=="" SET target_project_path=%~4
IF NOT "%5"=="" SET link_item_name_list=%~5
IF NOT "%6"=="" SET copy_item_name_list=%~6
SET input_list=


:tip_version

IF %interactive% EQU 1 ( TITLE %tip% %ver% ) ELSE ( ECHO %tip% )


:loop_check_variable

IF "%kpt_workspace_path%"=="" (
    @REM ::auto discover pdi
    IF EXIST "%parent_folder_dir%data-integration\Spoon.bat" (
        FOR %%F IN (%parent_folder_dir%.) DO SET kpt_workspace_path=%%~dpnxF
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

IF "%target_project_path%"=="" (
    IF %interactive% EQU 1 (
        SET /P target_project_path=%tip_target_project_path_input%
        GOTO:loop_check_variable
    ) ELSE (
        ECHO %tip_target_project_path_miss%
        EXIT /B 1
    )
)
IF NOT EXIST "%target_project_path%" (
    IF %interactive% EQU 1 (
        ECHO not exist %target_project_path%
        SET target_project_path=
        GOTO:loop_check_variable
    ) ELSE (
        ECHO %tip_target_project_path_wrong%
        EXIT /B 1
    )
)

SET delimiter=;
SET input_item=
IF "!link_item_name_list!"=="" (
    IF %interactive% EQU 1 (
        :: tip item name for input
        DIR /B %target_project_path%
        SET /P input_item=!tip_link_item_name_input_first!
        IF "!input_item!"=="" (
            IF "!input_list!"=="" (
                :: default use all folder
                FOR /F "usebackq tokens=*" %%F IN (`DIR /B /A:D "%target_project_path%"`) DO (
                    SET link_item_name_list=!link_item_name_list!!delimiter!%%F
                )
                SET link_item_name_list=!link_item_name_list:~1!
            ) ELSE (
                :: input param end
                SET link_item_name_list=!input_list!
                SET input_list=
            )
        ) ELSE (
            IF "!input_list!"=="" SET delimiter=
            SET input_list=!input_list!!delimiter!!input_item!
            SET tip_link_item_name_input_first=%tip_link_item_name_input_again%
        )
        GOTO:loop_check_variable
    ) ELSE (
        ECHO %tip_link_item_name_miss%
        EXIT /B 1
    )
)


SET delimiter=;
SET input_item=
IF "!copy_item_name_list!"=="" (
    IF %interactive% EQU 1 (
        :: tip item name for input
        DIR /B %target_project_path%
        SET /P input_item=!tip_copy_item_name_input_first!
        IF "!input_item!"=="" (
            IF "!input_list!"=="" (
                :: default use all file
                FOR /F "usebackq tokens=*" %%F IN (`DIR /B /A:-D "%target_project_path%"`) DO (
                    SET copy_item_name_list=!copy_item_name_list!!delimiter!%%F
                )
                SET copy_item_name_list=!copy_item_name_list:~1!
            ) ELSE (
                :: input param end
                SET copy_item_name_list=!input_list!
                SET input_list=
            )
        ) ELSE (
            IF "!input_list!"=="" SET delimiter=
            SET input_list=!input_list!!delimiter!!input_item!
            SET tip_copy_item_name_input_first=%tip_copy_item_name_input_again%
        )
        GOTO:loop_check_variable
    ) ELSE (
        ECHO %tip_copy_item_name_miss%
        EXIT /B 1
    )
)


:begin

::print info
ECHO ==========%current_script_name%==========
ECHO Script directory is: %current_script_dir%
ECHO Kettle engine path is: %pdi_engine_path%
ECHO KPT workspace path is: %kpt_workspace_path%
ECHO KPT project name is: %kpt_project_name%
ECHO Target project path is: %target_project_path%
ECHO Target project sub item link list is: !NL!!link_item_name_list!
ECHO Target project sub item copy list is: !NL!!copy_item_name_list!
ECHO __________%current_script_name%__________

SET _result_code=0

::create project
SET _step=Step: create project '!kpt_project_name!'
ECHO:
ECHO:
ECHO ==========!_step!==========
CALL "%kpt_workspace_path%\tool\create_project.bat" "%kpt_project_name%" "%kpt_workspace_path%" "%pdi_engine_path%"
IF %ERRORLEVEL% NEQ 0 SET _result_code=1
ECHO ##########!_step!##########

::link project
SET _step=Step: link project '!kpt_project_name!'
ECHO:
ECHO:
ECHO ==========!_step!==========
SET link_project_path=%kpt_workspace_path%\%kpt_project_name%
SET target_project_path=%target_project_path%
SET link_item_name_list=%link_item_name_list%
SET copy_item_name_list=%copy_item_name_list%
CALL "%kpt_workspace_path%\shell\LINK_PROJECT.bat"
IF %ERRORLEVEL% NEQ 0 SET _result_code=1
ECHO ##########!_step!##########

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
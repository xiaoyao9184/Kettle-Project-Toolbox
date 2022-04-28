@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-25
::FILE LINK_PROJECT
::DESC create a project and link to KPT source code
::SYNTAX LINK_PROJECT [kpt_project_name [kpt_workspace_path [pdi_engine_path [kpt_folder_name [link_item_name_list [copy_item_name_list]]]]]]
::SYNTAX link_item_name_list: name[;name]...
::SYNTAX copy_item_name_list: name[;name]...
::SYNTAX_DESC kpt_folder_name: folder in kpt


:init_variable

::version
SET tip=Kettle-Project-Toolbox: link kpt folder to project
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
SET tip_kpt_workspace_path_wrong=Wrong param 'kpt_workspace_path' at position 1.
SET tip_kpt_project_name_input=Need input 'kpt_project_name' or drag path in:
SET tip_kpt_project_name_miss=Missing param 'kpt_project_name' at position 2.
SET tip_kpt_project_name_wrong=Wrong param 'kpt_project_name' at position 2.
SET tip_pdi_engine_path_input=Need input 'pdi_engine_path' or drag path in:
SET tip_pdi_engine_path_miss=Missing param 'pdi_engine_path' at position 3.
SET tip_pdi_engine_path_wrong=Wrong param 'pdi_engine_path' at position 3.
SET tip_kpt_folder_name_input=Need input 'kpt_folder_name' or drag path in:
SET tip_kpt_folder_name_miss=Missing param 'kpt_folder_name' at position 4.
SET tip_kpt_folder_name_wrong=Wrong param 'kpt_folder_name' at position 4.
SET tip_link_item_name_input_first=Please input 'link_item_name' or use default[all folder] with empty input:
SET tip_link_item_name_input_again=Again input 'link_item_name' or end with empty input:
SET tip_link_item_name_miss=Missing param 'kpt_folder_name' at position 5.
SET tip_copy_item_name_input_first=Please input 'copy_item_name' or use default[all file] with empty input:
SET tip_copy_item_name_input_again=Again input 'copy_item_name' or end with empty input:
SET tip_copy_item_name_miss=Missing param 'copy_item_name' at position 6.

::defult param
SET kpt_project_name=%kpt_project_name%
SET kpt_workspace_path=%kpt_workspace_path%
SET pdi_engine_path=%pdi_engine_path%
SET kpt_folder_name=%kpt_folder_name%
SET link_item_name_list=%link_item_name_list%
SET copy_item_name_list=%copy_item_name_list%
IF NOT "%1"=="" SET kpt_project_name=%~1
IF NOT "%2"=="" SET kpt_workspace_path=%~2
IF NOT "%3"=="" SET pdi_engine_path=%~3
IF NOT "%4"=="" SET kpt_folder_name=%~4
IF NOT "%5"=="" SET link_item_name_list=%5
IF NOT "%6"=="" SET copy_item_name_list=%6
SET input_list=


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
IF EXIST "%kpt_workspace_path%\%kpt_project_name%" (
    IF %interactive% EQU 1 (
        ECHO exist %kpt_workspace_path%\%kpt_project_name%
        SET kpt_project_name=
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_kpt_project_name_wrong%
        EXIT /B 1
    )
)

IF "%pdi_engine_path%"=="" (
    @REM ::auto discover pdi
    IF EXIST "%kpt_workspace_path%data-integration\Spoon.bat" (
        SET pdi_engine_path=%kpt_workspace_path%data-integration
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

IF "%kpt_folder_name%"=="" (
    IF %interactive% EQU 1 (
        DIR /B /A:D %parent_folder_dir%
        SET /P kpt_folder_name=%tip_kpt_folder_name_input%
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_kpt_folder_name_miss%
        EXIT /B 1
    )
)
IF NOT EXIST "%parent_folder_dir%%kpt_folder_name%" (
    IF %interactive% EQU 1 (
        ECHO not exist %parent_folder_dir%%kpt_folder_name%
        SET kpt_folder_name=
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_kpt_folder_name_wrong%
        EXIT /B 1
    )
)

SET delimiter=;
SET input_item=
IF "!link_item_name_list!"=="" (
    IF %interactive% EQU 1 (
        SET /P input_item=!tip_link_item_name_input_first!
        IF "!input_item!"=="" (
            IF "!input_list!"=="" (
                :: default use all folder
                FOR /F "usebackq tokens=*" %%F IN (`DIR /B /A:D "%parent_folder_dir%%kpt_folder_name%"`) DO (
                    SET link_item_name_list=!link_item_name_list!!delimiter!%%F
                )
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
) ELSE (
    :: to list for run FOR command
    SET link_item_name_list=!link_item_name_list:;=^

    !
    REM newline symbol two empty line required
)

SET delimiter=;
SET input_item=
IF "!copy_item_name_list!"=="" (
    IF %interactive% EQU 1 (
        SET /P input_item=!tip_link_item_name_first!
        IF "!input_item!"=="" (
            IF "!input_list!"=="" (
                :: default use all file
                FOR /F "usebackq tokens=*" %%F IN (`DIR /B /A:-D "%parent_folder_dir%%kpt_folder_name%"`) DO (
                    SET copy_item_name_list=!copy_item_name_list!!delimiter!%%F
                )
            ) ELSE (
                :: input param end
                SET copy_item_name_list=!input_list!
                SET input_list=
            )
        ) ELSE (
            IF "!input_list!"=="" SET delimiter=
            SET input_list=!input_list!!delimiter!!input_item!
            SET tip_link_item_name_first=%tip_link_item_name_again%
        )
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_copy_item_name_miss%
        EXIT /B 1
    )
) ELSE (
    :: to list for run FOR command
    SET copy_item_name_list=!copy_item_name_list:;=^

    !
    REM newline symbol two empty line required
)


:begin

::print info
ECHO ==========%current_script_name%==========
ECHO Script directory is: %current_script_dir%
ECHO KPT workspace path is: %kpt_workspace_path%
ECHO Project name is: %kpt_project_name%
ECHO KPT folder name is: %kpt_folder_name%
ECHO KPT folder sub item link list is: !NL!!link_item_name_list!
ECHO KPT folder sub item copy list is: !NL!!copy_item_name_list!
ECHO -----------------NOTE--------------------
ECHO windows not support hard link target to directory;
ECHO use 'junction'[soft link] for all, it can link across hard drives.
ECHO __________%current_script_name%__________


SET _result_code=0

::create project
SET _step=Step: create kpt project '!kpt_project_name!'
ECHO:
ECHO:
ECHO ==========!_step!==========
CALL %kpt_workspace_path%\tool\create_project.bat %kpt_project_name%
IF %ERRORLEVEL% NEQ 0 SET _result_code=1
ECHO ##########!_step!##########

::create link_strategy
IF %interactive% EQU 1 (
    ECHO:
) ELSE  (
    ECHO %tip_kpt_workspace_link_strategy%
    SET link_strategy=replace
    SET copy_strategy=/Y
)

::link item
FOR /F "delims=" %%S IN ("!link_item_name_list!") DO (
    SET link_name=%%S
    SET link_path=%kpt_workspace_path%\%kpt_project_name%\!link_name!
    SET target_path=%parent_folder_dir%%kpt_folder_name%\!link_name!
    
    SET _step=Step: link folder item '!link_name!'
    ECHO:
    ECHO:
    ECHO ==========!_step!==========
    CALL %current_script_dir%LINK_FOLDER.bat "!link_path!" "!target_path!" junction %link_strategy%
    IF !ERRORLEVEL! NEQ 0 SET _result_code=1
    ECHO ##########!_step!##########
)

::copy item
FOR /F "delims=" %%S IN ("!copy_item_name_list!") DO (
    SET copy_name=%%S
    SET copy_path=%kpt_workspace_path%\%kpt_project_name%\!copy_name!
    SET target_path=%parent_folder_dir%%kpt_folder_name%\!copy_name!
    
    SET _step=Step: copy folder item '!copy_name!'
    ECHO:
    ECHO:
    ECHO ==========!_step!==========
    XCOPY /E %copy_strategy% "!target_path!" "!copy_path!"
    IF !ERRORLEVEL! NEQ 0 SET _result_code=1
    ECHO ##########!_step!##########
)

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
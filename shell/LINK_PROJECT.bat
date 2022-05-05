@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-29
::FILE LINK_PROJECT
::DESC create some link to sub item of project
::SYNTAX LINK_PROJECT [link_project_path [target_project_path [link_item_name_list [copy_item_name_list]]]]
::SYNTAX link_item_name_list: name[;name]...
::SYNTAX copy_item_name_list: name[;name]...


:init_variable

::version
SET tip=Kettle-Project-Toolbox: link project with symbolic
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
    IF NOT "!KPT_QUIET!"=="" SET interactive=0
)

::script info
SET current_script_dir=%~dp0
SET current_script_name=%~n0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

::tip info
SET tip_link_project_path_input=Need input 'link_project_path' or drag path in:
SET tip_link_project_path_miss=Missing param 'link_project_path' at position 1.
SET tip_link_project_path_wrong=Wrong param 'link_project_path' at position 1.
SET tip_target_project_path_input=Need input 'target_project_path' or drag path in:
SET tip_target_project_path_miss=Missing param 'target_project_path' at position 2.
SET tip_target_project_path_wrong=Wrong param 'target_project_path' at position 2.
SET tip_link_item_name_input_first=Please input 'link_item_name' or use default[all folder] with empty input:
SET tip_link_item_name_input_again=Again input 'link_item_name' or end with empty input:
SET tip_link_item_name_miss=Missing param 'target_project_path' at position 3.
SET tip_copy_item_name_input_first=Please input 'copy_item_name' or use default[all file] with empty input:
SET tip_copy_item_name_input_again=Again input 'copy_item_name' or end with empty input:
SET tip_copy_item_name_miss=Missing param 'copy_item_name' at position 4.
SET tip_link_strategy=If target item exist will force replace
SET tip_copy_item_exist_skip=Skip copy item because exists

::defult param
SET link_project_path=%link_project_path%
SET target_project_path=%target_project_path%
SET link_item_name_list=%link_item_name_list%
SET copy_item_name_list=%copy_item_name_list%
IF NOT "%1"=="" SET link_project_path=%~1
IF NOT "%2"=="" SET target_project_path=%~2
IF NOT "%3"=="" SET link_item_name_list=%3
IF NOT "%4"=="" SET copy_item_name_list=%4
SET input_list=


:tip_version

IF %interactive% EQU 1 ( TITLE %tip% %ver% ) ELSE ( ECHO %tip% )


:loop_check_variable

IF "%link_project_path%"=="" (
    IF %interactive% EQU 1 (
        SET /P link_project_path=%tip_link_project_path_input%
        GOTO:loop_check_variable
    ) ELSE (
        ECHO %tip_link_project_path_miss%
        EXIT /B 1
    )
)
IF NOT EXIST "%link_project_path%" (
    IF %interactive% EQU 1 (
        ECHO exist %link_project_path%
        SET link_project_path=
        GOTO:loop_check_variable
    ) ELSE (
        ECHO %tip_link_project_path_wrong%
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
:: to list for run FOR command
SET link_item_name_list=!link_item_name_list:;=^

!
REM newline symbol two empty line required


SET delimiter=;
SET input_item=
IF "!copy_item_name_list!"=="" (
    IF %interactive% EQU 1 (
        :: tip item name for input
        DIR /B %target_project_path%
        SET /P input_item=!tip_link_item_name_first!
        IF "!input_item!"=="" (
            IF "!input_list!"=="" (
                :: default use all file
                FOR /F "usebackq tokens=*" %%F IN (`DIR /B /A:-D "%target_project_path%"`) DO (
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
)
:: to list for run FOR command
SET copy_item_name_list=!copy_item_name_list:;=^

!
REM newline symbol two empty line required


:begin

::print info
ECHO ==========%current_script_name%==========
ECHO Script directory is: %current_script_dir%
ECHO Link project path is: %link_project_path%
ECHO Target project path is: %target_project_path%
ECHO Target project sub item link list is: !NL!!link_item_name_list!
ECHO Target project sub item copy list is: !NL!!copy_item_name_list!
ECHO -----------------NOTE--------------------
ECHO windows not support hard link target to directory;
ECHO use 'junction'[soft link] for all, it can link across hard drives.
ECHO __________%current_script_name%__________

SET _result_code=0

::create link_strategy
IF %interactive% EQU 1 (
    ECHO:
) ELSE  (
    ECHO %tip_link_strategy%
    SET link_strategy=replace
    SET copy_strategy=/Y
)

::link item
FOR /F "delims=" %%S IN ("!link_item_name_list!") DO (
    SET link_name=%%S
    SET link_path=%link_project_path%\!link_name!
    SET target_path=%target_project_path%\!link_name!
   
    SET _step=Step: link item '!link_name!'
    ECHO:
    ECHO:
    ECHO ==========!_step!==========
    IF EXIST !target_path!\NUL (
        CALL %current_script_dir%LINK_FOLDER.bat "!link_path!" "!target_path!" junction %link_strategy%
    ) ELSE (
        MKLINK "!link_path!" "!target_path!"
    )
    IF !ERRORLEVEL! NEQ 0 SET _result_code=1
    ECHO ##########!_step!##########
)

::copy item
FOR /F "delims=" %%S IN ("!copy_item_name_list!") DO (
    SET copy_name=%%S
    SET copy_path=%link_project_path%\!copy_name!
    SET target_path=%target_project_path%\!copy_name!
   
    SET _step=Step: copy item '!copy_name!'
    ECHO:
    ECHO:
    ECHO ==========!_step!==========
    IF EXIST "!copy_path!" (
        ECHO %tip_copy_item_exist_skip%
    ) ELSE (
        IF EXIST !target_path!\NUL (
            XCOPY /E %copy_strategy% "!target_path!" "!copy_path!\"
        ) ELSE (
            COPY %copy_strategy% "!target_path!" "!copy_path!"
        )
    )
    
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
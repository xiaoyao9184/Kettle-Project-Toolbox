@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-16
::FILE UPDATE_SCRIPT
::SYNTAX UPDATE_SCRIPT [target_path [source_path]]
::SYNTAX target_path: path[;path]...
::SYNTAX source_path: path[;path]...


:init_variable

::version
SET tip=Kettle-Project-Toolbox: update script
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

::interactive tip
SET tip_target_path_input_first=Please input target_path or drag path in[empty use default '../default']:
SET tip_target_path_input_again=Again input target_path or drag path in[empty end]:
SET tip_target_path_miss=Missing param 'target_path' at position 1.
SET tip_source_path_input_first=Please input source_path or drag path in[empty use default '../shell']:
SET tip_source_path_input_again=Again input source_path or drag path in[empty end]:
SET tip_source_path_miss=Missing param 'source_path' at position 1.

::default param
SET target_path_list=%1
SET source_path_list=%2
SET default_target_path_list=%current_script_dir%..\default
SET default_source_path_list=%current_script_dir%..\shell
SET input_list=


:tip_version

IF %interactive% EQU 1 ( TITLE %tip% %ver% ) ELSE ( ECHO %tip% )


:loop_check_variable

SET delimiter=;
SET input_item=
IF "!target_path_list!"=="" (
    IF %interactive% EQU 1 (
        SET /P input_item=!tip_target_path_input_first!
        IF "!input_item!"=="" (
            IF "!input_list!"=="" (
                :: default param use 'default_target_path_list'
                SET target_path_list=%default_target_path_list%
            ) ELSE (
                :: input param end
                SET target_path_list=!input_list!
                SET input_list=
            )
        ) ELSE (
            IF "!input_list!"=="" SET delimiter=
            SET input_list=!input_list!!delimiter!!input_item!
            SET tip_target_path_input_first=%tip_target_path_input_again%
        )
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_target_path_miss%
        EXIT /B 1
    )
) ELSE (
    :: to list for run FOR command
    SET target_path_list=!target_path_list:;=^

    !
    REM newline symbol two empty line required
    :: to absolute path
    SET path_list=!target_path_list!
    SET target_path_list=
    FOR /F %%L IN ("!path_list!") DO (
        SET path_item=%%L
        ::remove "
        SET path_item=!path_item:"=!
        FOR %%F IN (!path_item!.) DO SET path_item=%%~dpnF
        SET target_path_list=!target_path_list!!NL!!path_item!
    )
)

SET delimiter=;
SET input_item=
IF "!source_path_list!"=="" (
    IF %interactive% EQU 1 ( 
        SET /P input_item=!tip_source_path_input_first!
        IF "!input_item!"=="" (
            IF "!input_list!"=="" (
                :: default param use 'default_target_path_list'
                SET source_path_list=%default_source_path_list%
            ) ELSE (
                :: input param end
                SET source_path_list=!input_list!
                SET input_list=
            )
        ) ELSE (
            IF "!input_list!"=="" SET delimiter=
            SET input_list=!input_list!!delimiter!!input_item!
            SET tip_source_path_input_first=%tip_source_path_input_again%
        )
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_source_path_miss%
        EXIT /B 1
    )
) ELSE (
    :: to list for run FOR command
    SET source_path_list=!source_path_list:;=^

    !
    REM newline symbol two empty line required
    :: to absolute path
    SET path_list=!source_path_list!
    SET source_path_list=
    FOR /F %%L IN ("!path_list!") DO (
        SET path_item=%%L
        ::remove "
        SET path_item=!path_item:"=!
        FOR %%F IN (!path_item!.) DO SET path_item=%%~dpnF
        SET source_path_list=!source_path_list!!NL!!path_item!
    )
)


:begin

::print info
ECHO ==========%current_script_name%==========
ECHO Work directory is: %current_script_dir%
ECHO Target directory is: !NL!!target_path_list!
ECHO Source directory is: !NL!!source_path_list!
ECHO __________%current_script_name%__________

SET _result_code=0

::bat
FOR /F "delims=" %%T IN ("!target_path_list!") DO (
    FOR %%f IN (%%T\*.bat) DO (
        SET target_file_path=%%f
        FOR /F "tokens=1,2 delims= " %%A IN (!target_file_path!) DO (
            IF "%%A"=="::FILE" (
                SET source_file_name=%%B.bat
                FOR /F "delims=" %%S IN ("!source_path_list!") DO (
                    SET source_dir=%%S
                    SET source_file_path=!source_dir!\!source_file_name!
                    IF EXIST "!source_file_path!" (
                        ECHO !target_file_path! ^<- !source_file_path!
                        COPY /Y "!source_file_path!" "!target_file_path!"
                        IF !ERRORLEVEL! NEQ 0 SET _result_code=1
                    )
                )
            )
        )
    )
)

::sh
FOR /F "delims=" %%T IN ("!target_path_list!") DO (
    FOR %%f IN (%%T\*.sh) DO (
        SET target_file_path=%%f
        FOR /F "tokens=1,2,3 delims= " %%A IN (!target_file_path!) DO (
            IF "%%B"=="FILE" (
                SET source_file_name=%%C.sh
                FOR /F "delims=" %%S IN ("!source_path_list!") DO (
                    SET source_dir=%%S
                    SET source_file_path=!source_dir!\!source_file_name!
                    IF EXIST "!source_file_path!" (
                        ECHO !target_file_path! ^<- !source_file_path!
                        COPY /Y "!source_file_path!" "!target_file_path!"
                        IF !ERRORLEVEL! NEQ 0 SET _result_code=1
                    )
                )
            )
        )
    )
)

::done command
ECHO:
IF %_result_code% EQU 0 (
    ECHO Ok, run done!
) ELSE (
    ECHO Sorry, some error '%_result_code%' make failure!
)


:end

IF %interactive% EQU 1 PAUSE
EXIT /B %_result_code%
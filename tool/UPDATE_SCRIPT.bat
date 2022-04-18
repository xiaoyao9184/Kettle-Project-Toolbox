@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-16
::FILE UPDATE_SCRIPT
::SYNTAX UPDATE_SCRIPT: [target_path [source_path]]
::SYNTAX target_path: path[;path]...
::SYNTAX source_path: path[;path]...

:init_variable

::version
SET tip=Kettle-Project-Toolbox: update script
SET ver=1.0
SET NL=^


REM two empty line required

::interactive 1 for true
ECHO %CMDCMDLINE% | FIND /I "%~0" >NUL
IF NOT ERRORLEVEL 1 ( SET interactive=0 ) ELSE ( SET interactive=1 )

::script info
SET current_script_dir=%~dp0

::interactive tip
SET tip_set_target_path=Please input target_path or drag path in[empty use default '../default']:
SET tip_set_target_path_again=Again input target_path or drag path in[empty end]:
SET tip_miss_target_path=Missing param 'target_path' at position 1.
SET tip_set_source_path=Please input source_path or drag path in[empty use default '../Window;../Linux']:
SET tip_set_source_path_again=Again input source_path or drag path in[empty end]:
SET tip_miss_source_path=Missing param 'source_path' at position 1.

::default param
SET target_path_list=%1
SET source_path_list=%2
SET default_target_path_list=%current_script_dir%..\default
SET default_source_path_list=%current_script_dir%..\Windows;%current_script_dir%..\Linux
SET input_list=


:tip_version

IF %interactive% equ 1 ( TITLE %tip% %ver% ) ELSE ( ECHO %tip% )


:loop_check_variable

SET delimiter=;
SET input_item=

IF "!target_path_list!"=="" (
    IF %interactive% equ 1 (
        SET /p input_item=!tip_set_target_path!
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
            SET tip_set_target_path=%tip_set_target_path_again%
        )
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_miss_target_path%
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

IF "!source_path_list!"=="" (
    IF %interactive% equ 1 ( 
        SET /p input_item=!tip_set_source_path!
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
            SET tip_set_source_path=%tip_set_source_path_again%
        )
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_miss_source_path%
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

::print info for debug
ECHO ===========================================================
ECHO Work directory is: %current_script_dir%
ECHO Target directory is: !NL!!target_path_list!
ECHO Source directory is: !NL!!source_path_list!
ECHO ===========================================================
ECHO Running...      Ctrl+C for exit

::change to script directory
CD %current_script_dir%

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
                    IF EXIST !source_file_path! (
                        ECHO !target_file_path! ^<- !source_file_path!
                        COPY /Y "!source_file_path!" "!target_file_path!"
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
                    IF EXIST !source_file_path! (
                        ECHO !target_file_path! ^<- !source_file_path!
                        COPY /Y "!source_file_path!" "!target_file_path!"
                    )
                )
            )
        )
    )
)


:done

IF %ERRORLEVEL% equ 0 (
    ECHO Ok, run done!
) ELSE (
    ECHO Sorry, some error make failure!
)


:end

IF %interactive% equ 1 PAUSE
EXIT /b %ERRORLEVEL%
@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-16
::FILE UPDATE_SCRIPT
::SYNTAX UPDATE_SCRIPT [target_path [source_path_list]... ]

:init_variable

::version
SET tip=Kettle-Project-Toolbox: update script
SET ver=1.0
SET NL=^


rem two empty line required

::interactive 1 for true
ECHO %CMDCMDLINE% | FIND /I "%~0" >NUL
IF NOT ERRORLEVEL 1 ( SET interactive=0 ) ELSE ( SET interactive=1 )

::script info
SET current_script_dir=%~dp0

::interactive tip
SET tip_set_target_path=Please input target_path or drag path in[empty is ../default]:
SET tip_miss_target_path=Missing param 'target_path' at position 1.
SET stip_set_source_path=Please input source_path_list or drag path in[empty is ../Window and ../Linux]:
SET tip_miss_source_path=Missing param 'source_path_list' at position 1.

::default param
SET target_path=%1
SET source_path_list=


:tip_version

IF %interactive% equ 1 ( TITLE %tip% %ver% ) ELSE ( ECHO %tip% )


:check_variable

IF "%target_path%"=="" (
    IF %interactive% equ 1 ( 
        SET /p target_path=%tip_set_target_path%
        IF "!target_path!"=="" SET target_path=%current_script_dir%..\default
        GOTO:check_variable
    ) ELSE ( 
        ECHO %tip_miss_target_path%
        EXIT /B 1
    )
) ELSE (
    SHIFT
)
FOR %%F IN (%target_path%.) DO SET target_path=%%~dpnF

:loop__source_path_list
    IF "%1"=="" GOTO:end__source_path_list
    FOR %%F IN (%1.) DO SET source_path=%%~dpnF
    IF "!source_path_list!"=="" (
        SET source_path_list=!source_path!
    ) ELSE (
        SET source_path_list=!source_path_list!!NL!!source_path!
    )
    SHIFT
    GOTO:loop__source_path_list
:end__source_path_list

IF "!source_path_list!"=="" (
    IF %interactive% equ 1 ( 
        SET /p source_path_list=%stip_set_source_path%
        IF "!source_path_list!"=="" (
            FOR %%F IN (%current_script_dir%..\Windows) DO SET source_windows=%%~dpnF
            FOR %%F IN (%current_script_dir%..\Linux) DO SET source_linux=%%~dpnF
            SET source_path_list=!source_windows!!NL!!source_linux!
        )
        GOTO:check_variable
    ) ELSE ( 
        ECHO %tip_miss_source_path%
        EXIT /B 1
    )
)


:begin

::print info for debug
ECHO ===========================================================
ECHO Work directory is: %current_script_dir%
ECHO Target directory is: %target_path%
ECHO Source directory is: 
ECHO !source_path_list!
ECHO ===========================================================
ECHO Running...      Ctrl+C for exit

::change to script directory
CD %current_script_dir%

::bat
FOR %%f IN (%target_path%\*.bat) DO (
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

::sh
FOR %%f IN (%target_path%\*.sh) DO (
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


:done

IF %ERRORLEVEL% equ 0 (
    ECHO Ok, run done!
) ELSE (
    ECHO Sorry, some error make failure!
)


:end

IF %interactive% equ 1 PAUSE
EXIT /b %ERRORLEVEL%
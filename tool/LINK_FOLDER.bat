@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2017-09-05
::FILE LINK_FOLDER
::DESC create a symbolic link(Junction) for directory
::SYNTAX LINK_FOLDER [link_path [target_path [link_type [exist_strategy]]]]
::SYNTAX link_type: symbolic | junction | copy_link
::SYNTAX exist_strategy: remove | replace | none | ...


GOTO:init_variable


:function_uac
    ECHO Auto requires elevated privileges...
    @REM https://stackoverflow.com/questions/6811372/how-to-code-a-bat-file-to-always-run-as-admin-mode
    SET _vbsFile=%temp%\%~n0.vbs
    SET _batchFile=%~f0
       SET _Args=%*
       SET _batchFile=""%_batchFile:"=%""
       SET _Args=%_Args:"=""%
       ECHO Set UAC = CreateObject^("Shell.Application"^) > "%_vbsFile%"
    ECHO UAC.ShellExecute "cmd", "/c ""%_batchFile% %_Args%""", "", "runas", 1 >> "%_vbsFile%"
       CSCRIPT "%_vbsFile%"
    DEL "%_vbsFile%"
GOTO:EOF


:init_variable

::version
SET tip=Kettle-Project-Toolbox: link directory with symbolic
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

::tip info
SET tip_link_path_input=Need input 'link_path' or drag path in:
SET tip_link_path_miss=Missing param 'link_path' at position 1.
SET tip_target_path_input=Need input 'target_path' or drag path in:
SET tip_target_path_miss=Missing param 'target_path' at position 2.
SET tip_target_path_wrong=Wrong param 'target_path' at position 2.
SET tip_exist_symbolic_link=Already exists symbolic link of link_path!
SET tip_exist_normal_path=Already exists normal path of link_path!
SET tip_exist_strategy_choice=[D]ele, [R]eplace or [N]othing to do?(default N after 10 seconds)
SET tip_exist_strategy_miss=Missing param 'exist_strategy' at position 3.
SET tip_exist_symbolic_remove=Remove exist symbolic link
SET tip_exist_normal_remove=Remove exist directory
SET tip_exist_none=Nothing to do with exist
SET tip_none=Nothing to do
SET tip_request_superuser=symbolic or hard link need super user

::defult param
SET link_path=%~1
SET target_path=%~2
SET link_type=%3
SET exist_strategy=%4
SET exist_type=not


:tip_version

IF %interactive% EQU 1 ( TITLE %tip% %ver% ) ELSE ( ECHO %tip% )


:loop_check_variable

IF "%link_path%"=="" (
    IF %interactive% EQU 1 (
        SET /P link_path=%tip_link_path_input%
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_link_path_miss%
        EXIT /B 1
    )
)

IF "%target_path%"=="" (
    IF %interactive% EQU 1 (
        SET /P target_path=%tip_target_path_input%
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_target_path_miss%
        EXIT /B 1
    )
)
IF NOT EXIST "%target_path%" (
    IF %interactive% EQU 1 (
        ECHO not exist %target_path%
        SET target_path=
        GOTO:loop_check_variable
    ) ELSE ( 
        ECHO %tip_target_path_wrong%
        EXIT /B 1
    )
)

IF "%link_type%"=="" (
    SET link_type=symbolic
)

IF NOT "%link_type%"=="junction" (
    ECHO %tip_request_superuser%
    WHOAMI /GROUPS | FIND "12288" >NUL
    IF ERRORLEVEL 1 (
        CALL :function_uac %link_path% %target_path% %link_type% 
        GOTO:EOF
    )
)

::exist_strategy
::exist_type
IF EXIST "%link_path%" (
    FOR %%F IN ("%link_path%") DO SET attributes=%%~aF
    IF "!attributes:l=!" NEQ "!attributes!" (
        SET exist_type=link
        ECHO %tip_exist_symbolic_link%
    ) ELSE (
        SET exist_type=normal
        ECHO %tip_exist_normal_path%
    )
    ::link_path exist with no exist_strategy
    IF "%exist_strategy%"=="" (
        IF %interactive% EQU 1 (
            CHOICE /c drn /m "%tip_exist_strategy_choice%" /t 10 /d n
            IF !ERRORLEVEL! EQU 1 (
                SET exist_strategy=remove
            ) ELSE IF !ERRORLEVEL! EQU 2 (
                SET exist_strategy=replace
            ) ELSE IF !ERRORLEVEL! EQU 3 (
                SET exist_strategy=none
            )
            GOTO:loop_check_variable
        ) ELSE ( 
            ECHO %tip_exist_strategy_miss%
            EXIT /B 1
        )
    )
)


:begin

::print info
ECHO ==========%current_script_name%==========
ECHO Work directory is: %current_script_dir%
ECHO Link path is: %link_path%
ECHO Target path is: %target_path%
ECHO Exist type is: %exist_type%
ECHO Exist strategy is: %exist_strategy%
ECHO Link type is: %link_type%
ECHO -----------------NOTE--------------------
ECHO windows not support hard link directory, 
ECHO windows hard link file cant across hard drives;
ECHO use 'symbolic' link, not recommended.
ECHO use 'junction' link, it can link across hard drives.
ECHO use 'copy_link' copy folder and symbolic link file.
ECHO __________%current_script_name%__________

::remove exist
IF "%exist_type%"=="link" (
    IF "!exist_strategy!"=="remove" (
        ECHO %tip_exist_symbolic_remove%
        RD /S /Q %link_path%
        SET link_type=none
    ) ELSE IF "!exist_strategy!"=="replace" (
        ECHO %tip_exist_symbolic_remove%
        RD /S /Q %link_path%
    ) ELSE IF "!exist_strategy!"=="none" (
        ECHO %tip_exist_none%
        SET link_type=none
    )
) ELSE IF "%exist_type%"=="normal" (
    IF "!exist_strategy!"=="remove" (
        ECHO %tip_exist_normal_remove%
        RD /S /Q %link_path%
        SET link_type=none
    ) ELSE IF "!exist_strategy!"=="replace" (
        ECHO %tip_exist_normal_remove%
        RD /S /Q %link_path%
    ) ELSE IF "!exist_strategy!"=="none" (
        ECHO %tip_exist_none%
        SET link_type=none
    )
)

SET _result_code=0

::run command
ECHO --------------------
IF "%link_type%"=="symbolic" (
    MKLINK /D "%link_path%" "%target_path%"
    IF !ERRORLEVEL! NEQ 0 SET _result_code=1
) ELSE IF "%link_type%"=="junction" (
    MKLINK /J "%link_path%" "%target_path%"
    IF !ERRORLEVEL! NEQ 0 SET _result_code=1
) ELSE IF "%link_type%"=="copy_link" (
    MD "%link_path%"
    XCOPY /T /E "%target_path%" "%link_path%"
    FOR /F "usebackq tokens=*" %%F IN (`WHERE /R "%target_path%" *`) DO (
        SET _target_file_path=%%~F
        CALL SET "_link_file_path=!!_target_file_path:%target_path%=%link_path%!!"
        MKLINK "!_link_file_path!" "!_target_file_path!" >NUL
        IF !ERRORLEVEL! NEQ 0 (
            SET _result_code=1
        ) ELSE (
            IF %interactive% EQU 1 ( ECHO | SET /P dummy=. )
        )
    )
) ELSE IF "%link_type%"=="none" (
    ECHO %tip_none%
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
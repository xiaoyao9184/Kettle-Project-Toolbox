@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-21
::FILE KPT_RUN_COMMAND


GOTO:init_variable


@REM ::
@REM ::https://www.robvanderwoude.com/battech_convertcase.php
:function_lower
    SETLOCAL EnableDelayedExpansion
    SET _LCase=a b c d e f g h i j k l m n o p q r s t u v w x y z
    SET _Lib_UCase_Tmp=!%1!
    FOR %%Z IN (%_LCase%) DO SET _Lib_UCase_Tmp=!_Lib_UCase_Tmp:%%Z=%%Z!
    ENDLOCAL & (
        SET %2=%_Lib_UCase_Tmp%
    )
GOTO:EOF


@REM :: parse environment variable to kettle command param name and value
@REM ::KPT_KETTLE_PARAM_ prefix will extract prefix for the value, set param name to 'param'
@REM ::1. Remove prefix KPT_KETTLE_PARAM_
@REM ::2. Replace a period (.) with a single underscore (_).
@REM ::3. Replace a dash (-) with double underscores (__).
@REM ::4. Replace an underscore (_) with triple underscores (___).
@REM ::5. Replace value concatenate equal-sign(=) with value
@REM ::
@REM ::other environment variable extract param name
@REM ::1. Remove prefix KPT_KETTLE_
@REM ::2. Upper case
@REM ::
:function_param_parse
    SETLOCAL EnableDelayedExpansion
    SET kettle_param_name=%~1
    SET kettle_param_value=%~2

    @REM ::remove prefix
    SET kettle_param_name=!kettle_param_name:KPT_KETTLE_=!
    IF /I "!kettle_param_name:~0,6!"=="PARAM_" (
        @REM ::remove prefix
        SET kettle_param_name=!kettle_param_name:PARAM_=!

        @REM ::replace
        SET kettle_param_name=!kettle_param_name:___=_!
        SET kettle_param_name=!kettle_param_name:__=-!
        SET kettle_param_name=!kettle_param_name:_=.!

        @REM ::recreate value
        SET kettle_param_value=!kettle_param_name!=!kettle_param_value!
        SET kettle_param_name=param
    ) ELSE IF "!kettle_param_name:_=!"=="!kettle_param_name!" (
        @REM ::lower case
        CALL :function_lower kettle_param_name kettle_param_name
    ) ELSE (
        ::ignore underlined variable
        SET kettle_param_name=
        SET kettle_param_value=
    )

    ENDLOCAL & (
        SET %3=%kettle_param_name%
        SET %4=%kettle_param_value%
    )
GOTO:EOF


@REM :: generation kettle command positional parameters 
@REM ::1. Empty value not need append to result
@REM ::2. Contain spaces need add quotation
:function_param_generation
    SETLOCAL EnableDelayedExpansion
    SET kettle_param_name=%~1
    :: remove quotation
    SET kettle_param_value=%~2

    @REM ::check value is empty
    IF "!kettle_param_value!"=="" SET empty_value=true
    IF "!kettle_param_value!"==" " SET empty_value=true
    IF "!kettle_param_value::=!"=="" SET empty_value=true

    @REM ::start with name
    SET command_param=/%kettle_param_name%

    @REM ::append value if need
    IF NOT "%empty_value%"=="true" (
        SET command_param=%command_param%:%kettle_param_value%
    )

    @REM ::add quotation marks if spaces in param
    IF NOT "%command_param: =%"=="%command_param%" (
        SET command_param="%command_param%"
    ) ELSE (
        @REM ::https://stackoverflow.com/questions/3777110/remove-an-equals-symbol-from-text-string
        FOR /F "usebackq delims== tokens=1-2" %%A IN (`ECHO !command_param!`) DO (
            IF NOT "%%B"=="" SET command_param="%command_param%"
        )
    )

    ENDLOCAL & (
        SET %3=%command_param%
    )
GOTO:EOF


:init_variable

::version
SET tip=Kettle-Project-Toolbox: Run kitchen or pan
SET ver=1.0

::interactive 1 for true
SET interactive=1
IF NOT "!JENKINS_HOME!"=="" SET interactive=0
IF NOT "!DEBUG!"=="" SET interactive=0
IF NOT "!KPT_QUIET!"=="" SET interactive=0

::script info
SET current_script_dir=%~dp0
SET current_script_name=%~n0

::interactive tip
SET tip_set_engine_dir=Please input or drop kettle engine path:
SET tip_miss_engine_dir=Missing param '_engine_dir' at environment variable 'KPT_ENGINE_PATH'.
SET tip_set_full_file_path=Please input or drop kettle file path:
SET tip_set_repository_item_path=Please input repository kettle file path [use / delimiter include extension]:
SET tip_choice_command_name=Please choice kettle command: [J]ob or [T]ransformation?
SET tip_miss_command_name=Missing param '_command_name' at environment variable 'KPT_COMMAND'.

::default param
IF EXIST "%current_script_dir%KPT_EXPORT_ENVIRONMENT.bat" (
    CALL %current_script_dir%KPT_EXPORT_ENVIRONMENT.bat %0
)
SET _engine_dir=%KPT_ENGINE_PATH%\
SET _command_name=%KPT_COMMAND%
SET _log_redirect=%KPT_LOG_PATH%


:tip_version

IF %interactive% EQU 1 ( TITLE %tip% %ver% ) ELSE ( ECHO %tip% )


:loop_check_variable

IF %interactive% EQU 1 (
    IF "%_command_name%"=="" (
        @REM :: check input exist
        IF "%KETTLE_REPOSITORY%"=="" (
            SET /P _file_path=%tip_set_full_file_path%
        ) ELSE (
            SET /P _item_path=%tip_set_repository_item_path%
            SET _file_path=%KPT_PROJECT_PATH%\!_item_path:/=\!
        )
        IF NOT EXIST !_file_path! ECHO not exist !_file_path! &  GOTO:loop_check_variable
        @REM :: set _command_name
        FOR %%F IN (!_file_path!) DO SET _file_ext=%%~xF
        IF "!_file_ext!"==".kjb" (
            SET _command_name=kitchen
        ) ELSE IF "!_file_ext!"==".ktr" (
            SET _command_name=pan
        )
        @REM :: set KPT variable
        IF "%KETTLE_REPOSITORY%"=="" (
            FOR %%F IN (!_file_path!) DO SET _file_path=%%~dpnxF
            SET KPT_KETTLE_FILE=!_file_path!
        ) ELSE IF "!_file_ext!"==".kjb" (
            SET KPT_KETTLE_JOB=!_item_path:.kjb=!
        ) ELSE IF "!_file_ext!"==".ktr" (
            SET KPT_KETTLE_TRANS=!_item_path:.ktr=!
        )
        GOTO:loop_check_variable
    )
    WHERE /Q !_command_name!
    IF !ERRORLEVEL! EQU 0 SET _engine_dir=
    IF "%_engine_dir%"=="\" (
        SET /P _engine_dir=%tip_set_engine_dir%
        FOR %%F IN (!_engine_dir!.) DO SET _engine_dir=%%~dpnF\
        GOTO:loop_check_variable
    )
) ELSE ( 
    IF "%_engine_dir%"=="\" (
        ECHO %tip_miss_engine_dir%
        EXIT /B 1
    )
    IF "%_command_name%"=="" (
        ECHO %tip_miss_command_name%
        EXIT /B 1
    )
)


:begin

::print info
@REM IF %interactive% EQU 1 CLS
ECHO ==========%~n0==========
ECHO Script directory is: %current_script_dir%
ECHO Engine directory is: %_engine_dir%
ECHO Command name is: %_command_name%
ECHO Command log is: %_log_redirect%
ECHO __________%~n0__________

::create command
SET _command_opt=
FOR /F "delims== tokens=1,2" %%A IN ('SET ^| FINDSTR /I /R "^KPT_KETTLE_"') DO (
    SET _result_param_name=
    SET _result_param_value=
    SET _result_param=
    CALL :function_param_parse "%%A" "%%B" _result_param_name _result_param_value
    CALL :function_param_generation "!_result_param_name!" "!_result_param_value!" _result_param
    IF NOT DEFINED _command_opt (
        SET _command_opt=!_result_param!
    ) ELSE (
        SET _command_opt=!_command_opt! !_result_param!
    )
)
SET _command=%_engine_dir%%_command_name% !_command_opt!

::print command
ECHO %_command%

::run command
ECHO:
IF "%_log_redirect%"=="" (
    CALL %_command%
) ELSE (
    CALL %_command%>>"%_log_redirect%"
)

::done command

ECHO:
IF %ERRORLEVEL% EQU 0 (
    ECHO Ok, run done!
) ELSE (
    ECHO Sorry, some error '%ERRORLEVEL%' make failure!
)

ECHO ##########%~n0##########


:end

IF %interactive% EQU 1 PAUSE
EXIT /B %ERRORLEVEL%
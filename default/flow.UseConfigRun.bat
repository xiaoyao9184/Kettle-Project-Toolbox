@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-21
::FILE KPT_RUN_COMMAND


GOTO:init_variable


@REM ::
:function_dequote
    FOR /F "delims=" %%A IN ('ECHO %%%1%%') DO IF "%2"=="" (SET %1=%%~A) ELSE (SET %2=%%~A)
GOTO:EOF


@REM ::
:function_get_by_name
    SET %2=!%1!
GOTO:EOF


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


@REM ::
:function_replace
    SETLOCAL EnableDelayedExpansion
    SET _str=!%1!
    SET _str=!_str:___=_!
    SET _str=!_str:__=-!
    SET _str=!_str:_=.!

    ENDLOCAL & (
        SET %2=%_str%
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
:function_env_parse_option
    SETLOCAL EnableDelayedExpansion
    CALL :function_dequote %1 command_name
    CALL :function_dequote %2 env_name
    CALL :function_dequote %3 env_value

    @REM ::default use kettle windows options
    SET option_type=/

    @REM ::default use long options
    IF "%command_name%"=="maitre" SET option_type=long

    @REM ::remove prefix
    SET option_name=!env_name:KPT_KETTLE_=!

    IF /I "!option_name:~0,6!"=="PARAM_" (
        @REM ::need append value for 'param' option
        SET option_value_prefix=!option_name:~6!
        SET option_name=param
    ) ELSE IF /I "!option_name:~0,31!"=="ADD__VARIABLE__TO__ENVIRONMENT_" (
        @REM ::need append value for 'add-variable-to-environment' option
        SET option_value_prefix=!option_name:~31!
        SET option_name=add-variable-to-environment
    ) ELSE IF /I "!option_name:~0,3!"=="_V_" (
        @REM ::need append value for 'V' option
        SET option_value_prefix=!option_name:~3!
        SET option_name=V
        SET option_type=short
    ) ELSE IF /I "!option_name:~0,1!"=="_" (
        @REM ::remove _ prefix
        SET option_name=!option_name:~1!
        SET option_type=short
    ) ELSE (
        CALL :function_lower option_name option_name
        CALL :function_replace option_name option_name
    )

    @REM ::recreate option value
    IF NOT "%option_value_prefix%"=="" (
        CALL :function_replace option_value_prefix option_value_prefix
        SET option_value=%option_value_prefix%=%env_value%
    ) ELSE (
        SET option_value=%env_value%
    )

    ENDLOCAL & (
        SET %4=%option_type%
        SET %5=%option_name%
        SET %6=%option_value%
    )
GOTO:EOF


@REM :: generation kettle command positional parameters 
@REM ::1. Empty value not need append to result
@REM ::2. Contain spaces need add quotation
:function_option_parameter_generation
    SETLOCAL EnableDelayedExpansion
    SET option_type=!%1!
    SET option_name=!%2!
    SET option_value=!%3!

    @REM ::option format
    IF "%option_type%"=="long" (
        SET option_delimiter==
        SET option_prefix=--
    ) ELSE IF "%option_type%"=="short" (
        SET option_delimiter==
        SET option_prefix=-
    ) ELSE (
        SET option_delimiter=:
        SET option_prefix=%option_type%
    )

    @REM ::check value is empty
    IF "!option_value!"=="" SET empty_value=true
    IF "!option_value!"==" " SET empty_value=true
    IF "!option_value!"=="-" SET empty_value=true
    IF "!option_value!"==":" SET empty_value=true

    @REM ::append value if not empty
    IF "%empty_value%"=="true" (
        SET option_parameter=%option_prefix%%option_name%
    ) ELSE (
        SET option_parameter=%option_prefix%%option_name%%option_delimiter%%option_value%
    )

    @REM ::add quotation marks if spaces or '=' in param
    IF NOT "%option_parameter: =%"=="%option_parameter%" (
        SET option_parameter="%option_parameter%"
    ) ELSE (
        @REM ::https://stackoverflow.com/questions/3777110/remove-an-equals-symbol-from-text-string
        FOR /F "usebackq delims== tokens=1-2" %%A IN (`ECHO !option_parameter!`) DO (
            IF NOT "%%B"=="" SET option_parameter="%option_parameter%"
        )
    )

    ENDLOCAL & (
        SET %4=%option_parameter%
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
IF "!KPT_CALLER_SCRIPT_PATH!"=="" SET KPT_CALLER_SCRIPT_PATH=%~0
IF EXIST "%current_script_dir%KPT_EXPORT_ENVIRONMENT.bat" (
    CALL %current_script_dir%KPT_EXPORT_ENVIRONMENT.bat
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
    IF NOT EXIST "%_engine_dir%!_command_name!.bat" (
        WHERE /Q !_command_name!
        IF !ERRORLEVEL! EQU 0 (
            SET _engine_dir=
        ) ELSE (
            SET /P _engine_dir=%tip_set_engine_dir%
            FOR %%F IN (!_engine_dir!.) DO SET _engine_dir=%%~dpnF\
            GOTO:loop_check_variable
        )
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
    SET _env_name=%%A
    SET _env_value=!%%A!
    SET _option_type=
    SET _option_name=
    SET _option_value=
    SET _option_param=
    CALL :function_env_parse_option _command_name _env_name _env_value _option_type _option_name _option_value
    CALL :function_option_parameter_generation _option_type _option_name _option_value _option_param
    IF NOT DEFINED _command_opt (
        SET _command_opt=!_option_param!
    ) ELSE (
        SET _command_opt=!_command_opt! !_option_param!
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
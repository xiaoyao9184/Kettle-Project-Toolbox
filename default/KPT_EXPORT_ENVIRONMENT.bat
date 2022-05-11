@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-21
::FILE KPT_EXPORT_ENVIRONMENT


GOTO:init_variable


:function_looking
    SETLOCAL EnableDelayedExpansion
    SET _looking_dir=!%1!
    SET _looking_file_name=!%2!
    SET _looking_file_ext=!%3!

    IF EXIST "%_looking_dir%%_looking_file_name%.%_looking_file_ext%" (
        ENDLOCAL & SET %4=true
    ) ELSE (
        ENDLOCAL & SET %4=false
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

::default param
SET caller_script_path=%KPT_CALLER_SCRIPT_PATH%
SET in_kpt_project=false


:check_variable

::caller_script_name
IF "!caller_script_path!"=="" (
    SET caller_script_dir=%~dp0
) ELSE (
    FOR %%F IN (!caller_script_path!) DO (
        SET caller_script_dir=%%~dpF
        SET caller_script_name=%%~nF
    )
)

::parent_folder_dir
::parent_folder_name
FOR %%F IN (%caller_script_dir%.) DO SET parent_folder_dir=%%~dpF
FOR %%F IN (%caller_script_dir%.) DO SET parent_folder_name=%%~nxF

::looking_file_name
::looking_file_ext
IF "%caller_script_name%"=="" GOTO:looking_done

:looking_start

::looking kjb in caller_script_dir
SET looking_file_name=%caller_script_name%
SET looking_file_ext=kjb
CALL :function_looking caller_script_dir looking_file_name looking_file_ext _exist
IF "%_exist%"=="true" GOTO:looking_done

::looking ktr in caller_script_dir
SET looking_file_name=%caller_script_name%
SET looking_file_ext=ktr
CALL :function_looking caller_script_dir looking_file_name looking_file_ext _exist
IF "%_exist%"=="true" GOTO:looking_done

::looking kjb in path from caller_script_name
SET looking_file_name=%caller_script_name:.=\%
SET looking_file_ext=kjb
CALL :function_looking caller_script_dir looking_file_name looking_file_ext _exist
IF "%_exist%"=="true" GOTO:looking_done

::looking ktr in path from caller_script_name
SET looking_file_name=%caller_script_name:.=\%
SET looking_file_ext=ktr
CALL :function_looking caller_script_dir looking_file_name looking_file_ext _exist
IF "%_exist%"=="true" GOTO:looking_done

::looking not exist
SET looking_file_name=
SET looking_file_ext=

:looking_done

::in_kpt_project
IF EXIST %caller_script_dir%repository.log (
    SET in_kpt_project=true
)
IF EXIST %caller_script_dir%.meta (
    SET in_kpt_project=true
)
IF EXIST %caller_script_dir%.profile (
    SET in_kpt_project=true
)
IF EXIST %caller_script_dir%*.kdb (
    SET in_kpt_project=true
)
IF EXIST %caller_script_dir%config.xml (
    SET in_kpt_project=true
)


:begin

ECHO ==========%~n0==========

::KPT_COMMAND
IF "%KPT_COMMAND%"=="" (
    IF "%looking_file_ext%"=="kjb" (
        SET KPT_COMMAND=kitchen
    ) ELSE IF "%looking_file_ext%"=="ktr" (
        SET KPT_COMMAND=pan
    )
    ECHO set 'KPT_COMMAND' to: %KPT_COMMAND%
)

::KPT_LOG_PATH
IF %interactive% EQU 1 IF "!KPT_LOG_PATH!"=="" (
    SET _date=%date:~0,10%
    SET _date=!_date:/=_!
    SET _time=%time:~0,8%
    SET _time=!_time::=_!
    set _time=!_time: =0!
    SET _datetime=!_date!-!_time!
    IF EXIST %caller_script_dir%log (
        SET _log_path=%caller_script_dir%log
    ) ELSE (
        SET _log_path=%USERPROFILE%\.kettle\log
    )
    IF NOT EXIST "!_log_path!" MKDIR "!_log_path!"
    SET KPT_LOG_PATH=!_log_path!\%caller_script_name%.!_datetime!.log
    ECHO set 'KPT_LOG_PATH' to: !KPT_LOG_PATH!
)

IF "%in_kpt_project%"=="true" (
    @REM ::KPT_ENGINE_PATH
    IF "!KPT_ENGINE_PATH!"=="" (
        FOR %%F IN (%caller_script_dir%.) DO SET parent_folder_dir=%%~dpF
        SET KPT_ENGINE_PATH=!parent_folder_dir!data-integration
        ECHO set 'KPT_ENGINE_PATH' to: !KPT_ENGINE_PATH!
    )
    @REM ::KPT_KETTLE_JOB
    IF "!KPT_KETTLE_JOB!"=="" IF NOT "%looking_file_name%"=="" IF "%KPT_COMMAND%"=="kitchen" (
        SET "KPT_KETTLE_JOB=%looking_file_name:\=/%"
        ECHO set 'KPT_KETTLE_JOB' to: !KPT_KETTLE_JOB!
    )
    @REM ::KPT_KETTLE_TRANS
    IF "!KPT_KETTLE_TRANS!"=="" IF NOT "%looking_file_name%"=="" IF "%KPT_COMMAND%"=="pan" (
        SET "KPT_KETTLE_TRANS=%looking_file_name:\=/%"
        ECHO set 'KPT_KETTLE_TRANS' to: %KPT_KETTLE_TRANS%
    )
    @REM ::KPT_PROJECT_PATH
    IF "!KPT_PROJECT_PATH!"=="" (
        SET KPT_PROJECT_PATH=%parent_folder_dir%%parent_folder_name%
        ECHO set 'KPT_PROJECT_PATH' to: !KPT_PROJECT_PATH!
    )
    @REM ::KETTLE_REPOSITORY
    IF "%KETTLE_REPOSITORY%"=="" (
        SET KETTLE_REPOSITORY=%parent_folder_name%
        ECHO set 'KETTLE_REPOSITORY' to: !KETTLE_REPOSITORY!
    )
) ELSE IF NOT "%looking_file_name%"=="" (
    @REM ::KPT_KETTLE_FILE
    IF "!KPT_KETTLE_FILE!"=="" (
        SET KPT_KETTLE_FILE=%caller_script_dir%%looking_file_name%.%looking_file_ext%
        ECHO set 'KPT_KETTLE_FILE' to: !KPT_KETTLE_FILE!
    )
)

::KETTLE_HOME
IF "!KETTLE_HOME!"=="" IF EXIST %caller_script_dir%.kettle (
    SET KETTLE_HOME=%caller_script_dir:\=/%
    ECHO set 'KETTLE_HOME' to: !KETTLE_HOME!
)

ECHO ##########%~n0##########


:end

::upgrade/export local env to global
ENDLOCAL & (
    SET KPT_COMMAND=%KPT_COMMAND%
    SET KPT_LOG_PATH=%KPT_LOG_PATH%
    SET KPT_ENGINE_PATH=%KPT_ENGINE_PATH%
    SET KPT_PROJECT_PATH=%KPT_PROJECT_PATH%
    SET KPT_KETTLE_JOB=%KPT_KETTLE_JOB%
    SET KPT_KETTLE_TRANS=%KPT_KETTLE_TRANS%
    SET KPT_KETTLE_FILE=%KPT_KETTLE_FILE%
    SET KETTLE_HOME=%KETTLE_HOME%
    SET KETTLE_REPOSITORY=%KETTLE_REPOSITORY%
)
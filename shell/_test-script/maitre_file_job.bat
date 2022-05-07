@ECHO OFF
SETLOCAL EnableDelayedExpansion


GOTO:skip_function

@REM ::
:function_readlink
    SETLOCAL EnableDelayedExpansion
    SET read_path=!%1!
    SET real_path=

    FOR %%F IN (%read_path%.) DO SET find_dir=%%~dpF
    FOR %%F IN (%read_path%.) DO SET find_name=%%~nF

    @REM :: echo not exist if no link in find_dir
    FOR /F "usebackq tokens=2 delims=[]" %%H IN (`DIR /A:L "%find_dir%" ^| FINDSTR /C:"%find_name% "`) DO (
        SET real_path=%%H
    )
    
    ENDLOCAL & (
        IF NOT "%real_path%"=="" (
            IF "%2"=="" (SET %1=%real_path%) ELSE (SET %2=%real_path%)
        )
    )
GOTO:EOF

:skip_function


@REM like this
@REM maitre -f= -j=true

SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

SET kpt_workspace_shell_path=%parent_folder_dir%
CALL :function_readlink kpt_workspace_shell_path kpt_repository_shell_path
IF NOT "%kpt_repository_shell_path%"=="" (
    FOR %%F IN (%kpt_repository_shell_path%\..) DO SET kpt_repository_path=%%~dpF
) ELSE IF EXIST "%kpt_workspace_shell_path%..\samples" (
    FOR %%F IN (%kpt_workspace_shell_path%..) DO SET kpt_repository_path=%%~dpnxF
)

SET KPT_COMMAND=maitre
SET KPT_KETTLE_FILE=%kpt_repository_path%\samples\dont_use_Set files in result\EACH_KTR_FILE_PRINT.kjb
SET KPT_KETTLE__j=true
SET KPT_KETTLE_JOB=

CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
ECHO exit code will be 0

SET KPT_COMMAND=maitre
SET KPT_KETTLE_FILE=%kpt_repository_path%\samples\dont_use_Set files in result\EACH_KTR_FILE_PRINT.kjb
SET KPT_KETTLE_JOB=true
SET KPT_KETTLE__j=

CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
ECHO exit code will be 0


ECHO:
ECHO pause by %~nx0
PAUSE

@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/default/
@REM SET KETTLE_REPOSITORY=default
@REM kitchen /job:kpt/patch/PatchPDI /export


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

ENDLOCAL & (
    SET KPT_COMMAND=kitchen
    SET KPT_KETTLE_EXPORT=" "
    SET KPT_KETTLE_JOB=kpt/patch/PatchPDI

    @REM ::always error no matter set these variables
    @REM CD %parent_folder_dir%
    @REM SET KPT_KETTLE_DIR=%parent_folder_dir%
    @REM SET KPT_KETTLE_REP=default

    CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
    ECHO exit code will be 2
)


ECHO:
ECHO pause by %~nx0
PAUSE

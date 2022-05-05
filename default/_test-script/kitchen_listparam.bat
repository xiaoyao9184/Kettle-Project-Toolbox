@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/default/
@REM SET KETTLE_REPOSITORY=default
@REM kitchen /trans:kpt/patch/PatchPDI /listparam


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

ENDLOCAL & (
    SET KPT_COMMAND=kitchen
    SET KPT_KETTLE_LISTPARAM=" "
    SET KPT_KETTLE_JOB=kpt/patch/PatchPDI

    CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
    ECHO exit code will be 7 but result correct
)


ECHO:
ECHO pause by %~nx0
PAUSE

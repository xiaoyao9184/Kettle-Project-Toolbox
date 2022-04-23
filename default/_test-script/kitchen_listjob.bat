@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/default/
@REM SET KETTLE_REPOSITORY=default
@REM kitchen /listjob


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

ENDLOCAL & (
    SET KPT_COMMAND=kitchen
    SET KPT_KETTLE_LISTJOB=" "

    CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
    ECHO exit code will be 7
)


ECHO:
ECHO pause by %~nx0
PAUSE

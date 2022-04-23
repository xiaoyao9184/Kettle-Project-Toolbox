@ECHO OFF
SETLOCAL EnableDelayedExpansion


SET current_script_dir=%~dp0

ENDLOCAL & (
    SET KPT_COMMAND=spoon

    CALL %current_script_dir%KPT_RUN_COMMAND.bat
)


ECHO:
ECHO pause by %~nx0
PAUSE
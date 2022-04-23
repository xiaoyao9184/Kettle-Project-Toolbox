@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM pan /listrep


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

ENDLOCAL & (
    SET KPT_COMMAND=pan
    SET KPT_KETTLE_LISTREP=" "

    CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
)


ECHO:
ECHO pause by %~nx0
PAUSE
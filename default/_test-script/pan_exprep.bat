@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/default/
@REM SET KETTLE_REPOSITORY=default
@REM pan /exprep:E:\Kettle\workspace9.1\default\_test-script\exprep.xml


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

ENDLOCAL & (
    SET KPT_COMMAND=pan
    SET KPT_KETTLE_EXPREP=%current_script_dir%exprep.xml

    CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
)


ECHO:
ECHO pause by %~nx0
PAUSE

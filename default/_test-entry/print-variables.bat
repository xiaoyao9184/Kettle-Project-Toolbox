@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace7.1/default/
@REM SET KETTLE_REPOSITORY=default
@REM pan /trans:_test-entry/print-variables


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF


SET KPT_COMMAND=pan
SET KPT_KETTLE_TRANS=_test-entry/print-variables

CALL %parent_folder_dir%KPT_RUN_COMMAND.bat



ECHO:
ECHO pause by %~nx0
PAUSE

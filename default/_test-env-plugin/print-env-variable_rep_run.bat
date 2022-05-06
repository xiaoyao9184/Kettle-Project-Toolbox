@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/default/
@REM SET KETTLE_REPOSITORY=default
@REM pan /trans:_test-env-plugin/print-env-variable


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF


@REM SET KPT_MODE=rep
@REM SET KPT_CALLER_SCRIPT_PATH=%parent_folder_dir%_test-env-plugin.print-env-variable.bat
SET KPT_COMMAND=pan
SET KPT_KETTLE_TRANS=_test-env-plugin/print-env-variable

CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
ECHO exit code will be 0


ECHO:
ECHO pause by %~nx0
PAUSE

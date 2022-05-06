@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace8.2remix/default/
@REM maitre -e dev -f _test-env-plugin/print-env-variable.ktr


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

@REM SET KPT_MODE=env
@REM SET KPT_CALLER_SCRIPT_PATH=%parent_folder_dir%_test-env-plugin.print-env-variable.bat
SET KPT_COMMAND=maitre
SET KPT_KETTLE_ENVIRONMENT=dev
SET KPT_KETTLE_FILE=_test-env-plugin/print-env-variable.ktr
SET KPT_KETTLE_LEVEL=Detailed
SET KPT_KETTLE_PARAMETERS=Config.Main.Job.Path=/_test-env-plugin,Config.Main.Job.Name=print-env-variable

CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
ECHO exit code will be 0


ECHO:
ECHO pause by %~nx0
PAUSE

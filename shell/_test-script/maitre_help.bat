@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM maitre -help


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

SET KPT_COMMAND=maitre
SET KPT_KETTLE_HELP=" "

CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
ECHO exit code will be 1


SET KPT_KETTLE_HELP=
SET KPT_COMMAND=maitre
SET KPT_KETTLE__h=" "

CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
ECHO exit code will be 1


ECHO:
ECHO pause by %~nx0
PAUSE

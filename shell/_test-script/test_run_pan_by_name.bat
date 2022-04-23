@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM default_boolean_param-test.bat
@REM pan /file:..\..\samples\default_boolean_param\default_boolean_param-test.ktr


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF
FOR %%F IN (%parent_folder_dir%.) DO SET kpt_folder_dir=%%~dpF

COPY %parent_folder_dir%KPT_EXPORT_ENVIRONMENT.bat %kpt_folder_dir%samples\default_boolean_param\KPT_EXPORT_ENVIRONMENT.bat
COPY %parent_folder_dir%KPT_RUN_COMMAND.bat %kpt_folder_dir%samples\default_boolean_param\default_boolean_param-test.bat

CALL %kpt_folder_dir%samples\default_boolean_param\default_boolean_param-test.bat

DEL %kpt_folder_dir%samples\default_boolean_param\KPT_EXPORT_ENVIRONMENT.bat
DEL %kpt_folder_dir%samples\default_boolean_param\default_boolean_param-test.bat


ECHO:
ECHO pause by %~nx0
PAUSE
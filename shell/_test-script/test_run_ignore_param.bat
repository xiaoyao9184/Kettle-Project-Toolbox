@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM KPT_KETTLE_ignore_param ignore
@REM pan /file:E:\Kettle\Kettle-Project-Toolbox\samples\default_boolean_param\default_boolean_param-test.ktr


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

ENDLOCAL & (
    SET KPT_COMMAND=pan
    SET KPT_KETTLE_FILE=%kpt_folder_dir%samples\default_boolean_param\default_boolean_param-test.ktr
    SET KPT_KETTLE_ignore_param=false

    CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
)


ECHO:
ECHO pause by %~nx0
PAUSE
@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM pan /param:parameter.exist.boolean=false /param:parameter.exist.string=string1 /file:E:\Kettle\Kettle-Project-Toolbox\samples\default_boolean_param\default_boolean_param-test.ktr


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

ENDLOCAL & (
    SET KPT_COMMAND=pan
    SET KPT_KETTLE_FILE=%kpt_folder_dir%samples\default_boolean_param\default_boolean_param-test.ktr
    SET KPT_KETTLE_PARAM_parameter_exist_boolean=false
    SET KPT_KETTLE_PARAM_parameter_exist_string=string1
    SET KPT_PARAM_AS_ENV=true

    CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
)


ECHO:
ECHO pause by %~nx0
PAUSE
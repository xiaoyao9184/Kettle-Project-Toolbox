@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/default/
@REM SET KETTLE_REPOSITORY=default
@REM kitchen /norep /file:E:\Kettle\Kettle-Project-Toolbox\samples\dont_use_Set files in result\EACH_KTR_FILE_PRINT.kjb


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF
FOR %%F IN (%parent_folder_dir%.) DO SET kpt_folder_dir=%%~dpF

ENDLOCAL & (
    SET KPT_COMMAND=kitchen
    SET KETTLE_HOME=E:/Kettle/workspace9.1/default/
    SET KETTLE_REPOSITORY=default
    SET KPT_KETTLE_NOREP=" "
    SET KPT_KETTLE_FILE="%kpt_folder_dir%samples\dont_use_Set files in result\EACH_KTR_FILE_PRINT.kjb"

    CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
)


ECHO:
ECHO pause by %~nx0
PAUSE
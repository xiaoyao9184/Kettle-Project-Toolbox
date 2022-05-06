@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace8.2remix/default/
@REM maitre "-C=test_create=e:\Kettle\workspace8.2remix\default" "-V=var1=1" "-V=var2=2"


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF

SET KPT_KETTLE__C=
SET KPT_KETTLE__V=
SET KPT_KETTLE__V_var2=
SET KPT_COMMAND=maitre
SET KPT_KETTLE_CREATE__ENVIRONMENT="test_create=%parent_folder_dir%"
SET KPT_KETTLE_ADD__VARIABLE__TO__ENVIRONMENT="var1=1:description"
SET KPT_KETTLE_ADD__VARIABLE__TO__ENVIRONMENT_var2="2"

CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
ECHO exit code will be 0


SET KPT_KETTLE_CREATE__ENVIRONMENT=
SET KPT_KETTLE_ADD__VARIABLE__TO__ENVIRONMENT=
SET KPT_KETTLE_ADD__VARIABLE__TO__ENVIRONMENT_var2=
SET KPT_COMMAND=maitre
SET KPT_KETTLE__C="test_create=%parent_folder_dir%"
SET KPT_KETTLE__V="var1=1"
SET KPT_KETTLE__V_var2="2"

CALL %parent_folder_dir%KPT_RUN_COMMAND.bat
ECHO exit code will be 0


ECHO:
ECHO pause by %~nx0
PAUSE

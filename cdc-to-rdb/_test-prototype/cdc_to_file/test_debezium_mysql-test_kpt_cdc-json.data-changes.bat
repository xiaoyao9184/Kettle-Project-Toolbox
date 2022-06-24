@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/cdc-to-rdb/
@REM SET KETTLE_REPOSITORY=cdc-to-rdb
@REM pan /trans:_test-prototype/cdc_to_file


SET current_script_dir=%~dp0

FOR %%F IN (%current_script_dir%.) DO SET project_folder_path=%%~dpF%%~nF
:find_project_path_loop
IF NOT EXIST "%project_folder_path%\db_kpt_cdc_rdb_writer.kdb" (
    FOR %%F IN (%project_folder_path%.) DO SET project_folder_path=%%~dpF%
    ECHO go up !project_folder_path!
    GOTO:find_project_path_loop
)


SET _date=%date:~0,10%
SET _date=!_date:/=_!
SET _time=%time:~0,8%
SET _time=!_time::=_!
set _time=!_time: =0!
SET _datetime=!_date!-!_time!


SET KPT_COMMAND=pan
SET KPT_PARAM_AS_ENV=true
SET KPT_KETTLE_TRANS=_test-prototype/cdc_to_file

SET KPT_KETTLE_PARAM_Config_CDC_Kafka_Consumer_Group=cdc_to_file-%_datetime%
SET KPT_KETTLE_PARAM_Config_CDC_Kafka_Data_Topic=test_debezium_mysql-test_kpt_cdc-json.data-changes

SET KPT_CALLER_SCRIPT_PATH=%project_folder_path%test.cdc_to_file.%KPT_KETTLE_PARAM_Config_CDC_Kafka_Data_Topic%.bat
CALL %project_folder_path%KPT_RUN_COMMAND.bat
ECHO exit code will be 0



ECHO:
ECHO pause by %~nx0
PAUSE

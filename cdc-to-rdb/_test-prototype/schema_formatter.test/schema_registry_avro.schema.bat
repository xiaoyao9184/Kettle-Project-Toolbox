@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/cdc-to-rdb/
@REM SET KETTLE_REPOSITORY=cdc-to-rdb
@REM pan /trans:_test-prototype/schema_formatter.test


SET current_script_dir=%~dp0

FOR %%F IN (%current_script_dir%.) DO SET project_folder_path=%%~dpF%%~nF
:find_project_path_loop
IF NOT EXIST "%project_folder_path%\db_kpt_cdc_rdb_writer.kdb" (
    FOR %%F IN (%project_folder_path%.) DO SET project_folder_path=%%~dpF%
    ECHO go up !project_folder_path!
    GOTO:find_project_path_loop
)


SET KPT_COMMAND=pan
SET KPT_PARAM_AS_ENV=true
SET KPT_KETTLE_TRANS=_test-prototype/schema_formatter.test
@REM schema_formatter.test param
SET KPT_KETTLE_PARAM_Param_Input_Csv_Path=_test-prototype/cdc_to_batch.test
SET KPT_KETTLE_PARAM_Config_CDC_Kafka_Data_Topic=test_debezium_mysql-test_kpt_cdc-avro.data-changes
SET KPT_KETTLE_PARAM_Config_CDC_Batch_Schema_Format_Mapping=schema_registry_avro
@REM schema_registry_avro param
SET KPT_KETTLE_PARAM_Config_CDC_Batch_Schema_Registry_Url=http://me:58081


SET KPT_CALLER_SCRIPT_PATH=%project_folder_path%test.schema_formatter.%KPT_KETTLE_PARAM_Config_CDC_Batch_Schema_Format_Mapping%.bat
CALL %project_folder_path%KPT_RUN_COMMAND.bat
ECHO exit code will be 0


ECHO:
ECHO pause by %~nx0
PAUSE

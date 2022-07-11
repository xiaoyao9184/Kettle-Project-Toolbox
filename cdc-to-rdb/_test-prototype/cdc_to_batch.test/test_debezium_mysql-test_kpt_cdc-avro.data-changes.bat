@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/cdc-to-rdb/
@REM SET KETTLE_REPOSITORY=cdc-to-rdb
@REM pan /trans:_test-prototype/cdc_to_batch.prototype


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
SET KPT_KETTLE_TRANS=_test-prototype/cdc_to_batch.prototype
@REM cdc_to_batch.prototype param
SET KPT_KETTLE_PARAM_Config_CDC_Kafka_Batch_Duration=10000
SET KPT_KETTLE_PARAM_Config_CDC_Kafka_Batch_Max=100
SET KPT_KETTLE_PARAM_Config_CDC_Kafka_Batch_Size=100
SET KPT_KETTLE_PARAM_Config_CDC_Kafka_Server_Bootstrap=kafka:59094
SET KPT_KETTLE_PARAM_Config_CDC_Kafka_Consumer_Group=cdc_to_batch.test-%_datetime%
SET KPT_KETTLE_PARAM_Config_CDC_Kafka_Data_Topic=test_debezium_mysql-test_kpt_cdc-avro.data-changes
SET KPT_KETTLE_PARAM_ParamBatchPath=/_test-prototype
SET KPT_KETTLE_PARAM_ParamBatchTransformation=batch_to_file.stream
@REM batch_to_file.stream param
SET KPT_KETTLE_PARAM_ParamCsvPath=_test-prototype/cdc_to_batch.test
SET KPT_KETTLE_PARAM_ParamMarkPath=_test-prototype
SET KPT_KETTLE_PARAM_ParamMarkTransformation=debug_vars_marker.result
@REM debug_vars_marker.result param
SET KPT_KETTLE_PARAM_ParamDebug=true


SET KPT_CALLER_SCRIPT_PATH=%project_folder_path%test.cdc_to_batch.%KPT_KETTLE_PARAM_Config_CDC_Kafka_Data_Topic%.bat
CALL %project_folder_path%KPT_RUN_COMMAND.bat
ECHO exit code will be 1


ECHO:
ECHO pause by %~nx0
PAUSE

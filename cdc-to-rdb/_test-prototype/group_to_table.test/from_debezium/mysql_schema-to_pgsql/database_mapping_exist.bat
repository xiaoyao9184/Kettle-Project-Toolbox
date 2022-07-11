@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/cdc-to-rdb/
@REM SET KETTLE_REPOSITORY=cdc-to-rdb
@REM pan /job:_test-prototype/group_to_table.test


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
SET KPT_KETTLE_TRANS=_test-prototype/group_to_table.test
@REM SET KPT_KETTLE_LEVEL=Rowlevel
@REM group_to_table.test param
SET KPT_KETTLE_PARAM_ParamJsonFile=from_debezium/mysql_schema.json
@REM group_to_table.prototype param
SET KPT_KETTLE_PARAM_Config_CDC_Log_Batch_Group_Mapping=log_json_to_kettle
SET KPT_KETTLE_PARAM_Config_CDC_Debug_Delay_Injection_Crud_Time=0
SET KPT_KETTLE_PARAM_Config_CDC_Debug_Delay_Injection_Field_Time=0
SET KPT_KETTLE_PARAM_Config_CDC_Source_Column_Mapping=mysql_schema
SET KPT_KETTLE_PARAM_Config_CDC_Source_Key_Mapping=key_schema
SET KPT_KETTLE_PARAM_Config_CDC_Source_Transformation_Path=from_debezium
SET KPT_KETTLE_PARAM_Config_CDC_Target_Column_Mapping=same_source
SET KPT_KETTLE_PARAM_Config_CDC_Target_Key_Mapping=same_source
SET KPT_KETTLE_PARAM_Config_CDC_Target_Operate_Mapping=same_source
SET KPT_KETTLE_PARAM_Config_CDC_Target_Table_Mapping=database_mapping_exist
SET KPT_KETTLE_PARAM_Config_CDC_Target_Transformation_Path=to_pgsql
SET KPT_KETTLE_PARAM_Param_Batch_ID=test
SET KPT_KETTLE_PARAM_Param_Group_ID=injection
SET KPT_KETTLE_PARAM_Param_Group_Name=from_debezium.mysql_schema.to_pgsql.database_mapping_exist
SET KPT_KETTLE_PARAM_ParamInjectionPath=_test-prototype/group_to_table.injection
SET KPT_KETTLE_PARAM_ParamMarkPath=from_kafka/batch_group_marker.result
SET KPT_KETTLE_PARAM_ParamMarkTransformation=no_marker
SET KPT_KETTLE_PARAM_ParamTemplatePath=to_rdb
SET KPT_KETTLE_PARAM_ParamTemplateTransformation=group_to_table.template
@REM database_mapping_exist param
SET KPT_KETTLE_PARAM_Config_CDC_RDB_Writer_Database=test_kpt
SET KPT_KETTLE_PARAM_Config_CDC_RDB_Writer_Password=kpt.123
SET KPT_KETTLE_PARAM_Config_CDC_RDB_Writer_Port=55432
SET KPT_KETTLE_PARAM_Config_CDC_RDB_Writer_Server=pgsql
SET KPT_KETTLE_PARAM_Config_CDC_RDB_Writer_Username=kpt
SET KPT_KETTLE_PARAM_Config_CDC_Target_Table_Mapping_SourceName=default
SET KPT_KETTLE_PARAM_Config_CDC_Target_PgSql_Case_Sensitive=true


SET KPT_CALLER_SCRIPT_PATH=%project_folder_path%test.group_to_table.from_debezium.mysql_schema-to_pgsql.database_mapping_exist.bat
CALL %project_folder_path%KPT_RUN_COMMAND.bat
ECHO exit code will be 0


ECHO:
ECHO pause by %~nx0
PAUSE

@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/cdc-to-rdb/
@REM SET KETTLE_REPOSITORY=cdc-to-rdb
@REM pan /job:_test-prototype/group_to_table.test


SET current_script_dir=%~dp0

FOR %%F IN (%current_script_dir%.) DO SET project_folder_path=%%~dpF%%~nF
:find_project_path_loop
IF NOT EXIST "%project_folder_path%\db_kpt_cdc_event_pgsql_writer.kdb" (
    FOR %%F IN (%project_folder_path%.) DO SET project_folder_path=%%~dpF%
    ECHO go up !project_folder_path!
    GOTO:find_project_path_loop
)


SET KPT_COMMAND=pan
SET KPT_PARAM_AS_ENV=true
SET KPT_KETTLE_TRANS=_test-prototype/group_to_table.test
@REM SET KPT_KETTLE_LEVEL=Rowlevel


SET KPT_KETTLE_PARAM_Config_Batch_Group_Logger_Mapping=log_json_to_kettle
SET KPT_KETTLE_PARAM_Config_Delay_Injection_Crud_Time=0
SET KPT_KETTLE_PARAM_Config_Delay_Injection_Field_Time=0
SET KPT_KETTLE_PARAM_Config_CDC_Source_Column_Mapping=mssql_schema
SET KPT_KETTLE_PARAM_Config_CDC_Source_Key_Mapping=debezium_key_to_key_meta
SET KPT_KETTLE_PARAM_Config_CDC_Source_Transformation_Path=from-debezium
SET KPT_KETTLE_PARAM_Config_CDC_Target_Column_Mapping=same_source
SET KPT_KETTLE_PARAM_Config_CDC_Target_Key_Mapping=same_source
SET KPT_KETTLE_PARAM_Config_CDC_Target_Operate_Mapping=same_source
SET KPT_KETTLE_PARAM_Config_CDC_Target_Table_Mapping=same_source_lookup
SET KPT_KETTLE_PARAM_Config_CDC_Target_Transformation_Path=to_none
SET KPT_KETTLE_PARAM_Param_Group_ID=test
SET KPT_KETTLE_PARAM_Param_Group_Name=from_debezium.mssql_schema.to_none
SET KPT_KETTLE_PARAM_ParamInjectionPath=_test-prototype/group_to_table.injection
SET KPT_KETTLE_PARAM_ParamMarkTransformation=no_marker
SET KPT_KETTLE_PARAM_ParamTemplatePath=to_rdb
SET KPT_KETTLE_PARAM_ParamTemplateTransformation=group_to_table.template


SET KPT_CALLER_SCRIPT_PATH=%project_folder_path%%KPT_KETTLE_PARAM_Param_Group_ID%.%KPT_KETTLE_PARAM_Param_Group_Name%.bat
CALL %project_folder_path%KPT_RUN_COMMAND.bat

ECHO exit code will be 0


ECHO:
ECHO pause by %~nx0
PAUSE

@ECHO OFF
SETLOCAL EnableDelayedExpansion

@REM like this
@REM SET KETTLE_HOME=E:/Kettle/workspace9.1/cdc-to-rdb/
@REM SET KETTLE_REPOSITORY=cdc-to-rdb
@REM pan /job:_test-prototype/batch_to_group.test


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
SET KPT_KETTLE_TRANS=_test-prototype/batch_to_group.test
@REM SET KPT_KETTLE_LEVEL=Rowlevel
@REM batch_to_group.test param
SET KPT_KETTLE_PARAM_Param_Input_Json_File=from_debezium/mysql_playload.json
SET KPT_KETTLE_PARAM_Config_CDC_Source_Transformation_Path=from_debezium
SET KPT_KETTLE_PARAM_Config_CDC_Source_Row_Mapping=mysql_playload
@REM batch_to_group.prototype param
SET KPT_KETTLE_PARAM_Config_CDC_Log_Batch_Group_Mapping=log_json_to_kettle
SET KPT_KETTLE_PARAM_Config_CDC_Batch_Redirect_Row_Mapping=group_by_row_last
SET KPT_KETTLE_PARAM_Config_CDC_Batch_Group_Table_Mapping=sort_by_table_operate
SET KPT_KETTLE_PARAM_Param_Mark_Path=_test-prototype
SET KPT_KETTLE_PARAM_Param_Mark_Transformation=debug_vars_marker.result
SET KPT_KETTLE_PARAM_Param_Group_Path=_test-prototype
SET KPT_KETTLE_PARAM_Param_Group_Transformation=group_to_none.result


SET KPT_CALLER_SCRIPT_PATH=%project_folder_path%test.batch_to_group.mysql_playload.redirect_groupby_last_group_operate.bat
CALL %project_folder_path%KPT_RUN_COMMAND.bat
ECHO exit code will be 0


ECHO:
ECHO pause by %~nx0
PAUSE

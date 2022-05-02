@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0
::TIME 2022-04-29


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_name=%%~nxF

ENDLOCAL & (
    SET kpt_project_name=%parent_folder_name%
    SET target_project_path=%current_script_dir%
    SET copy_item_name_list=config.xml;db_kpt_cdc_event_pgsql_writer.kdb;.kettle\kettle.properties
    SET link_item_name_list=from-canal;from-debezium;from-kafka;to_pgsql;to_rdb;_test-config;_test-container;_test-prototype

    CALL %parent_folder_dir%tool\link_project.bat
)

SET kpt_project_name=
SET target_project_path=
SET copy_item_name_list=
SET link_item_name_list=


ECHO:
ECHO pause by %~nx0
PAUSE
@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0 beta
::TIME 2022-04-25


SET current_script_dir=%~dp0
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_dir=%%~dpF
FOR %%F IN (%current_script_dir%.) DO SET parent_folder_name=%%~nF

ENDLOCAL & (
    SET kpt_project_name=%parent_folder_name%
    SET kpt_folder_name=%parent_folder_name%
    SET copy_item_name_list=config.xml;db_kpt_bin_log_pgsql_writer.kdb
    SET link_item_name_list=from-canal;from-debezium;from-kafka;mysql-log;to_pgsql;to_rdb

    CALL %parent_folder_dir%tool\LINK_PROJECT.bat
)

SET kpt_project_name=
SET kpt_folder_name=
SET copy_item_name_list=
SET link_item_name_list=


ECHO:
ECHO pause by %~nx0
PAUSE
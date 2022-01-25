@echo off
Setlocal enabledelayedexpansion

set current_path=%~dp0
set connect_config=%1
@REM set name_prefix=test-kpt_debezium_connector_
@REM set connect_network=host
@REM set connect_host=connect

if not exist "%connect_config%" (
    echo "Run all"
    for %%f in (%current_path%\config_of_connector\*.json) do (
        set name=%%~nf
        @REM n="${name//\./_}" 
        echo "Run of !name!"

        curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" -d @config_of_connector/!name!.json localhost:58083/connectors/ 
    )
) else (
    for %%F in ("!connect_config!") do set name=%%~nF
    echo "Run of !name! at %connect_config%"

    curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" -d @config_of_connector/!name!.json http://localhost:58083/connectors/
            
)

cd %current_path%

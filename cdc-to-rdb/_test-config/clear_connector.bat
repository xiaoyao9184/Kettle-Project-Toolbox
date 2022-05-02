@echo off
Setlocal enabledelayedexpansion

set current_path=%~dp0
set connector_config=%1

if not exist "%connector_config%" set connector_config=%current_path%config_of_connector

if exist %connector_config%\NUL (
    cd !connector_config!
    echo "Run all in !connector_config!"
    for %%f in (!connector_config!\*.json) do (
        set connector_file=%%~nxf
        echo "Run of !connector_file!"

        for /f "delims=" %%l in ('jq -r .name ^< !connector_file!') do set name=%%l
        
        curl -i -X DELETE -H "Accept:application/json" localhost:58083/connectors/!name!
    )
) else (
    for %%F in ("!connector_config!") do set connector_path=%%~dpF
    for %%F in ("!connector_config!") do set connector_file=%%~nxF
    cd !connector_path!
    echo "Run of !connector_file! at %connector_path%"

    for /f "delims=" %%l in ('jq -r .name ^< !connector_file!') do set name=%%l

    curl -i -X DELETE -H "Accept:application/json" localhost:58083/connectors/!name!
)

cd %current_path%

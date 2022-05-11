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

        curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" -d @!connector_file! localhost:58083/connectors/
    )
) else (
    for %%F in ("!connector_config!") do set connector_path=%%~dpF
    for %%F in ("!connector_config!") do set connector_file=%%~nxF
    cd !connector_path!
    echo "Run of !connector_file! at %connector_path%"

    curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" -d @!connector_file! localhost:58083/connectors/
)

cd %current_path%

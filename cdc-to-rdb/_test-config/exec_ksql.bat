@echo off
Setlocal enabledelayedexpansion

set current_path=%~dp0
set exe_ksql=%1
set name_prefix=test-kpt_ksql_cli_
set connect_network=test-kpt
set connect_host=connect

if not exist "%exe_ksql%" set exe_ksql=%current_path%ksql

if exist %exe_ksql%\NUL (
    set ksql_path=%exe_ksql%
    echo "Run all in !ksql_path!"
    for %%f in (!ksql_path!\*.ksql) do (
        set ksql_file=%%~nxF
        set ksql_name=%%~nf
        echo "Run of !ksql_name!"

        docker run -it --rm --name %name_prefix%!ksql_name! ^
            --network=!connect_network! ^
            --mount "type=bind,source=!ksql_path!/!ksql_file!,destination=/init.ksql" ^
            confluentinc/cp-ksqldb-cli:7.0.0 --file /init.ksql ^
		 	    http://ksqldb-server:8088
    )
) else (
    for %%F in ("!exe_ksql!") do set ksql_path=%%~dpF
    for %%F in ("!exe_ksql!") do set ksql_file=%%~nxF
    for %%F in ("!exe_ksql!") do set ksql_name=%%~nF
    echo "Run of !ksql_name! at %exe_ksql%"

    docker run -it --rm --name %name_prefix%!ksql_name! ^
        --network=!connect_network! ^
        --mount "type=bind,source=!ksql_path!/!ksql_file!,destination=/init.ksql" ^
        confluentinc/cp-ksqldb-cli:7.0.0 --file /init.ksql http://ksqldb-server:8088
)

cd %current_path%

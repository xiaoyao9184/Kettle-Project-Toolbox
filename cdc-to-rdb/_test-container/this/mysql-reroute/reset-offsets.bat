@echo off
Setlocal enabledelayedexpansion

set current_path=%~dp0
for %%F in ("!current_path!.") do set name=%%~nF
set name_prefix=%name%_
set kafka_network=test-kpt
set kafka_host=kafka:9092
set group=test_kpt.test_kpt_cdc.manual.20220128
set topic=test_debezium_mysql-test_kpt_cdc.data-changes.reroute

docker run -it --rm --name %name_prefix%topic ^
    --network=%kafka_network% ^
    wurstmeister/kafka:2.13-2.7.0 bash -c ^
        "kafka-consumer-groups.sh --bootstrap-server %kafka_host% --group %group% --topic %topic% --reset-offsets --to-offset 0 --execute"

cd %current_path%

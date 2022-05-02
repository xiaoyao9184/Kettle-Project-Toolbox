#!/bin/bash 

current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
name=$(basename "$current_path")
name_prefix=$name\_
kafka_network=test-kpt
kafka_host=kafka:9092
group=test_kpt.test_kpt_cdc.manual.20220128
topic=test_debezium_mysql-test_kpt_cdc.data-changes.binary_bytes

docker run -it --rm --name $name_prefix$topic \
    --network=$kafka_network \
    wurstmeister/kafka:2.13-2.7.0 bash -c \
        "kafka-consumer-groups.sh --bootstrap-server $kafka_host --group $group --topic $topic --reset-offsets --to-offset 0 --execute"

cd $current_path

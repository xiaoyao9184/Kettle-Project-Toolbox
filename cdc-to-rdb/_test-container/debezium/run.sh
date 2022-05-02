#!/bin/bash 
JMX_AGENT_VERSION="0.15.0"
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $current_path

if [[ ! -f ./jmx_prometheus_javaagent.jar ]]
then
    curl -so ./jmx_prometheus_javaagent.jar \
        https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$JMX_AGENT_VERSION/jmx_prometheus_javaagent-$JMX_AGENT_VERSION.jar
fi

docker network create test-kpt --attachable
docker-compose -p test-kpt-debezium up
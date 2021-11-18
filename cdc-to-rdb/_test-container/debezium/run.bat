@echo off
Setlocal enabledelayedexpansion

set JMX_AGENT_VERSION=0.15.0
set current_path=%~dp0
cd %current_path%

if not exist ".\jmx_prometheus_javaagent.jar" (
    curl -so .\jmx_prometheus_javaagent.jar ^
        https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/%JMX_AGENT_VERSION%/jmx_prometheus_javaagent-%JMX_AGENT_VERSION%.jar
)

docker network create test-kpt --attachable
docker-compose -p test-kpt-debezium up
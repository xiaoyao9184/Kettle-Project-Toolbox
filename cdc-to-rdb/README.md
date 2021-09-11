# kpt-cdc-to-rdb

Use the Kettle like a consumer to consume Change-Data-Capture(CDC) event streams in kafka to synchronize data to Relational-Database(RDB)

CDC event streams producers include [canal](https://github.com/alibaba/canal) and [debezium](https://github.com/debezium).

RDB is any relational-data model compatible with kettle JDBC database.

*Support by KPT*


## Build

```sh
DOCKER_BUILDKIT=1 docker build -t kpt-cdc-to-rdb:20210831 -f ./cdc-to-rdb/Dockerfile . 
```

or use PDI_URL mirror like `http://nexus/repository/image-hosted`

```sh
DOCKER_BUILDKIT=1 docker build -t kpt-cdc-to-rdb:20210831 -f ./cdc-to-rdb/Dockerfile . --build-arg PDI_URL=http://nexus/repository/image-hosted
```


## Prepare

No matter what CDC producer is used, 
It is recommended to use one topic to contain all data change events.

[debezium](https://github.com/debezium) output structure change and data change to 2 topics, 
this project will only use the data change topic.


## Compatibility

| CDC producer | db event | support |
|:-----:|:-----:|:-----:|
| canal | mysql | yes |
| debezium | mysql | yes |
| debezium | mssql | yes |
| debezium | ... | no |


## Test

go inside container 

```sh
# bash for linux docker
docker run \
 --rm \
 -it \
 -e TZ=Asia/Hong_Kong \
 -v /etc/localtime:/etc/localtime:ro \
 --entrypoint="/bin/bash" \
 kpt-cdc-to-rdb:20210831
```
```bat
:: windows batch for Docker Desktop
docker run ^
 --rm ^
 -it ^
 -e TZ=Asia/Hong_Kong ^
 -v /etc/localtime:/etc/localtime:ro ^
 --entrypoint="/bin/bash" ^
 kpt-cdc-to-rdb:20210831
```

then you can run any KPT script like this

```sh
bash flow.UseProfileConfigRun.sh Basic test,canal-mysql-pgsql
```


## Run

just run and print log to shell

```sh
docker run \
 --rm \
 -it \
 -e PROFILE=test,canal-mysql-pgsql \
 -e TZ=Asia/Hong_Kong \
 -v /etc/localtime:/etc/localtime:ro \
 kpt-cdc-to-rdb:20210831
```

compose run

```sh
docker tag kpt-cdc-to-rdb:20210831 xiaoyao9184/kpt-cdc-to-rdb
docker compose -f ./cdc-to-rdb/docker-compose.yml up
```

run as stack in swarm

```sh
docker tag kpt-cdc-to-rdb:20210831 xiaoyao9184/kpt-cdc-to-rdb
docker stack deploy -c ./cdc-to-rdb/docker-compose-swarm.yml kpt-canal_kafka_to_pgsql
```


## Customize

See [config.xml] like this, 
you need to define all `cfg` tags that appear below,
but you can define multiple `profile` tags for grouping `cfg`,
then you can combine all cfgs by referring the `profile` name later.

```xml
<config>
	<project name="cdc-to-rdb">
		<cfg key="Name">PDI project:cdc-to-rdb(use xml in rep dir)</cfg>
		<cfg key="Repository">cdc-to-rdb</cfg>
		<cfg key="Version">1.0</cfg>
		<cfg key="Url">https://github.com/xiaoyao9184/Kettle-Project-Toolbox</cfg>
		<cfg key="ExitFlag">false</cfg>
		<cfg key="DebugMode">false</cfg>
		<cfg key="UseStatus">false</cfg>
		<cfg namespace="Config.Time" key="StartTime">2000-01-01</cfg>
		<cfg namespace="Config.Time" key="EndTime">3000-01-01</cfg>
		<cfg namespace="Config.Main.Job" key="Path">/from-kafka</cfg>
		<cfg namespace="Config.Main.Job" key="Name">NONE</cfg>
		<cfg namespace="Config.Main.Transformation" key="Name">kafka_to_stream</cfg>

    <!-- defines database related information -->
    <!-- You can define multiple databases, like 'dev' 'test' 'prod' -->
		<profile name="dev">
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="database">KPT_SYNC</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="server">kpt_sync</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="port">5432</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="username">kpt</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="password">kpt@123</cfg>
		</profile>
		<profile name="test">
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="database">KPT_SYNC</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="server">kpt_sync</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="port">5432</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="username">kpt</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="password">kpt@123</cfg>
		</profile>
		<profile name="prod">
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="database">KPT_SYNC</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="server">kpt_sync</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="port">5432</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="username">kpt</cfg>
			<cfg namespace="Config.DB.db_kpt_cdc_event_pgsql_writer" key="password">kpt@123</cfg>
		</profile>

    <!-- defines the run way -->
	
		<profile name="debezium-mysql-pgsql">
			<cfg namespace="Config.Log.Kafka.Server" key="Bootstrap">kafka:9092</cfg>
			<cfg namespace="Config.Log.Kafka.Consumer" key="Group">kpt.mysql.</cfg>
			<cfg namespace="Config.Log.Kafka.Data" key="Topic">kpt_debezium-mysql</cfg>
			<cfg namespace="Config.Log.Kafka.Stream" key="Transformation">stream_parse_to_each_table</cfg>
			
			<!-- source of cdc -->
			<!-- can be from-debezium of from-canal -->
			<cfg namespace="Config.Log.Source.Transformation" key="Path">from-debezium</cfg>
			<cfg namespace="Config.Log.Source.Table" key="Mapping">mysql_playload_to_table_name.mapping</cfg>
			<cfg namespace="Config.Log.Source.Column" key="Mapping">mysql_column_type_to_kettle.mapping</cfg>
			<cfg namespace="Config.Log.Source.Switch" key="Mapping">debezium_operate_to_kettle_switch_flag.mapping</cfg>
			
			<!-- target of event write on only support 'to_pgsql' -->
			<cfg namespace="Config.Log.Tatget.Transformation" key="Path">to_pgsql</cfg>
			<cfg namespace="Config.Log.Target.Ingore" key="Mapping">pgsql_table_exists.mapping</cfg>
			<cfg namespace="Config.Log.Tatget.Column" key="Mapping">pgsql_column_case.mapping</cfg>
			<!-- define output destination schema and table prefix -->
			<cfg namespace="Config.Log.Tatget.Schema" key="Prefix">kpt_sync__</cfg>
			<cfg namespace="Config.Log.Tatget.Table" key="Prefix"></cfg>
		</profile>

	</project>
</config>
```

After the config information is configured, 
the last step will define the `profile` activated list when docker is running.

```yml
version: 3.7
services:
  test:
    image: xiaoyao9184/kpt-cdc-to-rdb:20210831
    # Activate the profile list in the configuration file, this time use 'prod' and 'debezium-mysql-pgsql'
    environment:
      - PROFILE: prod,debezium-mysql-pgsql
    # Overwrite internal configuration files
    configs:
      - source: config.xml
        target: /home/pentaho/cdc-to-rdb/config.xml
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints:
          - node.platform.os == linux
      restart_policy:
        condition: any
        delay: 5s
        max_attempts: 2
        window: 120s

# Define a swarm shared configuration file
configs:
  config.xml:
    file: ./config.xml
```
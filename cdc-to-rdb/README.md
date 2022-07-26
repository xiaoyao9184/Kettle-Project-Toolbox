# kpt-cdc-to-rdb

Use the Kettle like a consumer to consume Change-Data-Capture(CDC) event streams in kafka to synchronize data to Relational-Database(RDB)

CDC event streams producers include [canal](https://github.com/alibaba/canal) and [debezium](https://github.com/debezium).

RDB is any relational-data model compatible with kettle JDBC database.

*Support by KPT*


## Prepare

No matter what CDC producer is used, 
It is first recommended to use one topic to contain all data change events.
Second recommended to use one-table to one-topic mode.
All topics are recommended only used by this project.

[debezium](https://github.com/debezium) output structure change and data change to 2 topics, 
this project will only use the data change topic.


## Compatibility

Developed based on Debezium v1.7, canal v1.1.5

| CDC producer | db event | support |
|:-----:|:-----:|:-----:|
| canal | mysql | yes |
| debezium | mysql | yes |
| debezium | mssql | yes |
| debezium | ... | no |

| Debezium Property | value | support |
|:-----:|:-----:|:-----:|
| time.precision.mode | adaptive_time_microseconds | yes |
|  | connect | yes |
| decimal.handling.mode | precise | yes |
| | double | yes |
|  | string | yes |
| binary.handling.mode | bytes | yes |
|  | base64 | no |
|  | hex | no |

| database | db type | debezium type | support |
|:-----:|:-----:|:-----:|:-----:|
| mssql | _all type on debezium doc_ | | yes |
| mysql | BINARY | BYTES | yes |
|  |  | STRING | no |
|  | VARBINARY | BYTES | yes |
|  |  | STRING | no |
|  | TINYBLOB | BYTES | yes |
|  |  | STRING | no |
|  | BLOB | BYTES | yes |
|  |  | STRING | no |
|  | MEDIUMBLOB | BYTES | yes |
|  |  | STRING | no |
|  | LONGBLOB | BYTES | yes |
|  |  | STRING | no |
|  | GEOMETRY | STRUCT | no |
|  | LINESTRING | STRUCT | no |
|  | POLYGON | STRUCT | no |
|  | MULTIPOINT | STRUCT | no |
|  | MULTILINESTRING | STRUCT | no |
|  | GEOMETRYCOLLECTION | STRUCT | no |
|  | _other type on debezium doc_ | | yes |

| Debezium with schema registry | schema format | support | tip |
|:-----:|:-----:|:-----:|:-----:|
| NONE | connect_json | yes | MUST enable schema see [key.converter.schemas.enable](https://debezium.io/documentation/reference/stable/configuration/avro.html) |
| Confluent/schema-registry | avro | yes | Bytes data (binary or big number) will use unformatted string not base64, String with only spaces will be converted to null |
| Confluent/schema-registry | json | yes | debezium needs to add kafka-connect-json-schema-converter library patches |
| Confluent/schema-registry | protobuf | no | protobuf not support decimal |
| Apicurio/registry | avro | no | |
| Apicurio/registry | json | no | |
| Apicurio/registry | protobuf | no | |


| CDC producer | CDC log distributed | support | why |
|:-----:|:-----:|:-----:|:-----:|
| canal | all table in one-topic | yes | |
| debezium | all table in one-topic | yes | |
| debezium | one table in one-topic | yes | |
|  | one table in multi-topic | yes | _1._ |
| debezium  | one row in one-topic | yes | |
|  | one row in multi-topic | yes | _2._ |


1. in group-table, the data will be sorted by table, 
if use 'sort_by_table_lsn' all operations will be sorted by event time, 
so events of the same row will also be ordered.
if in an batch, the same row has operated multiple times,
it might be a performance issue.
enable redirect-row and use 'sort_by_table_operate' for group-table will reduce operations on the same row in the same batch.

2. after redirect-row, events for same row will only keep the final merged event, 
the order between different rows is not important.



## Build

in root of this project

```sh
DOCKER_BUILDKIT=1 docker build -t xiaoyao9184/kpt-cdc-to-rdb:dev -f ./cdc-to-rdb/Dockerfile . 
```

```bat
SET DOCKER_BUILDKIT=1&& docker build -t xiaoyao9184/kpt-cdc-to-rdb:dev -f ./cdc-to-rdb/Dockerfile . 
```

go inside container 

```sh
# bash for linux docker
docker run \
 --rm \
 -it \
 -e TZ=Asia/Hong_Kong \
 -v /etc/localtime:/etc/localtime:ro \
 --entrypoint="/bin/bash" \
 xiaoyao9184/kpt-cdc-to-rdb:dev
```
```bat
:: windows batch for Docker Desktop Linux containers mode
docker run ^
 --rm ^
 -it ^
 -e TZ=Asia/Hong_Kong ^
 -v /etc/localtime:/etc/localtime:ro ^
 --entrypoint="/bin/bash" ^
 xiaoyao9184/kpt-cdc-to-rdb:dev
```
```powershell
# powershell for linux docker
docker run `
 --rm `
 -it `
 -e TZ=Asia/Hong_Kong `
 -v /etc/localtime:/etc/localtime:ro `
 --entrypoint="/bin/bash" `
 xiaoyao9184/kpt-cdc-to-rdb:dev
```

then you can run any KPT script like this

```sh
bash kpt.flow.UseProfileConfigRun.sh
```


## Use

Here is a docker image that can be used on docker hub

```sh
docker pull xiaoyao9184/kpt-cdc-to-rdb:latest
```

The docker tag is same as git commit hash short

However, To run this project you need:

- some environment variables, see [Run](#Run)
- an [config.xml](./config.xml), see [Customize](#Customize)

You can refer to the docker-compose.yml in this [directory](./_test-container/this/) to configure your own docker-compose.yml


### Run

just run and print log to shell

```sh
docker run \
 --rm \
 -it \
 -e KPT_KETTLE_PARAM_ProfileName=test,canal-mysql-pgsql \
 -e TZ=Asia/Hong_Kong \
 -v /etc/localtime:/etc/localtime:ro \
 -v ./config.xml:/home/pentaho/kpt-cdc-to-rdb/config.xml \
 xiaoyao9184/kpt-cdc-to-rdb:dev
```

compose run

```sh
docker compose -f ./cdc-to-rdb/_test-container/this/mysql-reroute/docker-compose.yml up
```

run as stack in swarm

```sh
docker stack deploy -c ./cdc-to-rdb/_test-container/this/mysql-reroute/docker-compose.yml kpt-cdc-to-pgsql
```

some environment variable

- ENABLE_PATTERN_TOPIC
- ENABLE_SCHEMA_REGISTRY
- KPT_LOG_PATH
- KPT_KETTLE_LEVEL
- KPT_KETTLE_LOGFILE
- KPT_KETTLE_PARAM_ProfileName


##### ENABLE_PATTERN_TOPIC

If you want to read multiple kafka topics, set it to 'true'.

debezium default use one table output one topic, 
the advantage of this is that the data schema is the same or compatible, 
and ksql can be used to convert the stream data model in the topic into a table data model, 
so it is convenient to deal with strong typing.

But read multiple topics by use regex pattern is not support in kettle,
use this environment variable, replace Kettle big data kafka plugin.

see [pentaho-big-data-kettle-plugins-kafka](./.kpt/lib/pentaho-big-data-kettle-plugins-kafka-9.2.0.0-290/)


##### ENABLE_SCHEMA_REGISTRY

If you use the schema registry, set it to 'true'.

Use schema registry to reduce redundant schemas, 
at the same time, 
the schema part will not be included in the kafka topic, 
and it needs to be obtained from the schema registry through the HTTP api when using it. 

This needs to introduce [kafka-serde-tools-package](https://github.com/confluentinc/schema-registry) and solve the conflict problem of related dependencies in kettle after importing the class library.

see [kpt-schema-package](./kpt-schema-package/) [link_libs](./.kpt/lib/link_libs.ps1)


##### KPT_* environment variable

Environment variables starting with 'KPT' are defined by scripts in the KPT project.

see [this](./../shell/README.md)


### Customize

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
		<cfg namespace="Config" key="Time.StartTime">2000-01-01</cfg>
		<cfg namespace="Config" key="Time.EndTime">3000-01-01</cfg>
		<cfg namespace="Config" key="Main.Job.Path">/from_kafka</cfg>
		<cfg namespace="Config" key="Main.Job.Name">NONE</cfg>
		<cfg namespace="Config" key="Main.Transformation.Name">cdc_to_batch</cfg>
		
		<!-- delay for debug reduce rate -->
        <cfg namespace="Config" key="CDC.Debug.Delay.Injection.Crud.Time">0</cfg>
        <cfg namespace="Config" key="CDC.Debug.Delay.Injection.Field.Time">0</cfg>

		<!-- kafka streaming to batch window settings -->
		<!-- bigger mean more memory, more faster and more loss ratio if it fails -->
        <cfg namespace="Config" key="CDC.Kafka.Batch.Size">10000</cfg>
        <cfg namespace="Config" key="CDC.Kafka.Batch.Duration">60000</cfg>
        <cfg namespace="Config" key="CDC.Kafka.Batch.Max">10000</cfg>

    <!-- defines database related information -->
	<!-- this database is used to restore cdc stream log to table, also output the kettle log, and query some parameters -->
    <!-- You can define multiple databases, like 'dev' 'test' 'prod' -->
		<profile name="dev">
			<cfg namespace="Config" key="CDC.RDB.Writer.Database">KPT_SYNC</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Server">kpt_sync</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Port">5432</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Username">kpt</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Password">kpt@123</cfg>
		</profile>
		<profile name="test">
			<cfg namespace="Config" key="CDC.RDB.Writer.Database">KPT_SYNC</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Server">kpt_sync</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Port">5432</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Username">kpt</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Password">kpt@123</cfg>
		</profile>
		<profile name="prod">
			<cfg namespace="Config" key="CDC.RDB.Writer.Database">KPT_SYNC</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Server">kpt_sync</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Port">5432</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Username">kpt</cfg>
			<cfg namespace="Config" key="CDC.RDB.Writer.Password">kpt@123</cfg>
		</profile>

    <!-- defines the run way -->
	
		<profile name="debezium-mysql-pgsql">
		<!-- kafka consumer -->
			<cfg namespace="Config" key="CDC.Kafka.Server.Bootstrap">kafka:9092</cfg>
			<cfg namespace="Config" key="CDC.Kafka.Consumer.Group">kpt_cdc_ro_rdb</cfg>
			<cfg namespace="Config" key="CDC.Kafka.Data.Topic">kpt_debezium-mysql</cfg>
            
		<!-- logger of cdc -->
			<cfg namespace="Config" key="CDC.Log.RDB.Schema">kpt_cdc_log</cfg>
			<cfg namespace="Config" key="CDC.Log.Kafka.Topic">kpt_debezium_mysql.kpt-cdc-log</cfg>
			<!-- see from_kafka/batch_group_logger.mapping -->
			<cfg namespace="Config" key="CDC.Log.Group.Mapping">log_json_to_kafka</cfg>

		<!-- batch of cdc -->
			<!-- see from_kafka/schema_formatter.mapping -->
			<!-- 'connect_json' json without schema-registry -->
			<!-- 'schema_registry_avro' avro with schema-registry -->
			<!-- 'schema_registry_json' json with schema-registry -->
			<cfg namespace="Config" key="CDC.Batch.Schema.Format.Mapping">connect_json</cfg>
			<!-- set if use schema-registry -->
			<cfg namespace="Config" key="CDC.Batch.Schema.Registry.Url">http://schema-registry:58081</cfg>

			<!-- see from_kafka/group_table.mapping -->
			<cfg namespace="Config" key="CDC.Batch.Group.Table.Mapping">sort_by_table_lsn</cfg>
			<!-- 'none' no redirect -->
			<!-- 'sort_by_table_lsn' group by table sort by time -->
			<!-- 'sort_by_table_operate' only use when no duplicate row in batch mean use 'Redirect.Row' -->
			<!-- see from_kafka/redirect_row.mapping/README.md -->
			<!-- 'none' no redirect -->
			<!-- 'sort_by_row_last' and 'group_by_row_last' just different performance -->
			<cfg namespace="Config" key="CDC.Batch.Redirect.Row.Mapping">none</cfg>

		<!-- source of cdc -->
			<!-- can be 'from_debezium' of 'from_canal' -->
			<cfg namespace="Config" key="CDC.Source.Transformation.Path">from_debezium</cfg>
			<!-- see from_debezium/source_row.mapping -->
			<!-- switching prefixes of 'mysql_' for mysql 'mssql_' for mssql -->
			<cfg namespace="Config" key="CDC.Source.Row.Mapping">mysql_payload</cfg>
			<!-- see from_debezium/source_column.mapping -->
			<!-- switching prefixes of 'mysql_' for mysql 'mssql_' for mssql -->
			<cfg namespace="Config" key="CDC.Source.Column.Mapping">mysql_schema</cfg>
			<!-- see from_debezium/source_key.mapping -->
			<cfg namespace="Config" key="CDC.Source.Key.Mapping">key_schema</cfg>
			
		<!-- target of rdb -->
			<!-- target of event write on only support 'to_pgsql' -->
			<cfg namespace="Config" key="CDC.Target.Transformation.Path">to_pgsql</cfg>
			<!-- see to_rdb/target_table.mapping -->
			<!-- 'same_source_exist' use source table name of target table -->
			<!-- 'config_prefix_exist' use xml config mapping target table -->
			<!-- 'database_mapping_exist' use table 'kpt_cdc_data.mapping_table' mapping target table -->
			<cfg namespace="Config" key="CDC.Target.Table.Mapping">config_prefix_exist</cfg>
			<!-- see to_rdb/target_operate.mapping -->
			<!-- 'same_source' use source operate name of target operate -->
			<!-- 'update_only_flash_point' replace source operate with 'update' operate -->
			<cfg namespace="Config" key="CDC.Target.Operate.Mapping">update_only_flash_point</cfg>
			<!-- see to_rdb/target_column.mapping -->
			<!-- no change for now -->
			<cfg namespace="Config" key="CDC.Target.Column.Mapping">same_source</cfg>
			<!-- see to_rdb/target_key.mapping -->
			<!-- 'same_source' use source key for target key -->
			<!-- 'target_key_lookup' use target table key -->
			<!-- use 'target_key_lookup' if source table no primary key but target have -->
			<cfg namespace="Config" key="CDC.Target.Key.Mapping">same_source</cfg>

		<!-- config_prefix_exist -->
			<!-- define output destination schema and table prefix by 'config_prefix_exist' -->
			<cfg namespace="Config" key="CDC.Target.Table.Prefix.Schema">kpt_sync__</cfg>
			<cfg namespace="Config" key="CDC.Target.Table.Prefix.Table"></cfg>

		<!-- update_only_flash_point -->
			<!-- flashpoint, before make the INSERT (SNAPSHOT) event change into UPDATE operation for compatibility -->
			<!-- even if the data INSERT event is lost, it will not affect subsequent events -->
			<!-- can define a future timestamp, or a delay seconds for root job run time with past timestamp -->
			<cfg namespace="Config" key="CDC.Target.Operate.UpdateOnly.FlashPoint.Include">INSERT,INSERT_BLUK</cfg>
			<cfg namespace="Config" key="CDC.Target.Operate.UpdateOnly.FlashPoint.Delay">86400</cfg>
			<cfg namespace="Config" key="CDC.Target.Operate.UpdateOnly.FlashPoint.Timestamp">2000-01-01T00:00:00.000Z</cfg>

		<!-- target of pgsql -->
			<!-- use 'true' will add quotation marks to field names -->
			<!-- use 'false' will automatically convert to lowercase -->
			<cfg namespace="Config" key="CDC.Target.PgSql.Case.Sensitive">true</cfg>
		
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
    image: xiaoyao9184/kpt-cdc-to-rdb:dev
    # Activate the profile list in the configuration file, this time use 'prod' and 'debezium-mysql-pgsql'
    environment:
      - KPT_KETTLE_PARAM_ProfileName: prod,debezium-mysql-pgsql
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
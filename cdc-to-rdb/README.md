# kpt-cdc-to-rdb

Use the Kettle like a consumer to consume Change-Data-Capture(CDC) event streams in kafka to synchronize data to Relational-Database(RDB)

CDC event streams producers include [canal](https://github.com/alibaba/canal) and [debezium](https://github.com/debezium).

RDB is any relational-data model compatible with kettle JDBC database.

*Support by KPT*


## Build

```sh
DOCKER_BUILDKIT=1 docker build -t xiaoyao9184/kpt-cdc-to-rdb:dev -f ./cdc-to-rdb/Dockerfile . 
```


## Prepare

No matter what CDC producer is used, 
It is recommended to use one topic to contain all data change events.

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
 xiaoyao9184/kpt-cdc-to-rdb:dev
```
```bat
:: windows batch for Docker Desktop
docker run ^
 --rm ^
 -it ^
 -e TZ=Asia/Hong_Kong ^
 -v /etc/localtime:/etc/localtime:ro ^
 --entrypoint="/bin/bash" ^
 xiaoyao9184/kpt-cdc-to-rdb:dev
```

then you can run any KPT script like this

```sh
bash kpt.flow.UseProfileConfigRun.sh Basic test,canal-mysql-pgsql
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
		<cfg namespace="Config.Main.Transformation" key="Name">cdc_to_batch</cfg>
		<!-- delay for debug reduce rate -->
        <cfg namespace="Config.Delay.Injection.Crud" key="Time">0</cfg>
        <cfg namespace="Config.Delay.Injection.Field" key="Time">0</cfg>
		<!-- flashpoint, before make the INSERT (SNAPSHOT) event change into UPDATE operation for compatibility -->
		<!-- even if the data INSERT event is lost, it will not affect subsequent events -->
		<!-- can define a future timestamp, or a delay seconds for root job run time with past timestamp -->
        <cfg namespace="Config.CDC.Target.Operate.UpdateOnly.FlashPoint" key="Include">INSERT,SNAPSHOT</cfg>
        <cfg namespace="Config.CDC.Target.Operate.UpdateOnly.FlashPoint" key="Delay">86400</cfg>
        <cfg namespace="Config.CDC.Target.Operate.UpdateOnly.FlashPoint" key="Timestamp">2000-01-01T00:00:00.000Z</cfg>
		<!-- kafka streaming to batch window settings -->
		<!-- bigger mean more memory, more faster and more loss ratio if it fails -->
        <cfg namespace="Config.CDC.Kafka.Batch" key="Size">10000</cfg>
        <cfg namespace="Config.CDC.Kafka.Batch" key="Duration">60000</cfg>
        <cfg namespace="Config.CDC.Kafka.Batch" key="Max">10000</cfg>

    <!-- defines database related information -->
    <!-- You can define multiple databases, like 'dev' 'test' 'prod' -->
		<profile name="dev">
			<cfg namespace="Config.CDC.RDB.pgsql" key="database">KPT_SYNC</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="server">kpt_sync</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="port">5432</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="username">kpt</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="password">kpt@123</cfg>
		</profile>
		<profile name="test">
			<cfg namespace="Config.CDC.RDB.pgsql" key="database">KPT_SYNC</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="server">kpt_sync</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="port">5432</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="username">kpt</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="password">kpt@123</cfg>
		</profile>
		<profile name="prod">
			<cfg namespace="Config.CDC.RDB.pgsql" key="database">KPT_SYNC</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="server">kpt_sync</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="port">5432</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="username">kpt</cfg>
			<cfg namespace="Config.CDC.RDB.pgsql" key="password">kpt@123</cfg>
		</profile>

    <!-- defines the run way -->
	
		<profile name="debezium-mysql-pgsql">
		<!-- kafka consumer -->
			<cfg namespace="Config.CDC.Kafka.Server" key="Bootstrap">kafka:9092</cfg>
			<cfg namespace="Config.CDC.Kafka.Consumer" key="Group">kpt.mysql.</cfg>
			<cfg namespace="Config.CDC.Kafka.Data" key="Topic">kpt_debezium-mysql</cfg>

		<!-- source of cdc -->
			<!-- can be 'from-debezium' of 'from-canal' -->
			<cfg namespace="Config.CDC.Source.Transformation" key="Path">from-debezium</cfg>
			<!-- switching prefixes of 'mysql_' for mysql 'mssql_' for mssql -->
			<cfg namespace="Config.CDC.Source.Table" key="Mapping">mysql_playload_to_table_name.mapping</cfg>
			<cfg namespace="Config.CDC.Source.Column" key="Mapping">mysql_column_type_to_kettle.mapping</cfg>
			<!-- see from-debezium/source_key.mapping -->
			<!-- use 'target_table' if source table no primary key but target have -->
			<cfg namespace="Config.CDC.Source.Key" key="Mapping">debezium_key_to_key_meta</cfg>
			<!-- no change -->
			<cfg namespace="Config.CDC.Target.Operate" key="Mapping">update_only_flash_point</cfg>
			
		<!-- target of rdb -->
			<!-- target of event write on only support 'to_pgsql' -->
			<cfg namespace="Config.CDC.Target.Transformation" key="Path">to_pgsql</cfg>
			<!-- see to_rdb/target_table.mapping -->
			<!-- config_prefix_lookup use xml config mapping target table -->
			<!-- database_mapping_exist use table 'kpt_cdc_data.mapping_table' mapping target table -->
			<cfg namespace="Config.CDC.Target.Table" key="Mapping">config_prefix_lookup</cfg>
			<!-- see to_pgsql/target_column.mapping -->
			<!-- no change for now -->
			<cfg namespace="Config.CDC.Target.Column" key="Mapping">same_source</cfg>
			<!-- true case sensitive or pgsql will automatically convert to lowercase -->
			<cfg namespace="Config.CDC.Target.Case" key="Name">true</cfg>
			<!-- define output destination schema and table prefix by 'config_prefix_lookup' -->
			<cfg namespace="Config.CDC.Target.Schema" key="Prefix">kpt_sync__</cfg>
			<cfg namespace="Config.CDC.Target.Table" key="Prefix"></cfg>
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
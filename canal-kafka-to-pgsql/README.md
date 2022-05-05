# kpt-canal-kafka-to-pgsql

Use the Kettle like a consumer to consume canal mysql binlog in kafka to synchronize data to pgsql

*Support by KPT*


## Build

```sh
DOCKER_BUILDKIT=1 docker build -t kpt-canal-kafka-to-pgsql:20210801 -f ./canal-kafka-to-pgsql/Dockerfile . 
```

or use PDI_URL mirror like `http://nexus/repository/image-hosted`

```sh
DOCKER_BUILDKIT=1 docker build -t kpt-canal-kafka-to-pgsql:20210801 -f ./canal-kafka-to-pgsql/Dockerfile . --build-arg PDI_URL=http://nexus/repository/image-hosted
```


## Prepare

*The username, password, ip and other configuration information provided can be customized, and the default values ​​will be used here for demonstration*

Need [canal](https://github.com/alibaba/canal) server 
and output [mysql](https://github.com/mysql/mysql-server) binlog 
to [kafka](https://github.com/apache/kafka) server with `kafka` bootstrap 
and `bin_log.mysql` topic

Then install [pgsql](https://github.com/postgres/postgres) server 
with `kpt_sync` ip, `5432` port, `edata_kpt` user and `edata_kpt@123` password,
add Kettle log table and schema, you can use script [kpt_log.sql].

last create database `KPT_SYNC`. create the table and schema you want to be synchronized.
create schema with prefix `kpt_sync__` use mysql database name,
create same table like mysql table.


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
 kpt-canal-kafka-to-pgsql:20210801
```
```bat
:: windows batch for Docker Desktop
docker run ^
 --rm ^
 -it ^
 -e TZ=Asia/Hong_Kong ^
 -v /etc/localtime:/etc/localtime:ro ^
 --entrypoint="/bin/bash" ^
 kpt-canal-kafka-to-pgsql:20210801
```

then you can run any KPT script like this

```sh
bash kpt.flow.UseProfileConfigRun.sh Basic test,stream_all-bin_log.mysql
```


## Run

just run and print log to shell

```sh
docker run \
 --rm \
 -it \
 -e PROFILE=test,stream_all-bin_log.mysql \
 -e TZ=Asia/Hong_Kong \
 -v /etc/localtime:/etc/localtime:ro \
 kpt-canal-kafka-to-pgsql:20210801
```

compose run

```sh
docker tag kpt-canal-kafka-to-pgsql:20210801 xiaoyao9184/kpt-canal-kafka-to-pgsql
docker compose -f ./canal-kafka-to-pgsql/docker-compose.yml up
```

run as stack in swarm

```sh
docker tag kpt-canal-kafka-to-pgsql:20210801 xiaoyao9184/kpt-canal-kafka-to-pgsql
docker stack deploy -c ./canal-kafka-to-pgsql/docker-compose-swarm.yml kpt-canal_kafka_to_pgsql
```


## Customize

See [config.xml] like this, 
you need to define all `cfg` tags that appear below,
but you can define multiple `profile` tags for grouping `cfg`,
then you can combine all cfgs by referring the `profile` name later.

```xml
<config>
	<project name="canal-kafka-to-pgsql">
		<cfg key="Name">PDI project:canal-kafka-to-pgsql(use xml in rep dir)</cfg>
		<cfg key="Repository">canal-kafka-to-pgsql</cfg>
		<cfg key="Version">1.0</cfg>
		<cfg key="Url">https://github.com/xiaoyao9184/Kettle-Project-Toolbox</cfg>
		<cfg key="ExitFlag">false</cfg>
		<cfg key="DebugMode">false</cfg>
		<cfg key="UseStatus">false</cfg>
		<cfg namespace="Config.Time" key="StartTime">2000-01-01</cfg>
		<cfg namespace="Config.Time" key="EndTime">3000-01-01</cfg>
		<cfg namespace="Config.Main.Job" key="Path">/mysql-log</cfg>
		<cfg namespace="Config.Main.Job" key="Name">NONE</cfg>

    <!-- defines database related information -->
    <!-- You can define multiple databases, like 'dev' 'test' 'prod' -->
		<profile name="dev">
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="database">KPT_SYNC</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="server">kpt_sync</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="port">5432</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="username">edata_kpt</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="password">edata_kpt@123</cfg>
		</profile>
		<profile name="test">
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="database">KPT_SYNC</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="server">kpt_sync</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="port">5432</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="username">edata_kpt</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="password">edata_kpt@123</cfg>
		</profile>
		<profile name="prod">
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="database">KPT_SYNC</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="server">kpt_sync</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="port">5432</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="username">edata_kpt</cfg>
			<cfg namespace="Config.DB.db_kpt_bin_log_pgsql_writer" key="password">edata_kpt@123</cfg>
		</profile>

    <!-- defines the run way -->
    <!-- one way (not recommend)-->
		<profile name="kafka_bin_log.mysql__all">
			<cfg namespace="Config.Main.Transformation" key="Name">mysql_log_from_canal_kafka_to_each_table</cfg>
			<cfg namespace="Config.Log.Kafka.Server" key="Bootstrap">kafka</cfg>
			<cfg namespace="Config.Log.Kafka.Consumer" key="Group">edata-kpt-20210801-mysql_log_from_canal_kafka_to_each_table</cfg>
			<cfg namespace="Config.Log.Kafka.Data" key="Topic">bin_log.mysql</cfg>
			<cfg namespace="Config.Log.Kafka.Stream" key="Transformation">stream_log_sort_by_db_table</cfg>
			
			<cfg namespace="Config.Log.Target.Ingore" key="Mapping">pgsql_table_exists.mapping</cfg>
			<cfg namespace="Config.Log.Target.Field" key="Mapping">pgsql_column_case.mapping</cfg>
			<cfg namespace="Config.Log.Target.Write" key="Template">pgsql_table_log_write.template</cfg>
			
      <!-- define output destination schema and table prefix -->
      <cfg namespace="Config.Log.Target.Schema" key="Prefix">kpt_sync__</cfg>
			<cfg namespace="Config.Log.Target.Table" key="Prefix"></cfg>
		</profile>

    <!-- another way (recommend) -->
		<profile name="stream_all-bin_log.mysql">
			<cfg namespace="Config.Main.Transformation" key="Name">mysql_log_from_canal_kafka</cfg>
			<cfg namespace="Config.Log.Kafka.Server" key="Bootstrap">kafka</cfg>
			<cfg namespace="Config.Log.Kafka.Consumer" key="Group">edata-kpt-20210801-mysql_log_from_canal_kafka</cfg>
			<cfg namespace="Config.Log.Kafka.Data" key="Topic">bin_log.mysql</cfg>
			<cfg namespace="Config.Log.Kafka.Stream" key="Transformation">stream_log_to_each_table</cfg>
			
			<cfg namespace="Config.Log.Target.Ingore" key="Mapping">pgsql_table_exists.mapping</cfg>
			<cfg namespace="Config.Log.Target.Field" key="Mapping">pgsql_column_case.mapping</cfg>
			<cfg namespace="Config.Log.Target.Write" key="Template">pgsql_table_log_write.template</cfg>
			<cfg namespace="Config.Log.Target.Schema" key="Prefix">kpt_sync__</cfg>
			<cfg namespace="Config.Log.Target.Table" key="Prefix"></cfg>
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
    image: xiaoyao9184/kpt-canal-kafka-to-pgsql:20210801
    # Activate the profile list in the configuration file
    environment:
      - PROFILE: prod,stream_all-bin_log.mysql
    # Overwrite internal configuration files
    configs:
      - source: config.xml
        target: /home/pentaho/canal-kafka-to-pgsql/config.xml
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
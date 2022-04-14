#!/bin/bash 

current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
exe_ksql=$1
name_prefix=test-kpt_ksql_cli_
connect_network=test-kpt
connect_host=connect

if [[ ! -f $exe_ksql ]]; then exe_ksql=$current_path/ksql; fi

if [[ -d $exe_ksql ]]
then
    ksql_path=$exe_ksql
    cd $ksql_path
    echo "Run all in $ksql_path"
    for f in $ksql_path/*.ksql ; do
        ksql_file=$(basename "$f")
        ksql_name=${ksql_file%.*}
        ksql_name=${ksql_name//\./_}
        echo "Run of $ksql_name"

        docker run -it --rm --name $name_prefix$ksql_name \
            --network=$connect_network \
            --mount "type=bind,source=$ksql_path/$ksql_file,destination=/init.ksql" \
            confluentinc/cp-ksqldb-cli:7.0.0 --file /init.ksql \
		 	    http://ksqldb-server:8088
    done
else
    shift
    ksql_path=$(cd "$(dirname $exe_ksql)"; pwd)
    ksql_file=$(basename $exe_ksql)
    ksql_name=${ksql_file%.*}
    ksql_name=${ksql_name//\./_}
    cd $ksql_path
    echo "Run of $ksql_file at $exe_ksql"

    docker run -it --rm --name $name_prefix$ksql_name \
        --network=$connect_network \
        --mount "type=bind,source=$ksql_path/$ksql_file,destination=/init.ksql" \
        confluentinc/cp-ksqldb-cli:7.0.0 --file /init.ksql http://ksqldb-server:8088
fi

cd $current_path

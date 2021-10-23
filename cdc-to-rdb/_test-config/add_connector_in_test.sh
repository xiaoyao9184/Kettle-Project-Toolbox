#!/bin/bash 

current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
path=$1

if [[ ! -f $path ]]
then
    echo "Run all"
    for f in $current_path/connector/*.json ; do
        name=$(basename -s .json "$f")
        echo "Run of $name"
        docker run -it --rm --name test_connect_connector_$n \
            --network=test-debezium-distributed_default \
            --mount "type=bind,source=$current_path/config/$name.json,destination=/connector.json" \
            debezium/tooling:latest bash -c \
		 	    "curl -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' -d @/connector.json connects:8083/connectors/"
                # "curl connects:8083"
                # "curl -H 'Accept:application/json' connects:8083/connectors/"
            
    done
else
    shift
    name=$(basename $path)
    path=$(cd "$(dirname $path)"; pwd)
    echo "Run of $name in $path"
    n="${name//\./_}" 

    docker run -it --rm --name test_connect_connector_$n \
        --network=test-debezium-distributed_default \
        --mount "type=bind,source=$path/$name,destination=/connector.json" \
        debezium/tooling:latest bash -c \
		    "curl -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' -d @/connector.json connects:8083/connectors/"
            # "curl connects:8083"
            # "curl -H 'Accept:application/json' connects:8083/connectors/"
            
fi

cd $current_path

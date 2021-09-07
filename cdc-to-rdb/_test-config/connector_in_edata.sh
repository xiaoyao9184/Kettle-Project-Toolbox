#!/bin/bash 

current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
name=$1

if [ "$name" == "" ]
then
    echo "Run all"
    for f in $current_path/*.json ; do
        name=$(basename -s .json "$f")
        echo "Run of $name"
        docker run -it --rm --name edata-debezium_connector_$n \
            --network=edata-debezium_default \
            --mount "type=bind,source=$current_path/$name.json,destination=/connector.json" \
            debezium/tooling:latest bash -c \
		 	    "curl -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' -d @/connector.json connect:8083/connectors/"
                # "curl connect:8083"
                # "curl -H 'Accept:application/json' connect:8083/connectors/"
            
    done
else
    shift
    echo "Run of $name"
    n="${name//\./_}" 

    docker run -it --rm --name edata-debezium_connector_$n \
        --network=edata-debezium_default \
        --mount "type=bind,source=$current_path/$name.json,destination=/connector.json" \
        debezium/tooling:latest bash -c \
		    "curl -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' -d @/connector.json connect:8083/connectors/"
            # "curl connect:8083"
            # "curl -H 'Accept:application/json' connect:8083/connectors/"
            
fi

cd $current_path

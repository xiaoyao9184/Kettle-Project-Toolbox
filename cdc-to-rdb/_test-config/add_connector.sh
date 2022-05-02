#!/bin/bash 

connector_config=$1
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ ! -f $connector_config ]]; then connector_config=$current_path/config_of_connector; fi

if [[ -d $connector_config ]]
then
    connector_path=$connector_config
    cd $connector_path
    echo "Run all in $connector_path"
    for f in $connector_path/*.json ; do
        connector_file=$(basename "$f")
        echo "Run of $connector_file"

        curl -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' -d @$connector_file localhost:58083/connectors/   
    done
else
    shift
    connector_path=$(cd "$(dirname $connector_config)"; pwd)
    connector_file=$(basename $connector_config)
    cd $connector_path
    echo "Run of $connector_file at $connector_config"

    curl -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' -d @$connector_file localhost:58083/connectors/      
fi

cd $current_path

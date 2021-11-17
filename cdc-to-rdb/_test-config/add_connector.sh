#!/bin/bash 

connect_config=$1
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
connect_host=localhost

if [[ ! -f $connect_config ]]
then
    echo "Run all"
    for f in $current_path/config_of_connector/*.json ; do
        name=$(basename "$f")
        name="${name//\./_}" 
        echo "Run of $name"

        curl -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' -d @/config_of_connector/$name.json localhost:58083/connectors/
            
    done
else
    shift
    path=$(cd "$(dirname $connect_config)"; pwd)
    name=$(basename $connect_config)
    name="${name//\./_}" 
    echo "Run of $name in $path"

    curl -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' -d @/config_of_connector/$name.json localhost:58083/connectors/
            
fi

cd $current_path

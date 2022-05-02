#!/bin/ash 

if [[ -z "$PC_CONFIG" ]]; then
    echo "ERROR: missing PC_CONFIG environment!"
    exit 1
fi

if [[ -z "$PC_SOURCE" ]]; then
    echo "ERROR: missing PC_SOURCE environment!"
    exit 1
fi


echo "===================="
echo "create_replica_schema and upgrade_replica_schema"
echo "--------------------"
chameleon create_replica_schema --config $PC_CONFIG --debug --allow-root
chameleon upgrade_replica_schema --config $PC_CONFIG --debug --allow-root

echo "===================="
echo "add_source and update_schema_mappings"
echo "--------------------"
chameleon add_source --config $PC_CONFIG --source $PC_SOURCE --debug --allow-root
chameleon update_schema_mappings --config $PC_CONFIG --source $PC_SOURCE --debug --allow-root

echo "===================="
echo "check replica status"
echo "--------------------"
chameleon show_status --config $PC_CONFIG --source $PC_SOURCE --debug --allow-root

status_type="mysql pgsql"
status_status="ready initialising initialised syncing synced error running stopped"
status_read_lag="N/A N/A"
status_replay_lag="N/A N/A"
status=$(chameleon show_status --config $PC_CONFIG --source $PC_SOURCE --debug --allow-root | awk "/${PC_SOURCE}/ { print }")
index=0
for s in $status;
do
    if [[ $index -eq 2 ]]
    then
        status_type="$s"
    fi
    if [[ $index -eq 3 ]]
    then
        status_status="$s"
    fi
    if [[ $index -eq 5 ]]
    then
        status_read_lag="$s"
    fi
    if [[ "$status_read_lag" == "N/A" && $index -eq 6 ]]
    then
        status_replay_lag="$s"
    elif [[ "$status_read_lag" != "N/A" && $index -eq 7 ]]
    then
        status_replay_lag="$s"
    fi
    index=$((index+1))
done

if [[ "$status_status" == "stopped" ]]
then
    # TODO
    # mybe start_replica error
    if [[ $status_replay_lag != "N/A" ]]
    then
        echo "WARNING: start_replica error, will rerun init_replica!"
        status_status="error"
    fi
fi

if [[ "$status_status" == "error" || "$status_status" == "ready" || "$status_status" == "initialising" ]]
then
    echo "===================="
    echo "init_replica"
    echo "--------------------"

    retry_count=0
    if [[ -z "$PC_RETRY" ]]
    then
        PC_RETRY=1
    fi
    until [[ $retry_count -gt $PC_RETRY ]]
    do
        if [[ $retry_count -gt 0 ]]
        then
            echo "Retry $retry_count/$PC_RETRY."
            chameleon stop_replica --config $PC_CONFIG --source $PC_SOURCE --debug --allow-root
            chameleon enable_replica --config $PC_CONFIG --source $PC_SOURCE --debug --allow-root
        fi

        chameleon init_replica --config $PC_CONFIG --source $PC_SOURCE --debug --allow-root
        if [[ $? -ne 0 ]]
        then
            retry_count=$((retry_count+1))
        else
            retry_count=$((PC_RETRY+2))
        fi
    done
    if [[ $retry_count -ne $((PC_RETRY+2)) ]]
    then
        echo "ERROR: cant continue!"
        exit 1
    fi
elif [[ "$status_type" == "mysql" && "$status_status" == "syncing" ]]
then
    if [[ -z "$PC_SCHEMA" ]]
    then
        echo "ERROR: missing PC_SCHEMA environment!"
        exit 1
    fi
    
    echo "===================="
    echo "need refresh schema: $PC_SCHEMA"
    echo "--------------------"
    schemas=$(echo $PC_SCHEMA | tr "," " ")
    for schema in $schemas
    do
        echo "--------------------"
        echo "refresh_schema $schema"
        echo "--------------------"
        
        retry_count=0
        if [[ -z "$PC_RETRY" ]]
        then
            PC_RETRY=1
        fi
        until [[ $retry_count -gt $PC_RETRY ]]
        do
            chameleon refresh_schema --config $PC_CONFIG --source $PC_SOURCE --schema $schema --debug --allow-root
            if [[ $? -ne 0 ]]
            then
                retry_count=$((retry_count+1))
            else
                retry_count=$((PC_RETRY+2))
            fi
        done
        if [[ $retry_count -ne $((PC_RETRY+2)) ]]
        then
            echo "ERROR: cant continue!"
            exit 1
        fi
    done
else
    echo "===================="
    echo "enable_replica(stop)"
    echo "--------------------"
    # alway use debug model so no background pid create
    # chameleon stop_replica --config $PC_CONFIG --source $PC_SOURCE --debug --allow-root
    chameleon enable_replica --config $PC_CONFIG --source $PC_SOURCE --debug --allow-root
fi


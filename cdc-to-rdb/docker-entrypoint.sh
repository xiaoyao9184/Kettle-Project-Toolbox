#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2022-06-28


: ${ENABLE_SCHEMA_REGISTRY:=false}


# https://stackoverflow.com/questions/37490013/parse-jar-filenames
function function_parse_jar_filenames() {
    filename=$1

    filename="${filename#./}"
    name="${filename%%-[0-9]*}" 
    version="${filename#$name-}"
    version="${version%.jar}"

    _result_name="$name"
    _result_version="$version"
}

function function_link_libs() {
    source_dir=$1
    target_dir=$2

    for lib_path in $source_dir/*.jar; do
        filename=$(basename $lib_path)
        lib_conflict=""
        function_parse_jar_filenames "$filename"
        lib_conflict=$(find $target_dir/ | grep "/$_result_name-[0-9]")
        if [[ -n "$lib_conflict" ]]; then
            echo "find conflict lib '$lib_conflict' with '$_result_name' '$_result_version'"
            lib_backup="$lib_conflict.bak"
            mv "$lib_conflict" "$lib_backup"
	    fi
    done

    ln -snf $source_dir/* "$target_dir/"
}

function function_unlink_libs() {
    source_dir=$1
    target_dir=$2

    for lib_path in $source_dir/*.jar; do
        filename=$(basename $lib_path)
        lib_backup=""
        function_parse_jar_filenames "$filename"
        lib_backup=$(find $target_dir/ | grep "/$_result_name.*bak")
        if [[ -n "$lib_backup" ]]; then
            echo "find backup lib '$lib_backup' with '$filename'"
            lib_conflict=$(echo $lib_backup | sed 's/.bak//')
            mv "$lib_backup" "$lib_conflict"
	    fi
    done

    find $target_dir/ -lname "$source_dir/*" -exec rm -f {} \;
}

# link libs to kettle
SCHEMA_REGISTRY_DIR=$(realpath "$PENTAHO_HOME/kpt-cdc-to-rdb/.pdi/lib/kpt-registry-schema-package-${PDI_VERSION}-package") 
if [[ "${ENABLE_SCHEMA_REGISTRY}" == "true" && -d "$SCHEMA_REGISTRY_DIR" ]] ; then
    # backup conflict lib

    # KAFKA_CLIENTS_LIB=$(find $PENTAHO_HOME/data-integration/lib/ | grep kafka-client)
    # mv "$KAFKA_CLIENTS_LIB" "$KAFKA_CLIENTS_LIB.bak"

    # ln -snf $SCHEMA_REGISTRY_DIR/* "$PENTAHO_HOME/data-integration/lib/"
    
    function_link_libs "$SCHEMA_REGISTRY_DIR" "$PENTAHO_HOME/data-integration/lib"
    echo "schema registry enabled!"
else
    # find $PENTAHO_HOME/data-integration/lib/ -lname "$SCHEMA_REGISTRY_DIR/*" -exec rm -f {} \;

    # # restore conflict lib
    # KAFKA_CLIENTS_LIB_BAK=$(find $PENTAHO_HOME/data-integration/lib/ | grep 'kafka-client.*bak')
    # KAFKA_CLIENTS_LIB=$(echo $KAFKA_CLIENTS_LIB_BAK | sed 's/.bak//')
    # mv "$KAFKA_CLIENTS_LIB_BAK" "$KAFKA_CLIENTS_LIB"
    
    function_unlink_libs "$SCHEMA_REGISTRY_DIR" "$PENTAHO_HOME/data-integration/lib"
    echo "schema registry disbaled!"
fi


bash ./kpt.flow.UseProfileConfigRun.sh <&-

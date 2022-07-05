
# change it for maven dep download
MAVEN_DEP_DESTINATION_BAK=$MAVEN_DEP_DESTINATION
MAVEN_DEP_DESTINATION=$KAFKA_HOME/libs 

source /usr/local/bin/docker-maven-download

maven_dep() {
    local REPO="$1"
    local GROUP="$2"
    local PACKAGE="$3"
    local VERSION="$4"
    local FILE="$5"
    local MD5_CHECKSUM="$6"

    DOWNLOAD_FILE_TMP_PATH="/tmp/maven_dep/${PACKAGE}"
    DOWNLOAD_FILE="$DOWNLOAD_FILE_TMP_PATH/$FILE"
    test -d $DOWNLOAD_FILE_TMP_PATH || mkdir -p $DOWNLOAD_FILE_TMP_PATH

    curl -sfSL -o "$DOWNLOAD_FILE" "$REPO/$GROUP/$PACKAGE/$VERSION/$FILE"

    if [[ -z "$MD5_CHECKSUM" ]]; then
        echo "missing md5 for $REPO/$GROUP/$PACKAGE/$VERSION/$FILE try auto obtain."
        MD5_CHECKSUM=$(curl -sfSL "$REPO/$GROUP/$PACKAGE/$VERSION/$FILE.md5")
    fi

    echo "$MD5_CHECKSUM  $DOWNLOAD_FILE" | md5sum -c -
}

MAVEN_REPO_JITPACK=${MAVEN_REPO_JITPACK:-"https://jitpack.io"}

maven_jitpack_dep() {
    maven_dep $MAVEN_REPO_JITPACK $1 $2 $3 "$2-$3.jar" $4
    mv "$DOWNLOAD_FILE" $MAVEN_DEP_DESTINATION
}

maven_any_dep() {
    maven_dep $1 $2 $3 $4 "$3-$4.jar" $5
    mv "$DOWNLOAD_FILE" $MAVEN_DEP_DESTINATION
}

maven_download() {
    case $1 in
        "central" ) 
            shift
            maven_central_dep ${@}
            ;;
        "confluent" )
            shift
            maven_confluent_dep ${@}
            ;;
        "debezium" )
            shift
            maven_debezium_plugin ${@}
            ;;
        "debezium-additional" )
            shift
            maven_debezium_additional_plugin ${@}
            ;;
        "debezium-optional" )
            shift
            maven_debezium_optional ${@}
            ;;
        "camel-kafka" )
            shift
            maven_camel_kafka ${@}
            ;;
        "apicurio" )
            shift
            maven_apicurio_converter ${@}
            ;;
        "jitpack" )
            shift
            maven_jitpack_dep ${@}
            ;;
        "http*" )
            maven_any_dep ${@}
            ;;
    esac
}

maven_download confluent kafka-connect-json-schema-converter "$CONFLUENT_VERSION"
maven_download confluent kafka-json-schema-serializer "$CONFLUENT_VERSION"
maven_download confluent kafka-json-schema-provider "$CONFLUENT_VERSION"
maven_download jitpack com/github/everit-org/json-schema org.everit.json.schema 1.14.1
maven_download central org/json json 20201115
maven_download central com/fasterxml/jackson/datatype jackson-datatype-guava 2.10.5
maven_download central com/fasterxml/jackson/datatype jackson-datatype-jdk8 2.10.5
maven_download central com/fasterxml/jackson/datatype jackson-datatype-joda 2.10.5
maven_download central joda-time joda-time 2.9.9
maven_download central com/fasterxml/jackson/datatype jackson-datatype-jsr310 2.10.5
maven_download central com/fasterxml/jackson/module jackson-module-parameter-names 2.10.5

maven_download confluent kafka-connect-protobuf-converter "$CONFLUENT_VERSION"
maven_download confluent kafka-protobuf-serializer "$CONFLUENT_VERSION"
maven_download confluent kafka-protobuf-provider "$CONFLUENT_VERSION"
maven_download central com/google/protobuf protobuf-java-util 3.11.4
maven_download central com/google/protobuf protobuf-java 3.11.4
maven_download central com/google/guava guava 30.1.1-jre
maven_download central com/squareup/wire wire-schema 3.6.0
maven_download central com/squareup/wire wire-runtime 3.6.0
maven_download central org/jetbrains/kotlin kotlin-stdlib 1.4.21
maven_download central org/jetbrains/kotlin kotlin-stdlib-common 1.4.21

# change it back
MAVEN_DEP_DESTINATION=$MAVEN_DEP_DESTINATION_BAK
FROM maven:3-openjdk-8 AS kpt-schema-package

COPY --chmod=755 ./cdc-to-rdb/kpt-schema-package $PENTAHO_HOME/kpt-schema-package

WORKDIR /kpt-schema-package

RUN mvn clean package -Dmaven.test.skip=true


FROM xiaoyao9184/kpt-pdi-engine:9.2.0.0-290

LABEL org.opencontainers.image.authors="xiaoyao9184@gmail.com"

ARG KPT_URL="https://github.com/xiaoyao9184/Kettle-Project-Toolbox.git"


# Init KPT workspace and project
COPY --chmod=755 --chown=pentaho:pentaho ./shell $PENTAHO_HOME/shell
COPY --chmod=755 --chown=pentaho:pentaho ./tool $PENTAHO_HOME/tool
COPY --chmod=755 --chown=pentaho:pentaho ./default $PENTAHO_HOME/default
RUN $PENTAHO_HOME/tool/create_project.sh kpt-cdc-to-rdb <&- \
    && cp $PENTAHO_HOME/kpt-cdc-to-rdb/.profile/.profile $PENTAHO_HOME/kpt-cdc-to-rdb/.profile/default.profile \
    && chmod -R 775 $PENTAHO_HOME/kpt-cdc-to-rdb

# Copy core ktr
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/from_canal \
    $PENTAHO_HOME/kpt-cdc-to-rdb/from_canal
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/from_debezium \
    $PENTAHO_HOME/kpt-cdc-to-rdb/from_debezium
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/from_kafka \
    $PENTAHO_HOME/kpt-cdc-to-rdb/from_kafka
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/to_pgsql \
    $PENTAHO_HOME/kpt-cdc-to-rdb/to_pgsql
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/to_rdb \
    $PENTAHO_HOME/kpt-cdc-to-rdb/to_rdb
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/db_kpt_cdc_rdb_writer.kdb \
    $PENTAHO_HOME/kpt-cdc-to-rdb/
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/config.xml \
    $PENTAHO_HOME/kpt-cdc-to-rdb/
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/.kettle/kettle.properties \
    $PENTAHO_HOME/kpt-cdc-to-rdb/.kettle/kettle.properties

# Copy schema registry package
COPY --from=kpt-schema-package /kpt-schema-package/registry-schema-package/target/kpt-registry-schema-package-${PDI_VERSION}-package \
    $PENTAHO_HOME/kpt-cdc-to-rdb/.pdi/lib/kpt-registry-schema-package-${PDI_VERSION}-package

# Copy kafka plugin
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/.kpt/lib/pentaho-big-data-kettle-plugins-kafka-${PDI_VERSION}/pentaho-big-data-kettle-plugins-kafka-${PDI_VERSION}.jar \
    $PENTAHO_HOME/kpt-cdc-to-rdb/.pdi/lib/pentaho-big-data-kettle-plugins-kafka-${PDI_VERSION}/pentaho-big-data-kettle-plugins-kafka-${PDI_VERSION}.jar

# Copy endpoint script
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/docker-entrypoint.sh \
    $PENTAHO_HOME/kpt-cdc-to-rdb/docker-entrypoint.sh

# Goto kpt project path
WORKDIR $PENTAHO_HOME/kpt-cdc-to-rdb

ENTRYPOINT ./docker-entrypoint.sh

VOLUME /home/pentaho/kpt-cdc-to-rdb/log
VOLUME /home/pentaho/kpt-cdc-to-rdb/to_rdb/group_to_table.injection

FROM xiaoyao9184/kpt-pdi-engine:9.1.0.0-324

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
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/from-canal \
    $PENTAHO_HOME/kpt-cdc-to-rdb/from-canal
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/from-debezium \
    $PENTAHO_HOME/kpt-cdc-to-rdb/from-debezium
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/from-kafka \
    $PENTAHO_HOME/kpt-cdc-to-rdb/from-kafka
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/to_pgsql \
    $PENTAHO_HOME/kpt-cdc-to-rdb/to_pgsql
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/to_rdb \
    $PENTAHO_HOME/kpt-cdc-to-rdb/to_rdb
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/db_kpt_cdc_event_pgsql_writer.kdb \
    $PENTAHO_HOME/kpt-cdc-to-rdb/
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/config.xml \
    $PENTAHO_HOME/kpt-cdc-to-rdb/
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/.kettle/kettle.properties \
    $PENTAHO_HOME/kpt-cdc-to-rdb/.kettle/kettle.properties


# Goto kpt project path
WORKDIR $PENTAHO_HOME/kpt-cdc-to-rdb

ENTRYPOINT bash ./kpt.flow.UseProfileConfigRun.sh <&-

VOLUME /home/pentaho/kpt-cdc-to-rdb/log
VOLUME /home/pentaho/kpt-cdc-to-rdb/to_rdb/group_to_table.injection

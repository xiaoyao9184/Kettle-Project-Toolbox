FROM openjdk:8-jre

LABEL org.opencontainers.image.authors="xiaoyao9184@gmail.com"

ARG PDI_URL="https://downloads.sourceforge.net/project"
ARG KPT_URL="https://github.com/xiaoyao9184/Kettle-Project-Toolbox.git"

# Set required environment vars
ENV PDI_RELEASE=9.1 \
    PDI_VERSION=9.1.0.0-324 \
    PENTAHO_HOME=/home/pentaho \
    PDI_PATH=/home/pentaho/data-integration \
    JENKINS_HOME=/home/jenkins

# Create user
RUN mkdir ${PENTAHO_HOME} \
    && groupadd -r pentaho \
    && useradd -s /bin/bash -d ${PENTAHO_HOME} -r -g pentaho pentaho \
    && chown pentaho:pentaho ${PENTAHO_HOME}

# Switch to the pentaho user
USER pentaho

# Download PDI
RUN /usr/bin/wget \
    --progress=dot:giga \
    ${PDI_URL}/pentaho/Pentaho%20${PDI_RELEASE}/client-tools/pdi-ce-${PDI_VERSION}.zip \
    -O /tmp/pdi-ce-${PDI_VERSION}.zip
RUN /usr/bin/unzip -q /tmp/pdi-ce-${PDI_VERSION}.zip -d $PENTAHO_HOME \
    && rm /tmp/pdi-ce-${PDI_VERSION}.zip

# Init KPT project
COPY --chmod=755 --chown=pentaho:pentaho ./tool $PENTAHO_HOME/tool
COPY --chmod=755 --chown=pentaho:pentaho ./default $PENTAHO_HOME/default
RUN $PENTAHO_HOME/tool/INIT_PROJECT.sh kpt-cdc-to-rdb \
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
COPY --chmod=755 --chown=pentaho:pentaho ./cdc-to-rdb/kettle.properties \
    $PENTAHO_HOME/kpt-cdc-to-rdb/.kettle/kettle.properties


# Goto kpt project path
WORKDIR $PENTAHO_HOME/kpt-cdc-to-rdb

# BUG of kettle
# Only use Basic log level, 
# more detailed level of logs will make the results wrong
ENTRYPOINT bash ./flow.UseProfileConfigRun.sh "Basic" "$PROFILE" <&-

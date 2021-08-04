FROM openjdk:8-jre

LABEL org.opencontainers.image.authors="xiaoyao9184@gmail.com"

ARG PDI_URL="https://downloads.sourceforge.net/project"
ARG KPT_URL="https://github.com/xiaoyao9184/Kettle-Project-Toolbox.git"

# Set required environment vars
ENV PDI_RELEASE=9.1 \
    PDI_VERSION=9.1.0.0-324 \
    CARTE_PORT=8181 \
    PENTAHO_JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
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
RUN $PENTAHO_HOME/tool/INIT_PROJECT.sh canal-kafka-to-pgsql \
    && cp $PENTAHO_HOME/canal-kafka-to-pgsql/.profile/.profile $PENTAHO_HOME/canal-kafka-to-pgsql/.profile/default.profile \
    && chmod -R 775 $PENTAHO_HOME/canal-kafka-to-pgsql

# Copy core ktr
COPY --chmod=755 --chown=pentaho:pentaho ./canal-kafka-to-pgsql/mysql-log \
    $PENTAHO_HOME/canal-kafka-to-pgsql/mysql-log
COPY --chmod=755 --chown=pentaho:pentaho ./canal-kafka-to-pgsql/db_kpt_bin_log_pgsql_writer.kdb \
    $PENTAHO_HOME/canal-kafka-to-pgsql/
COPY --chmod=755 --chown=pentaho:pentaho ./canal-kafka-to-pgsql/config.xml \
    $PENTAHO_HOME/canal-kafka-to-pgsql/


# Goto kpt project path
WORKDIR $PENTAHO_HOME/canal-kafka-to-pgsql

ENTRYPOINT bash ./flow.UseProfileConfigRun.sh "Basic" "$PROFILE" <&-

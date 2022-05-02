FROM openjdk:8-jre

LABEL org.opencontainers.image.authors="xiaoyao9184@gmail.com"

ARG PDI_RELEASE="7.1"
ARG PDI_VERSION="7.1.0.0-12"
ARG PDI_URL="https://downloads.sourceforge.net/project/pentaho/Data%20Integration/7.1/pdi-ce-7.1.0.0-12.zip"
    
# Set required environment vars
ENV PENTAHO_HOME=/home/pentaho \
    PDI_RELEASE=${PDI_RELEASE} \
    PDI_VERSION=${PDI_VERSION} \
    PDI_PATH=/home/pentaho/data-integration

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
    ${PDI_URL} \
    -O /tmp/pdi-ce-${PDI_VERSION}.zip \
    && /usr/bin/unzip -q /tmp/pdi-ce-${PDI_VERSION}.zip -d $PENTAHO_HOME \
    && rm /tmp/pdi-ce-${PDI_VERSION}.zip
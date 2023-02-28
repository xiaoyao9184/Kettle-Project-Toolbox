ARG JENKINS_VERSION=2.346.3-jdk8
ARG JENKINS_UC=https://updates.jenkins.io/update-center.actual.json
ARG JENKINS_UC_DOWNLOAD_URL=

FROM jenkins/jenkins:${JENKINS_VERSION}

ENV JENKINS_UC=${JENKINS_UC}
ENV JENKINS_UC_DOWNLOAD_URL=${JENKINS_UC_DOWNLOAD_URL}
 
COPY plugins.yml /usr/share/jenkins/ref/plugins.yml

RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.yml --verbose --latest true

EXPOSE 8080
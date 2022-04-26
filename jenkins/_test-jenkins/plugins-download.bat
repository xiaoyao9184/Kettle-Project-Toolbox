@ECHO OFF
SETLOCAL EnableDelayedExpansion
::CODER BY xiaoyao9184 1.0


:init_variable

::script info
SET current_script_dir=%~dp0

::
SET JENKINS_UC=https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates
SET JENKINS_UC_DOWNLOAD=https://mirrors.tuna.tsinghua.edu.cn/jenkins
@REM SET JENKINS_UC_EXPERIMENTAL=https://mirrors.tuna.tsinghua.edu.cn/jenkins/experimental/update-center.actual.json
@REM SET JENKINS_INCREMENTALS_REPO_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/jenkins/
@REM SET JENKINS_PLUGIN_INFO=https://mirrors.tuna.tsinghua.edu.cn/jenkins/

::default param
SET jenkins_version=2.277.4
SET jar_version=2.5.0
SET jar_dir=%current_script_dir%plugins\jenkins-plugin-manager\
SET jar_path=%jar_dir%jenkins-plugin-manager-%jar_version%.jar
SET jar_url=https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/%jar_version%/jenkins-plugin-manager-%jar_version%.jar

:begin

MKDIR "%jar_dir%"

IF EXIST %jar_path% (
    ECHO jar exists
) ELSE (
    BITSADMIN /transfer DownLoad:jenkins-plugin-manager /dynamic /download /priority FOREGROUND^
    "%jar_url%"^
    "%jar_path%"
)

CD %current_script_dir%
java -jar "%jar_path%"^
 --jenkins-version %jenkins_version%^
 --plugin-file ./plugins.txt^
 --latest false^
 --plugin-download-directory "%current_script_dir%plugins"^
 --verbose
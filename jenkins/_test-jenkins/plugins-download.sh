#!/bin/bash
# CODER BY xiaoyao9184 1.0


#####init_variable

# script info
current_script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# 
export JENKINS_UC=https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates
export JENKINS_UC_DOWNLOAD=https://mirrors.tuna.tsinghua.edu.cn/jenkins
# export JENKINS_UC_EXPERIMENTAL=https://mirrors.tuna.tsinghua.edu.cn/jenkins/experimental/update-center.actual.json
# export JENKINS_INCREMENTALS_REPO_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/jenkins/
# export JENKINS_PLUGIN_INFO=https://mirrors.tuna.tsinghua.edu.cn/jenkins/

# default param
jenkins_version="2.277.4"
jar_version="2.5.0"
jar_dir="${current_script_path}/plugins/jenkins-plugin-manager"
jar_path="${jar_dir}/jenkins-plugin-manager-$jar_version.jar"
jar_url="https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/$jar_version/jenkins-plugin-manager-$jar_version.jar"

#####begin

mkdir -p "$jar_dir"

if [[ -f "$jar_path" ]]; then
    echo "jar exists"
else
    curl -L -o "$jar_path" "$jar_url"
fi

cd "$current_script_path"
java -jar "$jar_path" \
 --jenkins-version "$jenkins_version" \
 --plugin-file ./plugins.txt \
 --latest false \
 --plugin-download-directory "$current_script_path/plugins" \
 --verbose
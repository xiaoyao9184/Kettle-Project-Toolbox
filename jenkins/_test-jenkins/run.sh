#!/bin/bash
# CODER BY xiaoyao9184 1.0

current_script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

bash $current_script_path/plugins-volume.sh
bash $current_script_path/home-volume.sh

docker-compose -p test-jenkins-kpt up
#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2022-05-06
# FILE KPT_RUN_BY_REP


#####init_variable

# script info
current_script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# default param
[[ -z "$KPT_CALLER_SCRIPT_PATH" ]] && KPT_CALLER_SCRIPT_PATH=$(realpath "${BASH_SOURCE[0]}")
[[ -z "$KPT_MODE" ]] && KPT_MODE="rep"


#####begin

source "$current_script_path/KPT_RUN_COMMAND.sh"


#####end

current_script_name="$(basename "$(test -L "${BASH_SOURCE[0]}" && readlink "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}")")"
current_script_name="${current_script_name%.*}"
echo pause by $current_script_name
read -n1 -r -p "Press any key to continue..." key
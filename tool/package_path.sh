#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2022-04-26
# FILE package_path
# DESC package path
# SYNTAX package_path [source_path [kpt_workspace_path [pdi_engine_path]]]


#####init_variable

tip="Kettle-Project-Toolbox: package home"
ver="1.0"

# here interactive mean user input can be obtained,
# determined by checking is connected to a terminal
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0
[[ -n "$JENKINS_HOME" ]] && interactive=0
[[ -n "$DEBUG" ]] && interactive=0
[[ -n "$KPT_QUIET" ]] && interactive=0

# script info
current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"
parent_folder_dir="$(dirname $current_script_dir)"

# tip info
tip_source_path_input="Need input 'source_path' or drag path in:"
tip_source_path_miss="Missing param 'source_path' at position 1."
tip_source_path_wrong="Wrong param 'source_path' at position 1."
tip_kpt_workspace_path_input="Need input 'kpt_workspace_path' or drag path in:"
tip_kpt_workspace_path_miss="Missing param 'kpt_workspace_path' at position 2."
tip_kpt_workspace_path_wrong="Wrong param 'kpt_workspace_path' at position 2."
tip_pdi_engine_path_input="Need input 'pdi_engine_path' or drag path in:"
tip_pdi_engine_path_miss="Missing param 'pdi_engine_path' at position 3."
tip_pdi_engine_path_wrong="Wrong param 'pdi_engine_path' at position 3."

# defult param
source_path=$1
kpt_workspace_path=$2
pdi_engine_path=$3
open_project_path=


#####tip_version

[[ $interactive -eq 1 ]] && echo -e '\033]2;'$tip $ver'\007' || echo "$tip"


#####check_variable

while [[ -z "$kpt_workspace_path" ]]; do
    # auto discover pdi
    if [[ -f "$parent_folder_dir/data-integration/spoon.sh" ]]; then
        kpt_workspace_path="$parent_folder_dir"
        continue
    fi
    if [[ $interactive -eq 1 ]]; then
        read -p "$tip_kpt_workspace_path_input" kpt_workspace_path
    else
        echo "$tip_kpt_workspace_path_miss"
        exit 1
    fi
done
while [[ ! -d "$kpt_workspace_path" ]]; do
    if [[ $interactive -eq 1 ]]; then
        echo "not exist $kpt_workspace_path"
        read -p "$tip_kpt_workspace_path_input" kpt_workspace_path
    else
        echo "$tip_kpt_workspace_path_wrong"
        exit 1
    fi
done

while [[ -z "$source_path" ]]; do
    if [[ $interactive -eq 1 ]]; then
        read -p "$tip_source_path_input" source_path
    else
        echo "$tip_source_path_miss"
        exit 1
    fi
done
while [[ -f "$source_path" ]]; do
    if [[ $interactive -eq 1 ]]; then
        echo "exist $source_path"
        read -p "$tip_source_path_input" source_path
    else
        echo "$tip_source_path_wrong"
        exit 1
    fi
done

while [[ -z "$pdi_engine_path" ]]; do
    # auto discover pdi
    if [[ -f "$parent_folder_dir/data-integration/spoon.sh" ]]; then
        pdi_engine_path="$parent_folder_dir/data-integration"
        continue
    fi
    if [[ $interactive -eq 1 ]]; then
        read -p "$tip_pdi_engine_path_input" pdi_engine_path
    else
        echo "$tip_pdi_engine_path_miss"
        exit 1
    fi
done
while [[ ! -f "$pdi_engine_path/spoon.sh" ]]; do
    if [[ $interactive -eq 1 ]]; then
        echo "wrong path $pdi_engine_path"
        read -p "$tip_pdi_engine_path_input" pdi_engine_path
    else
        echo "$tip_pdi_engine_path_wrong"
        exit 1
    fi
done

if [[ $interactive -eq 1 ]]; then
    open_project_path="xdg-open"
fi


#####begin

export KPT_COMMAND="kitchen"
export KPT_ENGINE_PATH="$pdi_engine_path"
export KPT_KETTLE_FILE="$current_script_dir/Deploy/PackageZipDeploy4Path.kjb"
export KPT_KETTLE_PARAM_srcPath="$source_path"
export KPT_KETTLE_PARAM_oCommand="$open_project_path"
export KPT_KETTLE_PARAM_fExcludeRegex=".*\.backup$|.*\.log$|.*\.git\\\\.*|.*\.git\/.*|.*db\.cache.*|.*data-integration.*"
export KPT_KETTLE_PARAM_fIncludeRegex=".*"

bash "$kpt_workspace_path/shell/KPT_RUN_COMMAND.sh"
_result_code=$?

export KPT_COMMAND=""
export KPT_ENGINE_PATH=""
export KPT_KETTLE_FILE=""
export KPT_KETTLE_PARAM_srcPath=""
export KPT_KETTLE_PARAM_oCommand=""
export KPT_KETTLE_PARAM_fExcludeRegex=""
export KPT_KETTLE_PARAM_fIncludeRegex=""

#####end

[[ $interactive -eq 1 ]] && read -p "Press enter to continue"
exit $_result_code

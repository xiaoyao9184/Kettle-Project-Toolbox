#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2022-04-26
# FILE package_project
# DESC package project in kpt workspace
# SYNTAX package_home [kpt_project_name [kpt_workspace_path [pdi_engine_path]]]


#####init_variable

tip="Kettle-Project-Toolbox: package home"
ver="1.0"

# here interactive mean user input can be obtained, 
# determined by checking is connected to a terminal 
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0

# script info
current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"

# tip info
tip_kpt_project_name_input="Need input 'kpt_project_name':"
tip_kpt_project_name_miss="Missing param 'kpt_project_name' at position 1."
tip_kpt_project_name_wrong="Wrong param 'kpt_project_name' at position 1."
tip_kpt_workspace_path_input="Need input 'kpt_workspace_path' or drag path in:"
tip_kpt_workspace_path_miss="Missing param 'kpt_workspace_path' at position 2."
tip_kpt_workspace_path_wrong="Wrong param 'kpt_workspace_path' at position 2."
tip_pdi_engine_path_input="Need input 'pdi_engine_path' or drag path in:"
tip_pdi_engine_path_miss="Missing param 'pdi_engine_path' at position 3."
tip_pdi_engine_path_wrong="Wrong param 'pdi_engine_path' at position 3."

# defult param
kpt_project_name=$1
kpt_workspace_path=$2
pdi_engine_path=$3
open_project_path=


#####tip_version

[ $interactive -eq 1 ] && echo -e '\033]2;'$tip $ver'\007' || echo "$tip"


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
while [[ ! -d "$kpt_workspace_path" ]]; then
    if [[ $interactive -eq 1 ]]; then 
        echo "not exist $kpt_workspace_path"
        read -p "$tip_kpt_workspace_path_input" kpt_workspace_path
    else
        echo "$tip_kpt_workspace_path_wrong"
        exit 1
    fi
fi

while [[ -z "$kpt_project_name" ]]; do
    if [[ $interactive -eq 1 ]]; then 
        read -p "$tip_kpt_project_name_input" kpt_project_name
	else 
        echo "$tip_kpt_project_name_miss"
        exit 1
    fi
done
while [[ -f "$kpt_workspace_path/$kpt_project_name" ]]; then
    if [[ $interactive -eq 1 ]]; then 
        echo "exist $kpt_workspace_path/$kpt_project_name"
        read -p "$tip_kpt_project_name_input" kpt_project_name
    else
        echo "$tip_kpt_project_name_wrong"
        exit 1
    fi
fi

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
while [[ ! -f "$pdi_engine_path/spoon.sh" ]]; then
    if [[ $interactive -eq 1 ]]; then 
        echo "wrong path $pdi_engine_path"
        read -p "$tip_pdi_engine_path_input" pdi_engine_path
    else
        echo "$tip_pdi_engine_path_wrong"
        exit 1
    fi
fi

if [[ $interactive -eq 1 ]]; then 
    open_project_path="true"
else
    open_project_path="false"
fi


#####begin

export KPT_COMMAND="kitchen"
export KPT_ENGINE_PATH="$pdi_engine_path"
export KPT_KETTLE_FILE="$current_script_dir/Deploy/PackageZipDeploy4FileRepositoryPath.kjb"
export KPT_KETTLE_PARAM_rNameRegex="$kpt_project_name"
export KPT_KETTLE_PARAM_isOpenShell="$open_project_path"
export KPT_KETTLE_PARAM_fExcludeRegex=".*\.backup$|.*\.log$|.*\.git\\.*|.*db\.cache.*|.*data-integration.*"
export KPT_KETTLE_PARAM_fIncludeRegex=".*"

bash "$parent_folder_dir/shell/KPT_RUN_COMMAND.sh"
_result_code=$?

export KPT_COMMAND=""
export KPT_ENGINE_PATH=""
export KPT_KETTLE_FILE=""
export KPT_KETTLE_PARAM_rNameRegex=""
export KPT_KETTLE_PARAM_isOpenShell=""
export KPT_KETTLE_PARAM_fExcludeRegex=""
export KPT_KETTLE_PARAM_fIncludeRegex=""

#####end

[[ $interactive -eq 1 ]] && read -p "Press enter to continue"
exit $_result_code

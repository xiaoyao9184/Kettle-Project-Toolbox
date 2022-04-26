#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-31
# FILE INIT_WORKSPACE
# DESC create a workspace for Kettle-Project-Toolbox using LINK_FOLDER
# SYNTAX INIT_WORKSPACE [kpt_workspace_path [pdi_engine_path [kpt_repository_path]]]


#####init_variable

tip="Kettle-Project-Toolbox: init workspace"
ver="1.0"

# here interactive mean user input can be obtained, 
# determined by checking is connected to a terminal 
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0

# script info
current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"

# tip info
tip_kpt_workspace_path_input="Need input 'kpt_workspace_path' or drag path in:"
tip_kpt_workspace_path_miss="Missing param 'kpt_workspace_path' at position 1."
tip_pdi_engine_path_input="Need input 'pdi_engine_path' or drag path in:"
tip_pdi_engine_path_miss="Missing param 'pdi_engine_path' at position 2."
tip_pdi_engine_path_wrong="Wrong param 'pdi_engine_path' at position 2."
tip_kpt_repository_path_input="Need input 'kpt_repository_path' or drag path in:"
tip_kpt_repository_path_miss="Missing param 'kpt_repository_path' at position 3."
tip_kpt_workspace_exist_strategy="KPT workspace exist strategy: replac of exist symbolic link directory"

# defult param
kpt_workspace_path=$1
pdi_engine_path=$2
kpt_repository_path="$parent_path"
default_link_path_list="tool;shell;default"


#####tip_version

[ $interactive -eq 1 ] && echo -e '\033]2;'$tip $ver'\007' || echo "$tip"


#####check_variable

while [[ -z "$kpt_workspace_path" ]]; do
    if [[ $interactive -eq 1 ]]; then 
        read -p "$tip_kpt_workspace_path_input" kpt_workspace_path
	else 
        echo "$tip_kpt_workspace_path_miss"
        exit 1
    fi
done

while [[ -z "$pdi_engine_path" ]]; do
    if [[ $interactive -eq 1]]; then
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

while [[ -z $kpt_repository_path ]]; do
    # auto discover kpt
	if [[ -d "$parent_folder_dir/.git" ]]; then
		kpt_repository_path="$parent_folder_dir"
        continue
	fi
    if [[ $interactive -eq 1]]; then
        read -p "$tip_kpt_repository_path_input" kpt_repository_path
    else
        echo "$tip_kpt_repository_path_miss"
        exit 1
    fi
done

IFS=';' read -r -a default_link_path_list <<< "$default_link_path_list"; unset IFS;


#####begin

# print info
echo "==========$current_script_name=========="
echo "Script directory is: $current_script_dir"
echo "Kettle engine path is: $pdi_engine_path"
echo "KPT workspace path is: $kpt_workspace_path"
echo "KPT repository path is: $kpt_repository_path"
echo "KPT link path list is: ${default_link_path_list[@]}"
echo "-----------------NOTE--------------------"
echo "kettle engine not support symbolic link with directory, will get the wrong path;"
echo "use 'copy_link' for Kettle engine path, copy folder and hard link file."
echo "use 'symbolic' for KPT repository path."
echo "----------$current_script_name----------"

# create workspace
if [[ ! -d "$kpt_workspace_path" ]]; then
	echo "create directory for not exist $kpt_workspace_path"
	mkdir "$kpt_workspace_path"
fi

# create param
if [[ $interactive -eq 1]]; then
    echo
else
    echo "$tip_kpt_workspace_exist_strategy"
    exist_strategy="replace"
fi

_result_code=0

# link kpt source path
for link_name in "${default_link_path_list[@]}"; do
	_step="Step: link '$link_name'"
	echo
	echo
	echo "==========$_step=========="
    bash "$current_script_dir/LINK_FOLDER.sh" "$kpt_workspace_path/$link_name" "$kpt_repository_path/$link_name" "symbolic" "$exist_strategy"
    [[ $? -ne 0 ]] || _result_code=1
	echo "##########$_step##########"
done

# link pdi engine path
_step="Step: link PDI engine path"
echo
echo
echo "==========$_step=========="
bash "$current_script_dir/LINK_FOLDER.sh" "$kpt_workspace_path/data-integration" "$pdi_engine_path" "copy_link" "$exist_strategy"
[[ $? -ne 0 ]] || _result_code=1
echo "##########$_step##########"

# done command
if [[ $_result_code -eq 0 ]]
then
    echo "Ok, run done!"
else
    echo "Sorry, some error '$_result_code' make failure!"
fi
echo "##########$current_script_name##########"


#####end

if [[ $interactive -eq 1 ]]
then
    read -p "Press enter to continue"
    exit $_result_code
else
    exit $_result_code
fi

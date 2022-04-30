#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2022-04-25
# FILE link_project
# DESC create a project and link to KPT source code
# SYNTAX link_project [kpt_project_name [kpt_workspace_path [pdi_engine_path [target_project_path [link_item_name_list [copy_item_name_list]]]]]]
# SYNTAX_DESC target_project_path: project path for link to
# SYNTAX link_item_name_list: name[;name]...
# SYNTAX copy_item_name_list: name[;name]...


#####init_variable

tip="Kettle-Project-Toolbox: link project"
ver="1.0"

# here interactive mean user input can be obtained,
# determined by checking is connected to a terminal
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0

# script info
current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"
parent_folder_dir="$(dirname $current_script_dir)"

# tip info
tip_kpt_project_name_input="Need input 'kpt_project_name' or drag path in:"
tip_kpt_project_name_miss="Missing param 'kpt_project_name' at position 1."
tip_kpt_project_name_wrong="Wrong param 'kpt_project_name' at position 1."
tip_kpt_workspace_path_input="Need input 'kpt_workspace_path' or drag path in:"
tip_kpt_workspace_path_miss="Missing param 'kpt_workspace_path' at position 2."
tip_kpt_workspace_path_wrong="Wrong param 'kpt_workspace_path' at position 2."
tip_pdi_engine_path_input="Need input 'pdi_engine_path' or drag path in:"
tip_pdi_engine_path_miss="Missing param 'pdi_engine_path' at position 3."
tip_pdi_engine_path_wrong="Wrong param 'pdi_engine_path' at position 3."
tip_target_project_path_input="Need input 'target_project_path' or drag path in:"
tip_target_project_path_miss="Missing param 'target_project_path' at position 4."
tip_target_project_path_wrong="Wrong param 'target_project_path' at position 4."
tip_link_item_name_input_first="Please input 'link_item_name' or use default[all folder] with empty input:"
tip_link_item_name_input_again="Again input 'link_item_name' or end with empty input:"
tip_link_item_name_miss="Missing param 'link_item_name' at position 5."
tip_copy_item_name_input_first="Please input 'copy_item_name' or use default[all file] with empty input:"
tip_copy_item_name_input_again="Again input 'copy_item_name' or end with empty input:"
tip_copy_item_name_miss="Missing param 'copy_item_name' at position 6."

# defult param
kpt_project_name=$kpt_project_name
kpt_workspace_path=$kpt_workspace_path
pdi_engine_path=$pdi_engine_path
target_project_path=$target_project_path
link_item_name_list=$link_item_name_list
copy_item_name_list=$copy_item_name_list
[[ ! -z "$1" ]] && kpt_project_name=$1
[[ ! -z "$2" ]] && kpt_workspace_path=$2
[[ ! -z "$3" ]] && pdi_engine_path=$3
[[ ! -z "$4" ]] && target_project_path=$4
[[ ! -z "$5" ]] && link_item_name_list=$5
[[ ! -z "$6" ]] && copy_item_name_list=$6
input_list=


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

while [[ -z "$kpt_project_name" ]]; do
    if [[ $interactive -eq 1 ]]; then
        read -p "$tip_kpt_project_name_input" kpt_project_name
    else
        echo "$tip_kpt_project_name_miss"
        exit 1
    fi
done

while [[ -z "$pdi_engine_path" ]]; do
    # auto discover pdi
    if [[ -f "$kpt_workspace_path/data-integration/spoon.sh" ]]; then
        pdi_engine_path="$kpt_workspace_path/data-integration"
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

while [[ -z "$target_project_path" ]]; do
    if [[ $interactive -eq 1 ]]; then
        read -p "$tip_target_project_path_input" target_project_path
    else
        echo "$tip_target_project_path_miss"
        exit 1
    fi
done
while [[ ! -d "$target_project_path" ]]; do
    if [[ $interactive -eq 1 ]]; then
        echo "not exist $target_project_path"
        read -p "$tip_target_project_path_input" target_project_path
    else
        echo "$tip_target_project_path_wrong"
        exit 1
    fi
done

delimiter=";"
input_list=
while [[ -z $link_item_name_list ]]; do
    if [[ $interactive -eq 1 ]]; then
        # tip item name for input
        ls -p $target_project_path
        read -p "$tip_link_item_name_input_first" input_item
        if [[ -z "$input_item" ]]; then
            if [[ -z "$input_list" ]]; then
                # default use all folder
                folder_list=( $( ls -p $target_project_path | grep / ) )
                link_item_name_list=$(IFS=';' ; echo "${folder_list[*]}")
            else
                # input param end
                link_item_name_list=$input_list
            fi
        else
            [[ -z $input_list ]] && delimiter=
            input_list="$input_list$delimiter$input_item"
            tip_link_item_name_input_first=$tip_link_item_name_input_again
        fi
    else
        echo $tip_link_item_name_miss
        exit 1
    fi
done

delimiter=";"
input_list=
while [[ -z $copy_item_name_list ]]; do
    if [[ $interactive -eq 1 ]]; then
        # tip item name for input
        ls -p $target_project_path
        read -p "$tip_copy_item_name_input_first" input_item
        if [[ -z $input_item ]]; then
            if [[ -z $input_list ]]; then
                # default use all file
                file_list=( $( ls -p $target_project_path | grep -v / ) )
                copy_item_name_list=$(IFS=';' ; echo "${file_list[*]}")
            else
                # input param end
                copy_item_name_list=$input_list
            fi
        else
            [[ -z $input_list ]] && delimiter=
            input_list="$input_list$delimiter$input_item"
            tip_copy_item_name_input_first=$tip_copy_item_name_input_again
        fi
    else
        echo $tip_copy_item_name_miss
        exit 1
    fi
done


#####begin

# print info
echo "==========$current_script_name=========="
echo "Script directory is: $current_script_dir"
echo "Kettle engine path is: $pdi_engine_path"
echo "KPT workspace path is: $kpt_workspace_path"
echo "KPT project name is: $kpt_project_name"
echo "Target project name is: $target_project_path"
echo "Target project sub item link list is: ${link_item_name_list[@]}"
echo "Target project sub item copy list is: ${copy_item_name_list[@]}"
echo "__________$current_script_name__________"

_result_code=0

# create project
_step="Step: create project '$kpt_project_name'"
echo ""
echo ""
echo "==========$_step=========="
bash "$kpt_workspace_path/tool/create_project.sh" "$kpt_project_name" "$kpt_workspace_path" "$pdi_engine_path"
[[ $? -ne 0 ]] && _result_code=1
echo "##########$_step##########"

# link project
_step="Step: link project '$kpt_project_name'"
echo ""
echo ""
echo "==========$_step=========="
export link_project_path="$kpt_workspace_path/$kpt_project_name"
export target_project_path="$target_project_path"
export link_item_name_list="$link_item_name_list"
export copy_item_name_list="$copy_item_name_list"
bash "$kpt_workspace_path/shell/LINK_PROJECT.sh"
[[ $? -ne 0 ]] && _result_code=1
echo "##########$_step##########"

# done command
if [[ "$_result_code" -eq "0" ]]; then
    echo "Ok, run done!"
else
    echo "Sorry, some error '$_result_code' make failure!"
fi
echo "##########$current_script_name##########"


#####end

if [[ $interactive -eq 1 ]]; then
    read -p "Press enter to continue"
    exit $_result_code
else
    exit $_result_code
fi
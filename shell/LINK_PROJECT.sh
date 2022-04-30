#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2022-04-29
# FILE LINK_PROJECT
# DESC create some link to sub item of project
# SYNTAX LINK_PROJECT [link_project_path [target_project_path [link_item_name_list [copy_item_name_list]]]]
# SYNTAX link_item_name_list: name[;name]...
# SYNTAX copy_item_name_list: name[;name]...


#####init_variable

tip="Kettle-Project-Toolbox: link project with symbolic"
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
tip_link_project_path_input="Need input 'link_project_path' or drag path in:"
tip_link_project_path_miss="Missing param 'link_project_path' at position 1."
tip_link_project_path_wrong="Wrong param 'link_project_path' at position 1."
tip_target_project_path_input="Need input 'target_project_path' or drag path in:"
tip_target_project_path_miss="Missing param 'target_project_path' at position 2."
tip_target_project_path_wrong="Wrong param 'target_project_path' at position 2."
tip_link_item_name_input_first="Please input 'link_item_name' or use default[all folder] with empty input:"
tip_link_item_name_input_again="Again input 'link_item_name' or end with empty input:"
tip_link_item_name_miss="Missing param 'target_project_path' at position 3."
tip_copy_item_name_input_first="Please input 'copy_item_name' or use default[all file] with empty input:"
tip_copy_item_name_input_again="Again input 'copy_item_name' or end with empty input:"
tip_copy_item_name_miss="Missing param 'copy_item_name' at position 4."
tip_link_strategy="If target item exist will force replace"

# defult param
link_project_path=$link_project_path
target_project_path=$target_project_path
link_item_name_list=$link_item_name_list
copy_item_name_list=$copy_item_name_list
[[ ! -z "$1" ]] && link_project_path=$1
[[ ! -z "$2" ]] && target_project_path=$2
[[ ! -z "$3" ]] && link_item_name_list=$3
[[ ! -z "$4" ]] && copy_item_name_list=$4
input_list=


#####tip_version

[[ $interactive -eq 1 ]] && echo -e '\033]2;'$tip $ver'\007' || echo "$tip"


#####check_variable

while [[ -z "$link_project_path" ]]; do
    if [[ $interactive -eq 1 ]]; then
        read -p "$tip_link_project_path_input" link_project_path
    else
        echo "$tip_link_project_path_miss"
        exit 1
    fi
done
while [[ ! -d "$link_project_path" ]]; do
    if [[ $interactive -eq 1 ]]; then
        echo "not exist $link_project_path"
        read -p "$tip_link_project_path_input" link_project_path
    else
        echo "$tip_link_project_path_wrong"
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
IFS=';' read -r -a link_item_name_list <<< "$link_item_name_list"; unset IFS;

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
IFS=';' read -r -a copy_item_name_list <<< "$copy_item_name_list"; unset IFS;


#####begin

# print info
echo "==========$current_script_name=========="
echo "Script directory is: $current_script_dir"
echo "Link project path is: $link_project_path"
echo "Target project name is: $target_project_path"
echo "Target project sub item link list is: ${link_item_name_list[@]}"
echo "Target project sub item copy list is: ${copy_item_name_list[@]}"
echo "-----------------NOTE--------------------"
echo "use 'symbolic' for all folder."
echo "__________$current_script_name__________"

_result_code=0

# create link_strategy
if [[ $interactive -eq 1 ]]; then
    echo
else
    echo "$tip_link_strategy"
    link_strategy="replace"
fi

# link item
for link_name in "${link_item_name_list[@]}"; do
    link_name="${link_name%/}"
    link_path="$link_project_path/$link_name"
    target_path="$target_project_path/$link_name"
   
    _step="Step: link item '$link_name'"
    echo
    echo
    echo "==========$_step=========="
    bash "$current_script_dir/LINK_FOLDER.sh" "$link_path" "$target_path" "symbolic" "$link_strategy"
    [[ $? -ne 0 ]] && _result_code=1
    echo "##########$_step##########"
done

# copy item
for copy_name in "${copy_item_name_list[@]}"; do
    copy_path="$link_project_path/$copy_name"
    target_path="$target_project_path/$copy_name"
   
    _step="Step: copy item '$copy_name'"
    echo
    echo
    echo "==========$_step=========="
    if [[ -d "$target_path" ]]; then
        cp -a "$target_path" "$copy_path"
    else
        cp "$target_path" "$copy_path"
    fi
    [[ $? -ne 0 ]] && _result_code=1
    echo "##########$_step##########"
done


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
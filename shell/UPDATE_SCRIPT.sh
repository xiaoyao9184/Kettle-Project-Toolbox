#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2021-04-16
# FILE UPDATE_SCRIPT
# SYNTAX UPDATE_SCRIPT [target_path [source_path]]
# SYNTAX target_path: path[;path]...
# SYNTAX source_path: path[;path]...


#####init_variable

# version
tip="Kettle-Project-Toolbox: update script"
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

# interactive tip
tip_target_path_input_first="Please input target_path or drag path in[empty is ../default]:"
tip_target_path_input_again="Again input target_path or drag path in[empty end]:"
tip_target_path_miss="Missing param 'target_path' at position 1."
tip_source_path_input_first="Please input source_path or drag path in[empty is ../shell]:"
tip_source_path_input_again="Again input source_path or drag path in[empty end]:"
tip_source_path_miss="Missing param 'source_path' at position 1."

# default param
target_path_list=$1
target_path_list=$2
default_target_path_list=$(realpath "$current_script_dir/../default")
default_source_path_list=$(realpath "$current_script_dir/../shell")


#####tip_version

[[ $interactive -eq 1 ]] && echo -e '\033]2;'$tip $ver'\007' || echo "$tip"


#####check_variable

delimiter=";"
input_list=
while [[ -z $target_path_list ]]; do
    if [[ $interactive -eq 1 ]]; then
        read -p "$tip_target_path_input_first" input_item
        if [[ -z $input_item ]]; then
            if [[ -z $input_list ]]; then
                #  default param use 'default_target_path_list'
                target_path_list=$default_target_path_list
            else
                # input param end
                target_path_list=$input_list
            fi
        else
            [[ -z $input_list ]] && delimiter=
            input_item=$( realpath "${input_item//\'/}")
            input_list="$input_list$delimiter$input_item"
            tip_target_path_input_first=$tip_target_path_input_again
        fi
    else
        echo $tip_target_path_miss
        exit 1
    fi
done
IFS=';' read -r -a target_path_list <<< "$target_path_list"; unset IFS;

delimiter=";"
input_list=
while [[ -z $source_path_list ]]; do
    if [[ $interactive -eq 1 ]]; then
        read -p "$tip_source_path_input_first" input_item
        if [[ -z $input_item ]]; then
            if [[ -z $input_list ]]; then
                #  default param use 'default_source_path_list'
                source_path_list=$default_source_path_list
            else
                # input param end
                source_path_list=$input_list
            fi
        else
            [[ -z $input_list ]] && delimiter=
            input_item=$( realpath "${input_item//\'/}")
            input_list="$input_list$delimiter$input_item"
            tip_source_path_input_first=$tip_source_path_input_again
        fi
    else
        echo $tip_source_path_miss
        exit 1
    fi
done
IFS=';' read -r -a source_path_list <<< "$source_path_list"; unset IFS;


#####begin

# print info
echo "==========$current_script_name=========="
echo "Work directory is: $current_script_dir"
echo "Target directory is: ${target_path_list[@]}"
echo "Source directory is: ${source_path_list[@]}"
echo "----------$current_script_name----------"

_result_code=0

for target_path in "${target_path_list[@]}"; do
    # bat
    FILES="$target_path/*.bat"
    for f in $FILES; do
        target_file_path="$f"
        line=$(grep '::FILE' $target_file_path)
        list=($line)
        # https://stackoverflow.com/questions/44945089/echo-printing-variables-in-a-completely-wrong-order
        source_file_name=$(echo "${list[1]}" | tr -d '\r')
        source_file_name="$source_file_name.bat"
        for source_path in "${source_path_list[@]}"; do
            source_file_path="$source_path/$source_file_name"
            if [[ -f "$source_file_path" ]]; then
                echo "$target_file_path <- $source_file_path"
                cp -f $source_file_path $target_file_path
                [[ $? -ne 0 ]] && _result_code=1
            fi
        done
    done

    # sh
    FILES="$target_path/*.sh"
    for f in $FILES; do
        target_file_path="$f"
        line=$(grep '# FILE' $target_file_path)
        list=($line)
        source_file_name="${list[2]}.sh"
        for source_path in "${source_path_list[@]}"; do
            source_file_path="$source_path/$source_file_name"
            if [[ -f "$source_file_path" ]]; then
                echo "$target_file_path <- $source_file_path"
                cp -f $source_file_path $target_file_path
                [[ $? -ne 0 ]] && _result_code=1
            fi
        done
    done
done

# done command
if [[ $_result_code -eq 0 ]]; then
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

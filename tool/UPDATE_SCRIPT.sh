#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2021-04-16
# FILE UPDATE_SCRIPT
# SYNTAX UPDATE_SCRIPT [target_path [source_path]... ]


#init_variable

# version
tip="Kettle-Project-Toolbox: update script"
ver="1.0"

# here interactive mean user input can be obtained, 
# determined by checking is connected to a terminal 
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0

# script info
current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# interactive tip
tip_set_target_path="Please input target_path or drag path in[empty is ../default]:"
tip_miss_target_path="Missing param 'target_path' at position 1."
tip_set_source_path="Please input source_path or drag path in[empty is ../Window and ../Linux]:"
tip_miss_source_path="Missing param 'source_path' at position 1."

# default param
target_path=$1
source_path=


#tip_version

[ $interactive -eq 1 ] && echo -e '\033]2;'$tip $ver'\007' || echo "$tip"


#check_variable

while [[ -z $target_path ]]
do
    if [[ $interactive -eq 1 ]]
    then 
        read -p "$tip_set_target_path" target_path
        [[ -z $target_path ]] && target_path=$( realpath "$current_script_dir/../default")
    else 
        echo $tip_miss_target_path
        exit 1
    fi
done

shift
source_path="$@"
while [[ -z "$source_path" ]]
do
    if [[ $interactive -eq 1 ]]
    then 
        read -p "$tip_set_source_path" source_path
        if [[ -z $source_path ]]
        then
            source_windows=$( realpath "$current_script_dir/../Windows" )
            source_linux=$( realpath "$current_script_dir/../Linux" )
            source_path="$source_windows $source_linux"
        fi
    else 
        echo $tip_miss_source_path
        exit 1
    fi
done
IFS=' ' read -r -a source_path <<< "$source_path"; unset IFS;


#begin

# print info for debug
echo "==========================================================="
echo "Work directory is: $current_script_dir"
echo "Target directory is: $target_path"
echo "Source directory is: ${source_path[@]}"
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# change to script directory
cd $current_script_dir

# bat
FILES="$target_path/*.bat"
for f in $FILES
do
    target_file_path="$f"
    line=$(grep '::FILE' $target_file_path)
    list=($line)
    # https://stackoverflow.com/questions/44945089/echo-printing-variables-in-a-completely-wrong-order
    source_file_name=$(echo "${list[1]}" | tr -d '\r')
    source_file_name="$source_file_name.bat"
    for s in "${source_path[@]}"
    do
        source_dir="$s"
        source_file_path="$source_dir/$source_file_name"
        if [[ -f "$source_file_path" ]]
        then
            echo "$target_file_path <- $source_file_path"
            cp -f $source_file_path $target_file_path
        fi
    done
done

# sh
FILES="$target_path/*.sh"
for f in $FILES
do
    target_file_path="$f"
    line=$(grep '# FILE' $target_file_path)
    list=($line)
    source_file_name="${list[2]}.sh"
    for s in "${source_path[@]}"
    do
        source_dir="$s"
        source_file_path="$source_dir/$source_file_name"
        if [[ -f "$source_file_path" ]]
        then
            echo "$target_file_path <- $source_file_path"
            cp -f $source_file_path $target_file_path
        fi
    done
done


#done

code=$?
if [[ "$code" -eq "0" ]]
then
    echo "Ok, run done!"
else
    echo "Sorry, some error make failure!"
fi


#end

if [[ $interactive -eq 1 ]]
then
    read -p "Press enter to continue"
    exit $code
else
    exit $code
fi

#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-29
# FILE LINK_FOLDER
# DESC create a symbolic link for directory
# SYNTAX LINK_FOLDER [link_path [target_path [link_type [exist_strategy]]]]
# SYNTAX link_type: symbolic | hard | copy_link
# SYNTAX exist_strategy: remove | replace | none | ...


#####init_variable

tip="Kettle-Project-Toolbox: Link directory"
ver="1.0"

# here interactive mean user input can be obtained, 
# determined by checking is connected to a terminal 
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0

# script info
current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"

# tip info
tip_link_path_input="Need input 'link_path' or drag path in:"
tip_link_path_miss="Missing param 'link_path' at position 1."
tip_target_path_input="Need input 'target_path' or drag path in:"
tip_target_path_miss="Missing param 'target_path' at position 2."
tip_target_path_wrong="Wrong param 'target_path' at position 2."
tip_exist_symbolic_link="Already exists symbolic link of link_path!"
tip_exist_normal_path="Already exists normal path of link_path!"
tip_exist_strategy_choice="[D]ele, [R]eplace or [N]othing to do?(default after 10 seconds)"
tip_exist_strategy_miss="Missing param 'exist_strategy' at position 3."
tip_exist_symbolic_remove="Remove exist symbolic link"
tip_exist_normal_remove="Remove exist directory"
tip_exist_none="Nothing to do with exist"
tip_none="Nothing to do"

# defult param
link_path=$1
target_path=$2
link_type=$3
exist_strategy=$4
exist_type=not


#####tip_version

[ $interactive -eq 1 ] && echo -e '\033]2;'$tip $ver'\007' || echo "$tip"


#####check_variable

while [[ -z "$link_path" ]]; do
    if [[ $interactive -eq 1 ]]; then 
        read -p "$tip_link_path_input" link_path
    else
        echo "$tip_link_path_miss"
        exit 1
    fi
done

while [[ -z "$target_path" ]]; do
    if [[ $interactive -eq 1 ]]; then 
        read -p "$tip_target_path_input" target_path
    else
        echo "$tip_target_path_miss"
        exit 1
    fi
done
while [[ ! -d "$target_path" ]]; then
    if [[ $interactive -eq 1 ]]; then 
        echo "not exist $target_path"
        read -p "$tip_target_path_input" target_path
    else
        echo "$tip_target_path_wrong"
        exit 1
    fi
fi

if [[ -z "$link_type" ]]; then
    link_type="symbolic"
fi

if [[ -d $link_path ]]; then
	# link_path exist with no exist_strategy
    if [[ -z "$exist_strategy" ]]; then
        if [[ $interactive -eq 1 ]]; then 
            select opt in "Dele" "Replace" "None"; do
                case $opt in
                    "Dele")
                        exist_strategy="remove"
                        ;;
                    "Replace")
                        exist_strategy="replace"
                        ;;
                    "None")
                        exist_strategy="none"
                        ;;
                    *)
                        echo "$tip_exist_strategy_choice"
                        ;;
                esac
            done
		else
            echo "$tip_exist_strategy_miss"
			exit 1
		fi
    fi
	if [[ -L $link_path ]]; then
        exist_type="link"
        echo "$tip_exist_symbolic_link"
	else
        exist_type="normal"
		echo "$tip_exist_normal_path"
	fi
done


#####begin

# print info
echo "==========$current_script_name=========="
echo "Work directory is: $current_script_dir"
echo "Link path is: $link_path"
echo "Target path is: $target_path"
echo "Exist type is: $exist_type"
echo "Exist strategy is: $exist_strategy"
echo "Link type is: $link_type"
echo "-----------------NOTE-------------------"
echo "linux directory hard link not support across hard drives;"
echo "use 'symbolic' link, not recommended."
echo "use 'hard' link, need superuser not recommended."
echo "use 'copy_link' copy folder and hard link file."
echo "----------$current_script_name----------"

#remove exist
if [[ "$exist_type" = "link" ]]; then
    if [[ "$exist_strategy"=="remove" ]]; then
		echo "$tip_exist_symbolic_remove"
        unlink $link_path
        link_type="none"
    elif [[ "$exist_strategy"=="replace" ]]; then
		echo "$tip_exist_symbolic_remove"
        unlink $link_path
    elif [[ "$exist_strategy"=="none" ]]; then
		echo "$tip_exist_none"
        link_type="none"
    fi
elif [[ "$exist_type" = "normal" ]]; then
    if [[ "$exist_strategy"=="remove" ]]; then
		echo "$tip_exist_normal_remove"
        rm -rdf $link_path
        link_type="none"
    elif [[ "$exist_strategy"=="replace" ]]; then
		echo "$tip_exist_normal_remove"
        rm -rdf $link_path
    elif [[ "$exist_strategy"=="none" ]]; then
		echo "$tip_exist_none"
        link_type="none"
    fi
fi

_result_code=0

# run command
echo "--------------------"
if [[ "$link_type"=="symbolic" ]]; then
	ln -s -T $target_path $link_path
    [[ $? -ne 0 ]] || _result_code=1
elif [[ "$link_type"=="hard" ]]; then
	ln -d -T $target_path $link_path
    [[ $? -ne 0 ]] || _result_code=1
elif [[ "$link_type"=="copy_link" ]]; then
	cp -al $target_path $link_path
    [[ $? -ne 0 ]] || _result_code=1
elif [[ "$link_type"=="none" ]]; then
	echo "$tip_none"
fi

# done command
_result_code=$?
if [ "$_result_code" -eq "0" ]
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
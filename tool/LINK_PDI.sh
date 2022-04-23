#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-31
# FILE LINK_PDI
# DESC create a symbolic link(in this parent directory) for data-integration directory
# PARAM params for the PDI path
#   1: linkPath
#   2: pdiPath
#   3: skipConflictCheck
#   4: forceConflictReplace
# --------------------
# CHANGE 2019-1-4
# fix interactive check
# CHANGE 2019-1-3
# change param
# add link path in KPT path check
# replace symbolic link path with copy folder + hard link file
# --------------------


# var

tip="Kettle-Project-Toolbox: Link PDI"
ver="1.0"
# here interactive mean user input can be obtained, 
# determined by checking is connected to a terminal 
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0
# current info
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_path="$(dirname "$current_path")"
# tip info
echo_pdiPath="Need input kettle engine(data-integration) path"
eset_pdiPath="Please input path or drag path in:"
# defult param
linkPath=$1
pdiPath=$2
skipConflictCheck=$3
forceConflictReplace=$4


# title

echo -e '\033]2;'$tip $ver'\007'
echo "$tip"
echo "Can be closed after the run ends"
echo "..."


# check

check_conflict(){
    linkPath=$1
    forceConflictReplace=$2

    if [ -L $linkPath ]
    then
        echo "Is already symbolic link!"
        echo "Not support symbolic link on unix, will unlink it!"
        unlink $linkPath
    elif [ -d $linkPath ]
    then
        echo "The folder already exists!"
        if [ "$forceConflictReplace" == "force" ]
        then
            echo "Parameter specifies forced replacement, will remove it!"
            rm -f -r $linkPath
            return 0
        fi
        select opt in "Dele" "Replace" "None"
        do
            case $opt in
                "Dele")
                    rm -f -r $linkPath
                    return 1
                    ;;
                "Replace")
                    rm -f -r $linkPath
                    return 0
                    ;;
                "None")
                    return 1
                    ;;
                *)
                    echo "Please select option!"
                    ;;
            esac
        done
    fi
}
if [ -z $linkPath ]
then
    linkPath="$parent_path/data-integration"
    linkPathKPT="$parent_path/data-integration/.kpt"

    if [ -f $linkPathKPT ]
    then
        echo "Error: link path is in KPT!"
        echo "Please make sure that, current script is running in the KPT directory!"
        echo "Please run 'INIT_KPT' first create workspace, then run this script under the symbolic link 'tool' directory in workspace."
        exit 1
    fi
fi
if [ -z $pdiPath ]
then
    echo $echo_pdiPath
    read -p "$eset_pdiPath" pdiPath
    pdiPath=$(sed -e "s/^'//" -e "s/'$//" <<<"$pdiPath")
fi
if [[ "$skipConflictCheck" == "skip" ]]
then
    echo "skip check conflict"
else
    echo "check conflict"
    if [ -d $linkPath ]
    then
        check_conflict "$linkPath" "$forceConflictReplace"
        if [ "$?" == 1 ]
        then
            echo "user select stop option!"
            exit 0
        fi
    fi
fi


# begin

# goto current path
function fcd() {
  cd $1
}
fcd "$current_path"

# print info
[ $interactive -eq 1 ] && clear
echo "==========================================================="
echo "Work path is: $current_path"
echo "Kettle PDI path is: $linkPath"
echo "Kettle engine(data-integration) path is: $pdiPath"
echo "--------------------NOTE-----------------------------------"
echo "kettle not support symbolic link with directory, will get the wrong path;"
echo "linux not support hard link target to directory;"
echo "will use copy command with hard link, copy folder and link file."
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# create command run
c="cp -al $pdiPath $linkPath"
[ $interactive -ne 1 ] && echo "$c"
$c


# done

code=$?
if [ "$code" -eq "0" ]
then
    echo "Ok, run done!"
else
    echo "Sorry, some error make failure!"
fi


# end

if [ $interactive -eq 1 ]
then
    read -p "Press enter to continue"
    exit $code
else
    exit $code
fi
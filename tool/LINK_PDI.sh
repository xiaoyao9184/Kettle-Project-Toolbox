#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-31
# FILE LINK_PDI
# DESC create a symbolic link(in this parent directory) for data-integration directory
# PARAM params for the PDI path
#   1: pdiPath
#   2: skipConflictCheck
#   3: forceConflictReplace
# --------------------
# CHANGE {time}
# none
# --------------------


# var

tip="Kettle-Project-Toolbox: Link PDI"
ver="1.0"
# interactive
#not set param set 0
interactive=1
if [ -z $1 ]
then
    interactive=0
fi
# current info
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_path="$(dirname "$current_path")"
# tip info
echo_pdiPath="Need input kettle engine(data-integration) path"
eset_pdiPath="Please input path or drag path in:"
# defult param
pdiPath=$1
skipConflictCheck=$2
forceConflictReplace=$3
linkPath="$parent_path/data-integration"

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
        if [ "$forceConflictReplace" == "force" ]
        then
             unlink $linkPath
             return 0
        fi
        select opt in "Dele" "Replace" "None"
        do
            case $opt in
                "Dele")
                    unlink $linkPath
                    return 1
                    ;;
                "Replace")
                    unlink $linkPath
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
    elif [ -d $linkPath ]
    then
        echo "The folder already exists!"
        if [ "$forceConflictReplace" == "force" ]
        then
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
[ $interactive -eq 0 ] && clear
echo "==========================================================="
echo "Work path is: $current_path"
echo "Kettle PDI path is: $linkPath"
echo "Kettle engine(data-integration) path is: $pdiPath"
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# create command run
c="ln -s -T $pdiPath $linkPath"
[ $interactive -ne 0 ] && echo "$c"
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
if [ $interactive -eq 0 ]
then
    read -p "Press enter to continue"
    exit $code
else
    exit $code
fi
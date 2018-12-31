#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-29
# FILE LINK_FOLDER
# DESC create a symbolic link for directory
# PARAM none
# --------------------
# CHANGE {time}
# none
# --------------------


# var

tip="Kettle-Project-Toolbox: Link directory"
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
# tip info
echo_linkPath="Need input link path"
eset_linkPath="Please input path or drag path in:"
echo_targetPath="Need input target path"
eset_targetPath="Please input path or drag path in:"
# defult param
linkPath=$1
targetPath=$2
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
    fi
}
if [ -z $linkPath ]
then
    echo $echo_linkPath
    read -p "$eset_linkPath" linkPath
    linkPath=$(sed -e "s/^'//" -e "s/'$//" <<<"$linkPath")
fi
if [ -z $targetPath ]
then
    echo $echo_targetPath
    read -p "$eset_targetPath" targetPath
    targetPath=$(sed -e "s/^'//" -e "s/'$//" <<<"$targetPath")
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
echo "Kettle link path is: $linkPath"
echo "Kettle target path is: $targetPath"
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# create command run
c="ln -s -T $targetPath $linkPath"
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
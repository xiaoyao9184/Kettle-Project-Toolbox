#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-31
# FILE LINK_KPT
# DESC create a workspace for Kettle-Project-Toolbox using copy and hard link 
# PARAM params for the workspace path and PDI path
#   1: workspacePath 
#   2: pdiPath
# --------------------
# CHANGE 2019-1-4
# fix interactive check
# CHANGE 2019-1-3
# fix workspace path auto create
# use LINK_PDI for link PDI
# --------------------


# var

tip="Kettle-Project-Toolbox: Link KPT"
ver="1.0"
# interactive
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0
# current info
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_path="$(dirname "$current_path")"
# tip info
echo_workspacePath="Need input workspace path for link KPT's paths(tool default)"
eset_workspacePath="Please input path or drag path in:"
# defult param
workspacePath=$1
pdiPath=$2
kptPath="$parent_path"


# title

echo -e '\033]2;'$tip $ver'\007'
echo "$tip"
echo "Can be closed after the run ends"
echo "..."


# check

if [ -z $workspacePath ]
then
    echo $echo_workspacePath
    read -p "$eset_workspacePath" workspacePath
    workspacePath=$(sed -e "s/^'//" -e "s/'$//" <<<"$workspacePath")
fi
[ -d $workspacePath ] || mkdir "$workspacePath"


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
echo "Kettle workspace path is: $workspacePath"
echo "Kettle KPT path is: $kptPath"
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# create param
if [ $interactive -eq 1 ] 
then
    skipConflictCheck=""
    forceConflictReplace=""
else
    echo "Conflict Policy: Force replacement of an existing entity directory or link directory"
    skipConflictCheck="noskip"
    forceConflictReplace="force"
fi

# run
echo "==========================================================="
echo "link KPT tool path..."
bash "$current_path/LINK_FOLDER.sh" "$workspacePath/tool" "$kptPath/tool" "$skipConflictCheck" "$forceConflictReplace"
[ $interactive -eq 1 ] && [ $? -eq 0 ] && clear

echo "==========================================================="
echo "link KPT defalut path..."
bash "$current_path/LINK_FOLDER.sh" "$workspacePath/default" "$kptPath/default" "$skipConflictCheck" "$forceConflictReplace"
[ $interactive -eq 1 ] && [ $? -eq 0 ] && clear

echo "==========================================================="
echo "link PDI path..."
bash "$current_path/LINK_PDI.sh" "$workspacePath/data-integration" "$pdiPath" "$skipConflictCheck" "$forceConflictReplace"
[ $interactive -eq 1 ] && [ $? -eq 0 ] && clear


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
#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-31
# FILE LINK_KPT
# DESC create a symbolic link for Kettle-Project-Toolbox(this directory)
# PARAM params for the workspace path and PDI path
#   1: workspacePath 
#   2: pdiPath
# --------------------
# CHANGE {time}
# none
# --------------------


# var

tip="Kettle-Project-Toolbox: Link KPT"
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
if [ -d $workspacePath ]
then
    mkdir "$workspacePath"
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
echo "Kettle workspace path is: $workspacePath"
echo "Kettle KPT path is: $kptPath"
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# create param
if [ $interactive -eq 0 ] 
then
    param=""
else
    echo "link "
    param="noskip force"
fi

# run
echo "==========================================================="
echo "link KPT tool path..."
bash "$current_path/LINK_FOLDER.sh" "$workspacePath/tool" "$kptPath/tool" "$param"

echo "==========================================================="
echo "link KPT defalut path..."
bash "$current_path/LINK_FOLDER.sh" "$workspacePath/default" "$kptPath/default" "$param"

echo "==========================================================="
echo "link PDI path..."
if [ -z "$pdiPath" ]
then
    bash "$current_path/LINK_FOLDER.sh" "$workspacePath/data-integration"
else
    bash "$current_path/LINK_FOLDER.sh" "$workspacePath/data-integration" "$kptPath/data-integration" "$param"
fi


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
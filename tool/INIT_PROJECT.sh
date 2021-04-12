#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-31
# FILE INIT_PROJECT
# DESC init file repository as project directory
# PARAM none
# --------------------
# CHANGE 2019-1-4
# fix interactive check
# --------------------
# CHANGE 2021-4-9
# change name
# --------------------


# var

tip="Kettle-Project-Toolbox: Init project"
ver="1.0"
# interactive
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0
# current info
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_path="$(dirname "$current_path")"
# tip info
echo_rName="Need input KPT project name"
eset_rName="Please input KPT project name:"
# defult param
rName=
pdi_path=$parent_path/data-integration


# title

echo -e '\033]2;'$tip $ver'\007'
echo "$tip"
echo "Can be closed after the run ends"
echo "..."


# check

if [ -z $rName ]
then
    echo $echo_rName
    read -p "$eset_rName" rName
fi
# linux not support shell open directory
isOpenShell="false"


# begin

# goto current path
function fcd() {
  cd $1
}
fcd "$current_path"

# print info
[ $interactive -eq 1 ] && clear
echo "==========================================================="
echo "Kettle work path is: $current_path"
echo "Kettle engine path is: $pdi_path"
echo "Kettle init project: $rName"
echo "Kettle project will init at: $parent_path"
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# create command run
c="$pdi_path/kitchen.sh -file:$current_path/Project/CreateProject.kjb -param:rName=$rName -param:isOpenShell=$isOpenShell"
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
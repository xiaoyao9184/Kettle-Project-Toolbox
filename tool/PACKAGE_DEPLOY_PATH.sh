#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2021-04-09
# FILE PACKAGE_DEPLOY_PATH
# DESC create a zip file for deploy on filesystem path
# PARAM none
# --------------------
# CHANGE 2021-04-09
# init
# --------------------


# var

tip="Kettle-Project-Toolbox: Package deploy zip for path"
ver="1.0"
# here interactive mean user input can be obtained, 
# determined by checking is connected to a terminal 
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0
# current info
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_path="$(dirname "$current_path")"
# tip info
echo_srcPath="Need input path for create deploy zip"
eset_srcPath="Please input path or drag path in:"
# defult param
srcPath=$1
pdi_path=$parent_path/data-integration


# title

echo -e '\033]2;'$tip $ver'\007'
echo "$tip"
echo "Can be closed after the run ends"
echo "..."


# check

if [ -z $srcPath ]
then
    echo $echo_srcPath
    read -p "$eset_srcPath" srcPath
    srcPath=$(sed -e "s/^'//" -e "s/'$//" <<<"$srcPath")
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
echo "Kettle engine path is: $pdi_path"
echo "Kettle deploy path is: $srcPath"
echo "Kettle deploy file create at: $parent_path"
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# create command run
c="$pdi_path/kitchen.sh -file:$current_path/Deploy/PackageZipDeploy4Path.kjb -param:srcPath=$srcPath -param:fExcludeRegex=.*\.backup$|.*\.log$|.*\.git\\.*|.*db\.cache.*|.*data-integration.* -param:fIncludeRegex=.* -param:isOpenShell=$isOpenShell"
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
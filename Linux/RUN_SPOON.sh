#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-28
# FILE RUN_SPOON
# DESC run spoon with customize KETTLE_HOME
# PARAM none
# --------------------
# CHANGE 2019-1-4
# fix interactive check
# --------------------


# var

tip="Kettle-Project-Toolbox: Run Spoon"
ver="1.0"
# interactive
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0
# current info
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_path="$(dirname "$current_path")"
# set kettle environment
if [ -f "$current_path/SET_ENVIRONMENT.sh" ]
then
    source "$current_path/SET_ENVIRONMENT.sh"
fi


# title

echo -e '\033]2;'$tip $ver'\007'
echo "$tip"
echo "Will auto close"
echo "..."


# begin

# goto engine
function fcd() {
  cd $1
}
fcd "$parent_path/data-integration"

# print info
[ $interactive -eq 1 ] && clear
echo "==========================================================="
echo "Kettle engine path is: $parent_path/data-integration"
echo "Kettle project path is: $current_path"
echo "KETTLE_HOME is: $KETTLE_HOME"
echo "KETTLE_REPOSITORY is: $KETTLE_REPOSITORY"
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# spoon
bash spoon.sh


# end

if [ $interactive -eq 1 ] 
then
    # no need
    # read -p "Press enter to exit"
    exit $code
else
    exit $code
fi
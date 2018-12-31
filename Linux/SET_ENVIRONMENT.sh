#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-28
# FILE SET_ENVIRONMENT
# DESC set kettle environment with KETTLE_HOME
# PARAM none
# --------------------
# CHANGE {time}
# none
# --------------------


# var

# current info
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_path_name=${current_path##*/}
# tip info
echo_use_project_kettle_home="Use project path as KETTLE_HOME:"
echo_use_user_kettle_home="Use user home path as KETTLE_HOME!"
echo_use_dir_name_as_repository_name="Use project path name as KETTLE_REPOSITORY:"
# defult param
KETTLE_HOME=
KETTLE_REPOSITORY=
# set java environment
if [ -f "$current_path/SET_JAVA_ENVIRONMENT.sh" ]
then
    source "$current_path/SET_JAVA_ENVIRONMENT.sh"
fi


# begin

if [ -d "$current_path/.kettle" ]
then
    echo "$echo_use_project_kettle_home $current_path"
    export KETTLE_HOME=$current_path
else 
    echo "$echo_use_user_kettle_home"
fi

_temp_file_repository=0

if [ -f "$current_path/repository.log" ]
then
    _temp_file_repository=1
fi
if [ -d "$current_path/.meta" ]
then
    _temp_file_repository=1
fi
if [ -d "$current_path/.profile" ]
then
    _temp_file_repository=1
fi
if ls %current_path%/*.kdb 1> /dev/null 2>&1
then
    _temp_file_repository=1
fi
if [ -f "$current_path/config.xml" ]
then
    _temp_file_repository=1
fi
if [[ $_temp_file_repository -eq 1 ]]
then
    echo "$echo_use_dir_name_as_repository_name $current_path_name"
    export KETTLE_REPOSITORY=$current_path_name
fi


# exit

return 0

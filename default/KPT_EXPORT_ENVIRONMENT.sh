#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2022-04-22
# FILE KPT_EXPORT_ENVIRONMENT


function function_is_docker() {
    local cgroup=/proc/1/cgroup
    test -f $cgroup && [[ "$(<$cgroup)" = *:cpuset:/docker/* ]]
}

function function_looking() {
    _looking_dir=$1
    _looking_file_name=$2
    _looking_file_ext=$3
    
    if [[ -f "$_looking_dir/$_looking_file_name.$_looking_file_ext" ]]; then
        # echo "true"
        return 0
    else
        # echo "false"
        return 1
    fi
}


#####init_variable

# here interactive mean user input can be obtained, 
# determined by checking is connected to a terminal 
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0
[[ -n "$JENKINS_HOME" ]] && interactive=0
[[ -n "$DEBUG" ]] && interactive=0
[[ -n "$KPT_QUIET" ]] && interactive=0
# docker build not interactive
[[ ! function_is_docker ]] && interactive=0

# current info
source_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source_script_name="$(basename "$(test -L "${BASH_SOURCE[0]}" && readlink "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}")")"
source_script_name="${source_script_name%.*}"

# default param
caller_script_path=$1
in_kpt_project=false

#####check_variable

# caller_script_name
if [[ -z "$caller_script_path" ]]; then
    caller_script_dir="$source_script_dir"
else
    caller_script_dir="$( cd "$( dirname "$caller_script_path" )" >/dev/null 2>&1 && pwd )"
    caller_script_name="$( basename "$caller_script_path" )"
    caller_script_name="${caller_script_name%.*}"
fi

# parent_folder_dir
# parent_folder_name
parent_folder_dir="$(dirname $caller_script_dir)"
parent_folder_name="$(basename $caller_script_dir)"

# looking_file_name
# looking_file_ext
[[ -z "$caller_script_name" ]] && _exist="true"

#####looking_start

# looking kjb in caller_script_dir
if [[ "$_exist" != "true" ]]; then
    looking_file_name=$caller_script_name
    looking_file_ext="kjb"
    function_looking $caller_script_dir $looking_file_name $looking_file_ext
    [[ $? -eq 0 ]] && _exist="true" || _exist="false"
fi 

# looking ktr in caller_script_dir
if [[ "$_exist" != "true" ]]; then
    looking_file_name=$caller_script_name
    looking_file_ext="ktr"
    function_looking $caller_script_dir $looking_file_name $looking_file_ext
    [[ $? -eq 0 ]] && _exist="true" || _exist="false"
fi

# looking kjb in path from caller_script_name
if [[ "$_exist" != "true" ]]; then
    looking_file_name=${caller_script_name//.//}
    looking_file_ext="kjb"
    function_looking $caller_script_dir $looking_file_name $looking_file_ext
    [[ $? -eq 0 ]] && _exist="true" || _exist="false"
fi

# looking ktr in path from caller_script_name
if [[ "$_exist" != "true" ]]; then
    looking_file_name=${caller_script_name//.//}
    looking_file_ext="ktr"
    function_looking $caller_script_dir $looking_file_name $looking_file_ext
    [[ $? -eq 0 ]] && _exist="true" || _exist="false"
fi

# looking not exist
if [[ "$_exist" != "true" ]]; then
    looking_file_name=
    looking_file_ext=
fi

#####looking_done

# in_kpt_project
if [[ -f "$caller_script_dir/repository.log" ]]; then
    in_kpt_project="true"
fi
if [[ -f "$caller_script_dir/.meta" ]]; then
    in_kpt_project="true"
fi
if ls %current_path%/*.kdb 1> /dev/null 2>&1
then
    in_kpt_project="true"
fi
if [[ -f "$caller_script_dir/*.kdb" ]]; then
    in_kpt_project="true"
fi
if [[ -f "$caller_script_dir/config.xml" ]]; then
    in_kpt_project="true"
fi


#####begin

echo "==========$source_script_name=========="

# KPT_COMMAND
if [[ -z "$KPT_COMMAND" ]]; then
    if [[ "$looking_file_ext" = "kjb" ]]; then
        KPT_COMMAND="kitchen"
    elif [[ "$looking_file_ext" = "ktr" ]]; then
        KPT_COMMAND="pan"
    fi
    echo "set 'KPT_COMMAND' to $KPT_COMMAND"
fi

# KPT_LOG_PATH
if [[ $interactive -eq 1 && -z "$KPT_LOG_PATH" ]]; then
    _datetime=$(date +%Y_%m_%d-%H_%M_%S)
    if [[ -d "$caller_script_dir/log" ]]; then
        _log_path="$caller_script_dir/log"
    else
        _log_path="$HOME/.kettle/log"
    fi
    [[ ! -d "$_log_path" ]] && mkdir -p "$_log_path"
    KPT_LOG_PATH="$_log_path/$caller_script_name.$_datetime.log"
    echo "set 'KPT_LOG_PATH' to $KPT_LOG_PATH"
fi

if [[ "$in_kpt_project" = "true" ]]; then
    # KPT_ENGINE_PATH
    if [[ -z "$KPT_ENGINE_PATH" ]]; then
        parent_folder_dir="$(dirname $caller_script_dir)"
        KPT_ENGINE_PATH="$parent_folder_dir/data-integration"
        echo "set 'KPT_ENGINE_PATH' to $KPT_ENGINE_PATH"
    fi
    # KPT_KETTLE_JOB
    if [[ -z "$KPT_KETTLE_JOB" && -n "$looking_file_name" && "$KPT_COMMAND" = "kitchen" ]]; then
        KPT_KETTLE_JOB="${looking_file_name//\\//}"
        echo "set 'KPT_KETTLE_JOB' to $KPT_KETTLE_JOB"
    fi
    # KPT_KETTLE_TRANS
    if [[ -z "$KPT_KETTLE_TRANS" && -n "$looking_file_name" && "$KPT_COMMAND" = "pan" ]]; then
        KPT_KETTLE_TRANS="${looking_file_name//\\//}"
        echo "set 'KPT_KETTLE_TRANS' to $KPT_KETTLE_TRANS"
    fi
    # KPT_PROJECT_PATH
    if [[ -z "$KPT_PROJECT_PATH" ]]; then
        KPT_PROJECT_PATH="$parent_folder_dir/$parent_folder_name"
        echo "set 'KPT_PROJECT_PATH' to $KPT_PROJECT_PATH"
    fi
    # KETTLE_REPOSITORY
    if [[ -z "$KETTLE_REPOSITORY" ]]; then
        KETTLE_REPOSITORY="$parent_folder_name"
        echo "set 'KETTLE_REPOSITORY' to $KETTLE_REPOSITORY"
    fi
elif [[ -n "$looking_file_name" ]]; then
    # KPT_KETTLE_FILE
    if [[ -z "$KPT_KETTLE_FILE" ]]; then
        KPT_KETTLE_FILE="$caller_script_dir/$looking_file_name.$looking_file_ext"
        echo "set 'KPT_KETTLE_FILE' to $KPT_KETTLE_FILE"
    fi
fi

# KETTLE_HOME
if [[ -z "$KETTLE_HOME" && -d $caller_script_dir/.kettle ]]; then
    KETTLE_HOME="${caller_script_dir//\\//}"
    echo "set 'KETTLE_HOME' to $KETTLE_HOME"
fi

echo "##########$source_script_name##########"


#####end

# upgrade/export local env to global
[[ -n "$KPT_COMMAND" ]] && export KPT_COMMAND=$KPT_COMMAND
[[ -n "$KPT_LOG_PATH" ]] && export KPT_LOG_PATH=$KPT_LOG_PATH
[[ -n "$KPT_ENGINE_PATH" ]] && export KPT_ENGINE_PATH=$KPT_ENGINE_PATH
[[ -n "$KPT_PROJECT_PATH" ]] && export KPT_PROJECT_PATH=$KPT_PROJECT_PATH
[[ -n "$KPT_KETTLE_JOB" ]] && export KPT_KETTLE_JOB=$KPT_KETTLE_JOB
[[ -n "$KPT_KETTLE_TRANS" ]] && export KPT_KETTLE_TRANS=$KPT_KETTLE_TRANS
[[ -n "$KPT_KETTLE_FILE" ]] && export KPT_KETTLE_FILE=$KPT_KETTLE_FILE
[[ -n "$KETTLE_HOME" ]] && export KETTLE_HOME=$KETTLE_HOME
[[ -n "$KETTLE_REPOSITORY" ]] && export KETTLE_REPOSITORY=$KETTLE_REPOSITORY

#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2022-04-22
# FILE KPT_RUN_COMMAND


function function_replace() {
    local -n str=$1
    
    str="${str//___/_}"
    str="${str//__/-}"
    str="${str//_/.}"
}


#  parse environment variable to kettle command param name and value
# KPT_KETTLE_PARAM_ prefix will extract prefix for the value, set param name to 'param'
# 1. Remove prefix KPT_KETTLE_PARAM_
# 2. Replace a period (.) with a single underscore (_).
# 3. Replace a dash (-) with double underscores (__).
# 4. Replace an underscore (_) with triple underscores (___).
# 5. Replace value concatenate equal-sign(=) with value
# 
# other environment variable extract param name
# 1. Remove prefix KPT_KETTLE_
# 2. Upper case
# 
function function_env_parse_option() {
    command_name=$1
    env_name=$2
    env_value=$3
    local -n option_type=$4
    local -n option_name=$5
    local -n option_value=$6

    # default use kettle linux options
    option_type="-"

    # default use long options
    [[ "$command_name" = "maitre" ]] && option_type="long"

    # remove prefix
    option_name=${env_name//KPT_KETTLE_/}
    
    if [[ "${option_name:0:6}" = "PARAM_" ]]; then
        # need append value for 'param' option
        option_value_prefix="${option_name:6}"
        option_name="param"
    elif [[ "${option_name:0:31}" = "ADD__VARIABLE__TO__ENVIRONMENT_" ]]; then
        # need append value for 'add-variable-to-environment' option
        option_value_prefix="${option_name:31}"
        option_name="add-variable-to-environment"
    elif [[ "${option_name:0:3}" = "_V_" ]]; then
        # need append value for 'V' option
        option_value_prefix="${option_name:3}"
        option_name="V"
        option_type="short"
    elif [[ "${option_name:0:1}" = "_" ]]; then
        # remove _ prefix
        option_name="${option_name:1}"
        option_type="short"
    else
        # upper case
        option_name="$( echo "$option_name" | tr '[:upper:]' '[:lower:]' )"
        # replace
        function_replace option_name
    fi

    # recreate option value
    if [[ -n "$option_value_prefix" ]]; then
        function_replace option_value_prefix
        option_value="$option_value_prefix=$env_value"
    else
        option_value="$env_value"
    fi
}


#  generation kettle command positional parameters 
# 1. Empty value not need append to result
# 2. Contain spaces need add quotation
function function_option_parameter_generation() {
    option_type=$1
    option_name=$2
    option_value=$3
    local -n option_parameter=$4
    

    # option format
    if [[ "$option_type" = "long" ]]; then
        option_delimiter="="
        option_prefix="--"
    elif [[ "$option_type" = "short" ]]; then
        option_delimiter="="
        option_prefix=-""
    else
        option_delimiter=":"
        option_prefix="$option_type"
    fi

    # check value is empty
    [[ "$env_value" = "" ]] && empty_value="true"
    [[ "$env_value" = " " ]] && empty_value="true"
    [[ "$env_value" = "-" ]] && empty_value="true"
    [[ "$env_value" = ":" ]] && empty_value="true"

    # append value if not empty
    if [[ "$empty_value" = "true" ]]; then
        option_parameter="$option_prefix$option_name"
    else
        option_parameter="$option_prefix$option_name$option_delimiter$option_value"
    fi

    # add quotation marks if spaces or '=' in param
    if [[ "${option_parameter/ /}" != "$option_parameter" ]]; then
        option_parameter="'$option_parameter'"
    elif [[ "${option_parameter/=/}" != "$option_parameter" ]]; then
        option_parameter="'$option_parameter'"
    fi
}


#####init_variable

# version
tip="Kettle-Project-Toolbox: Run kitchen or pan"
ver="1.0"

# here interactive mean user input can be obtained, 
# determined by checking is connected to a terminal 
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0
[[ -n "$JENKINS_HOME" ]] && interactive=0
[[ -n "$DEBUG" ]] && interactive=0
[[ -n "$KPT_QUIET" ]] && interactive=0

# script info
current_script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"

# interactive tip
tip_set_engine_dir="Please input or drop kettle engine path:"
tip_miss_engine_dir="Missing param '_engine_dir' at environment variable 'KPT_ENGINE_PATH'."
tip_set_full_file_path="Please input or drop kettle file path:"
tip_set_repository_item_path="Please input repository kettle file path [use / delimiter include extension]:"
tip_choice_command_name="Please choice kettle command: [J]ob or [T]ransformation?"
tip_miss_command_name="Missing param '_command_name' at environment variable 'KPT_COMMAND'."

# default param
[[ -z "$KPT_CALLER_SCRIPT_PATH" ]] && KPT_CALLER_SCRIPT_PATH=$(realpath "${BASH_SOURCE[0]}")
if [[ -f "$current_script_path/KPT_EXPORT_ENVIRONMENT.sh" ]]; then
    source $current_script_path/KPT_EXPORT_ENVIRONMENT.sh
fi
_engine_dir="$KPT_ENGINE_PATH/"
_command_name="$KPT_COMMAND"
_log_redirect="$KPT_LOG_PATH"


#####tip_version

[[ $interactive -eq 1 ]] && echo -e '\033]2;'$tip $ver'\007' || echo "$tip" 


#####loop_check_variable

if [[ $interactive -eq 1 ]]; then
    while [[ -z "$_command_name" ]]; do
        #  check input exist
        if [[ -z "$KETTLE_REPOSITORY" ]]; then
            read -p "$tip_set_full_file_path" _file_path
        else
            read -p "$tip_set_repository_item_path" _item_path
            _file_path="$KPT_PROJECT_PATH/${_item_path//\\//}"
        fi
        if [[ -f "$_file_path" ]]; then
            _file_ext="${_file_path: -4}"
        else 
            echo "not exist $_file_path"
            _file_ext=""
        fi
        #  set _command_name
        if [[ "$_file_ext" = ".kjb" ]]; then
            _command_name="kitchen"
        elif [[ "$_file_ext" = ".ktr" ]]; then
            _command_name="pan"
        fi
        #  set KPT variable
        if [[ -z "$KETTLE_REPOSITORY" ]]; then
            _file_path="$( realpath $_file_path )"
            KPT_KETTLE_FILE="$_file_path"
        elif [[ "$_file_ext" = ".kjb" ]]; then
            KPT_KETTLE_JOB="${_item_path::-4}"
        elif [[ "$_file_ext" = ".ktr" ]]; then
            KPT_KETTLE_TRANS="${_item_path::-4}"
        fi
    done
    while [[ ! -f "$_engine_dir$_command_name.sh" ]]; do
        if command -v $_command_name &> /dev/null
        then
            _engine_dir=""
            break
        else
            read -p "$tip_set_engine_dir" _engine_dir
            _engine_dir="$( realpath $_engine_dir )/"
        fi
    done
else
    if [[ "$_engine_dir" = "/" ]]; then
        echo "$tip_miss_engine_dir"
        exit 1
    fi
    if [[ -z "$_command_name" ]]; then
        echo "$tip_miss_command_name"
        exit 1
    fi
fi


#####begin

# print info
# [[ $interactive -eq 1 ]] && clear
echo "==========$current_script_name=========="
echo "Script directory is: $current_script_path"
echo "Engine directory is: $_engine_dir"
echo "Command name is: $_command_name"
echo "Command log is: $_log_redirect"
echo "----------$current_script_name----------"

# create command
_command_opt=
read -r -a _env_array <<< "$( echo "${!KPT_KETTLE_*}" )"
for _env in "${_env_array[@]}"; do
    _option_type=""
    _option_name=""
    _option_value=""
    _option_param=""
    function_env_parse_option "$_command_name" "$_env" "${!_env}" _option_type _option_name _option_value
    function_option_parameter_generation "$_option_type" "$_option_name" "$_option_value" _option_param
    if [[ -z "$_command_opt" ]]; then
        _command_opt="$_option_param"
    else
        _command_opt="$_command_opt $_option_param"
    fi
done
_command="$_engine_dir$_command_name.sh $_command_opt"

# print command
echo "$_command"

# run command
echo
if [[ -z "$_log_redirect" ]]; then
    bash $_command
else
    bash $_command &> "$_log_redirect"
fi
code=$?

# done command

echo
if [[ $code -eq 0 ]]; then
    echo "Ok, run done"
else
    echo "Sorry, some error '$code' make failure"
fi

echo "##########$current_script_name##########"


#####end

[[ $interactive -eq 1 ]] && read -n1 -r -p "Press any key to continue..." key
exit $code

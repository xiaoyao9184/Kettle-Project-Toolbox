
#  like this
# maitre -help


current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_folder_dir="$(dirname $current_script_dir)"


export KPT_COMMAND="maitre"
export KPT_KETTLE__a=" "
export KPT_KETTLE_SAFEMODE=""
export KPT_KETTLE__c=" "
export KPT_KETTLE_CLUSTERED=" "
export KPT_KETTLE__C=" "
export KPT_KETTLE_CREATE__ENVIRONMENT=" "
export KPT_KETTLE__d=" "
export KPT_KETTLE_DONTWAIT=" "
export KPT_KETTLE__e=" "
export KPT_KETTLE_ENVIRONMENT=" "
export KPT_KETTLE__f=" "
export KPT_KETTLE__z=" "
export KPT_KETTLE_FILE=" "
export KPT_KETTLE__g=" "
export KPT_KETTLE_REMOTELOG=" "
export KPT_KETTLE__h=" "
export KPT_KETTLE_HELP=" "
export KPT_KETTLE__I=" "
export KPT_KETTLE_IMPORT__ENVIRONMENT=" "
export KPT_KETTLE__j=" "
export KPT_KETTLE_JOB=" "
export KPT_KETTLE__i=" "
export KPT_KETTLE_LEVEL=" "
export KPT_KETTLE__m=" "
export KPT_KETTLE_METRICS=" "
export KPT_KETTLE__o=" "
export KPT_KETTLE_PRINTOPTIONS=" "
export KPT_KETTLE__p=" "
export KPT_KETTLE_PARAMETERS=" "
export KPT_KETTLE__q=" "
export KPT_KETTLE_QUERYDELAY=" "
export KPT_KETTLE__r=" "
export KPT_KETTLE_RUNCONFIG=" "
export KPT_KETTLE__s=" "
export KPT_KETTLE_SLAVE=" "
export KPT_KETTLE__t=" "
export KPT_KETTLE_TRANSFORMATION=" "
export KPT_KETTLE__V=" "
export KPT_KETTLE_ADD__VARIABLE__TO__ENVIRONMENT=" "
export KPT_KETTLE__x=" "
export KPT_KETTLE_EXPORT=" "

bash "$parent_folder_dir/KPT_RUN_COMMAND.sh"


current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"
echo pause by $current_script_name
read -n1 -r -p "Press any key to continue..." key
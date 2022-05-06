
#  like this
# KETTLE_HOME=/mnt/e/Kettle/workspace8.2remix/default
# maitre "-C=test_create=/mnt/e/Kettle/workspace8.2remix/default" "-V=var1=1" "-V=var2=2"


current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_folder_dir="$(dirname $current_script_dir)"


export KPT_KETTLE__C=""
export KPT_KETTLE__V=""
export KPT_KETTLE__V_var2=""
export KPT_COMMAND="maitre"
export KPT_KETTLE_CREATE__ENVIRONMENT="test_create=$parent_folder_dir"
export KPT_KETTLE_ADD__VARIABLE__TO__ENVIRONMENT="var1=1:description"
export KPT_KETTLE_ADD__VARIABLE__TO__ENVIRONMENT_var2="2"

bash "$parent_folder_dir/KPT_RUN_COMMAND.sh"


export KPT_KETTLE_CREATE__ENVIRONMENT=""
export KPT_KETTLE_ADD__VARIABLE__TO__ENVIRONMENT=""
export KPT_KETTLE_ADD__VARIABLE__TO__ENVIRONMENT_var2=""
export KPT_COMMAND="maitre"
export KPT_KETTLE__C="test_create=$parent_folder_dir"
export KPT_KETTLE__V="var1=1"
export KPT_KETTLE__V_var2="2"

bash "$parent_folder_dir/KPT_RUN_COMMAND.sh"


current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"
echo pause by $current_script_name
read -n1 -r -p "Press any key to continue..." key
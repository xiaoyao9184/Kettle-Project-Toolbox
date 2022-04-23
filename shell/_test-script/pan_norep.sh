
#  like this
# KETTLE_HOME=/mnt/e/Kettle/workspace9.1/default
# KETTLE_REPOSITORY=default
# pan /norep /file:/mnt/e/Kettle/Kettle-Project-Toolbox/samples/default_boolean_param/default_boolean_param-test.ktr


current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_folder_dir="$(dirname $current_script_dir)"
kpt_folder_dir="$(dirname $parent_folder_dir)"


export KPT_COMMAND="pan"
export KETTLE_HOME="/mnt/e/Kettle/workspace9.1/default"
export KETTLE_REPOSITORY="default"
export KPT_KETTLE_NOREP=" "
export KPT_KETTLE_FILE="$kpt_folder_dir/samples/default_boolean_param/default_boolean_param-test.ktr"

bash "$parent_folder_dir/KPT_RUN_COMMAND.sh"


current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"
echo pause by $current_script_name
read -n1 -r -p "Press any key to continue..." key
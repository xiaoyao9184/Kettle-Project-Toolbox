
#  like this
# maitre -help


current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_folder_dir="$(dirname $current_script_dir)"


export KPT_COMMAND="maitre"
export KPT_KETTLE_HELP=" "

bash "$parent_folder_dir/KPT_RUN_COMMAND.sh"


export KPT_COMMAND="maitre"
export KPT_KETTLE__h=" "

bash "$parent_folder_dir/KPT_RUN_COMMAND.sh"


current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"
echo pause by $current_script_name
read -n1 -r -p "Press any key to continue..." key
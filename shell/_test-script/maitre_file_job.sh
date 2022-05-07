
#  like this
#  maitre -f= -j=true


current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_folder_dir="$(dirname $current_script_dir)"

kpt_workspace_shell_path="$parent_folder_dir"
kpt_repository_shell_path="$(readlink "$kpt_workspace_shell_path")"
if [[ ! -z "$kpt_repository_shell_path" ]]; then
    kpt_repository_path="$(dirname $kpt_repository_shell_path)"
elif [[ -d "$kpt_workspace_shell_path/../samples" ]]; then
    kpt_repository_path="$(dirname $kpt_workspace_shell_path)"
fi

export KPT_COMMAND="maitre"
export KPT_KETTLE_FILE="$kpt_repository_path/samples/dont_use_Set files in result/EACH_KTR_FILE_PRINT.kjb"
export KPT_KETTLE__t="true"
export KPT_KETTLE_TRANSFORMATION=""
export KPT_KETTLE_LEVEL="Detailed"

bash "$parent_folder_dir/KPT_RUN_COMMAND.sh"


export KPT_COMMAND="maitre"
export KPT_KETTLE_FILE="$kpt_repository_path/samples/dont_use_Set files in result/EACH_KTR_FILE_PRINT.kjb"
export KPT_KETTLE__t=""
export KPT_KETTLE_TRANSFORMATION="true"
export KPT_KETTLE_LEVEL="Detailed"

bash "$parent_folder_dir/KPT_RUN_COMMAND.sh"


current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"
echo pause by $current_script_name
read -n1 -r -p "Press any key to continue..." key
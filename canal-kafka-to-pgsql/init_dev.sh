#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2022-04-29


current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"
parent_folder_dir="$(dirname $current_script_dir)"
parent_folder_name="$(basename $current_script_dir)"


export kpt_project_name=$parent_folder_name
export target_project_path=$current_script_dir
export copy_item_name_list="config.xml;db_kpt_bin_log_pgsql_writer.kdb"
export link_item_name_list="mysql-log"

bash "$parent_folder_dir/tool/link_project.sh"


export kpt_project_name=
export target_project_path=
export copy_item_name_list=
export link_item_name_list=


echo
read -p "pause by $current_script_name"

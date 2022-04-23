
#  like this
# default_boolean_param-test.sh
# pan /file:../../samples/default_boolean_param/default_boolean_param-test.ktr


current_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_folder_dir="$(dirname $current_script_dir)"
kpt_folder_dir="$(dirname $parent_folder_dir)"


cp "$parent_folder_dir/KPT_EXPORT_ENVIRONMENT.sh" "$kpt_folder_dir/samples/default_boolean_param/KPT_EXPORT_ENVIRONMENT.sh"
cp "$parent_folder_dir/KPT_RUN_COMMAND.sh" "$kpt_folder_dir/samples/default_boolean_param/default_boolean_param-test.sh"

bash "$kpt_folder_dir/samples/default_boolean_param/default_boolean_param-test.sh"

rm "$kpt_folder_dir/samples/default_boolean_param/KPT_EXPORT_ENVIRONMENT.sh"
rm "$kpt_folder_dir/samples/default_boolean_param/default_boolean_param-test.sh"


current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"
echo pause by $current_script_name
read -n1 -r -p "Press any key to continue..." key
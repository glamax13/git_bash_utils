#!/bin/bash
main_timer="$(date "+%s")"
#####   Configuration
script_folder="$(dirname ${BASH_SOURCE[0]})"
help="$script_folder/help.txt"
action=""
origin="$(pwd)"
workspace="$(dirname "$origin")/conv_workspace"
destination="$workspace/output"
workbench="$workspace/workbench"
lst_ext=()
lst_files=()

source "$script_folder/global_conf.sh"
source "$conv_build"
source "$find_foi"
source "$select_ext"

#####   Parameters
while getopts a:e:w:h option
do
    case ${option}
    in
        a) action=${OPTARG};;
        e) lst_ext=( "${OPTARG}" );;
        w) from="$(pwd)"; where=${OPTARG}; cd "$where";;
        h) cat $help; exit;;
        *) echo "Option not handled!"; cat $help; exit;;
    esac
done

#####   Setup
#       Function

function full_clean {   #   Full steps to convert everything to utf8
    echo "=> Clean utf8 (first run)..."
    change "$replacer" "-a" "utf8" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"
    
    echo "=> Conv utf8..."
    change "$conv_utf8" "" "" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"
    
    echo "=> Clean utf8 (second run)..."
    change "$replacer" "-a" "utf8" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"
    
    echo "=> Conv html..."
    change "$replacer" "-a" "html" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"
    
    make_build "$path_to_conv" "$path_been_conv"
    files_build "*" "$path_to_conv" "$path_been_conv"
}

function change {
    #script extension from to
    change_script="$1"
    change_action_param="$2"
    change_action="$3"
    change_ext="$5"
    change_from="$7"
    change_to="$9"
    change_log="${11}"

    make_build "$path_to_conv" "$path_been_conv"
    source $change_script "$change_action_param" "$change_action" "-e" "$change_ext" "-f" "$change_from" "-t" "$change_to" "-l" "$change_log"
    apply_build "$change_to" "$change_from"
}

#####Execution
###Extension(s) selection
if [[ "${#lst_ext[@]}" = "0" ]]
then
    select_ext
    lst_ext+=( "${LST_EXTENSION[@]}" )
fi

###Setup
make_build "." "$path_to_conv"
make_build "$path_to_conv" "$path_been_conv"

for ext_build in ${lst_ext[@]}
do
    files_build "$ext_build" "." "$path_to_conv"
done

if [[ $action ]]
then
    case $action
    in
        clean_utf8) 
            for extension in ${lst_ext[@]}
            do
                source "$replacer" "-a" "utf8" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"
            done
        ;;
        conv_utf8)
            for extension in ${lst_ext[@]}
            do
                source "$conv_utf8" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"
            done
        ;;
        conv_html)
            for extension in ${lst_ext[@]}
            do
                source "$replacer" "-a" "html" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"
            done
        ;;
        full)
            for extension in ${lst_ext[@]}
            do
                full_clean
            done
        ;;
        *) echo "Error! I don't know this action: $action"; exit;;
    esac
else
    cat $help
fi

if [ $from ]
then
    cd "$from"
fi
echo "Total execution time: $(($(date "+%s")-$main_timer)) seconds."
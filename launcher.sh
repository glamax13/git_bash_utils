#!/bin/bash
main_timer="$(date "+%s")"
#####   Configuration
script_folder="$(dirname ${BASH_SOURCE[0]})"
help="$script_folder/help.txt"
action=""
project="$PWD"
thread=1
workspace="$(dirname "$project")/gbu_${PWD##*/}"
lst_ext=()
lst_files=()

source "$script_folder/global_conf.sh"
source "$src_mgr"
source "$find_foi"
source "$select_ext"
source "$validation"

#####   Parameters
while getopts ha:w:e:p:t:l:g option
do
    case ${option}
    in
        h) cat $help; exit;;
        a) action=${OPTARG};;
        w) workspace=${OPTARG};;
        e) lst_ext=( "${OPTARG}" );;
        p) project=${OPTARG}; cd "$project";;
		t) thread=${OPTARG};;
        l) log=${OPTARG};;
		g) source "$script_folder/generate.sh"; exit;;
        *) echo "Option not handled!"; cat $help; exit;;
    esac
done

#####   Setup
#       Variable
workbench="$workspace/workbench"
output="$workspace/output"
log="$workspace/log"

#       Function

function full_clean {   #   Full steps to convert everything to utf8
	source "$replacer"
	source "$conv_utf8"

    echo "  => Clean utf8 (first run)..."
    dup_folders "$workbench/$extension" "$output/$extension"
        replace "-a" "clean_utf8"	"-e" "$extension" "-o" "$workbench/$extension" "-d" "$output/$extension" "-t" "$thread" "-l" "$log/$extension"
    merge_changes "$output/$extension" "$workbench/$extension"
    
    echo "  => Conv utf8..."
    dup_folders "$workbench/$extension" "$output/$extension"
        conv					"-e" "$extension" "-o" "$workbench/$extension" "-d" "$output/$extension" 				"-l" "$log/$extension"
    merge_changes "$output/$extension" "$workbench/$extension"
    
    echo "  => Clean utf8 (second run)..."
    dup_folders "$workbench/$extension" "$output/$extension"
        replace "-a" "clean_utf8"	"-e" "$extension" "-o" "$workbench/$extension" "-d" "$output/$extension" "-t" "$thread" "-l" "$log/$extension"
    merge_changes "$output/$extension" "$workbench/$extension"
    
    echo "  => Conv html..."
    dup_folders "$workbench/$extension" "$output/$extension"
        replace "-a" "conv_html" 	"-e" "$extension" "-o" "$workbench/$extension" "-d" "$output/$extension" "-t" "$thread" "-l" "$log/$extension"
    merge_changes "$output/$extension" "$workbench/$extension"
    dup_folders "$workbench/$extension" "$output/$extension"
    dup_files "$workbench/$extension" "$output/$extension" "*"
}

#####Execution
if [ ! $action ]
then
    cat $help
    exit
fi

###Extension(s) selection
if [ "${#lst_ext[@]}" = "0" ]
then
    select_ext
    lst_ext+=( "${LST_EXTENSION[@]}" )
fi

###Workspace
for extension in ${lst_ext[@]}
do
    ###Setup
    if [ -d "$workbench/$extension" ]
    then
        validation -m "A previous action seems to have been aborded. Do you want to clean it"
        if [ ! $VALID ]
        then
            echo "Action $action cancelled. Quitting."
            exit
        else
            rm -rf "$workbench/$extension"
            rm -rf "$output/$extension"
            rm -rf "$log/$extension"
        fi
    elif [ -d "$output/$extension" ]
    then
        validation -m "An output for the $extension extension already exists in this workspace. Do you want to overwrite it"
        if [ ! $VALID ]
        then
            echo "Action $action cancelled. Quitting."
            exit
        else
            rm -rf "$output/$extension"
            rm -rf "$log/$extension"
        fi
    fi
    arr_ws_folder=( "$workspace" "$workbench" "$workbench/$extension" "$output" "$output/$extension" "$log" "$log/$extension" )
    for ws_folder in ${arr_ws_folder[@]}
    do
        if [ ! -d "$ws_folder" ]
        then
            mkdir "$ws_folder"
        fi
    done

    dup_folders "$project" "$workbench/$extension"
    dup_files "$project" "$workbench/$extension" "$extension"
    echo "$(date "+%d_%m_%Y-%H_%M") : ${ARR_FOI[@]}" >> "$workspace/$action-executions.log"
    dup_folders "$workbench/$extension" "$output/$extension"

    case $action
    in
        clean_utf8) source "$replacer"; replace "-a" "clean_utf8"	"-e" "$extension" "-o" "$workbench/$extension" "-d" "$output/$extension" "-t" "$thread" "-l" "$log/$extension";;
        conv_html)  source "$replacer"; replace "-a" "conv_html" 	"-e" "$extension" "-o" "$workbench/$extension" "-d" "$output/$extension" "-t" "$thread" "-l" "$log/$extension";;
        conv_utf8)  source "$conv_utf8"; conv						"-e" "$extension" "-o" "$workbench/$extension" "-d" "$output/$extension" 				"-l" "$log/$extension";;
        full)       full_clean;;
        *) echo "Error! I don't know this action: $action"; exit;;
    esac
	rm -rf "$workbench/$extension"
done
rm -rf "$workbench"
echo "Total execution time: $(($(date "+%s")-$main_timer)) seconds."
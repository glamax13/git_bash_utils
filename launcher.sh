#!/bin/bash
###Loading settings
script_folder="$(dirname $0)"
help="$script_folder/help.txt"
source "$script_folder/global_conf.sh"
source "$conv_build"
source "$find_foi"
###Env variables
lst_ext=()
lst_files=()
where="."

#####Function's delarations
###Full steps to convert everything to utf8
function full_clean {
    echo "=> Clean utf8..."
    change "$clean_utf8" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"

    echo "=> Conv utf8..."
    change "$conv_utf8" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"

    echo "=> Clean utf8..."
    change "$clean_utf8" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"

    echo "=> Conv html..."
    change "$conv_html" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"

    clean_build "$path_been_conv"
    make_build "$path_to_conv" "$path_been_conv"
    files_build "*" "$path_to_conv" "$path_been_conv"
}

function change {
    #script extension from to
    change_script=$1
    change_ext=$3
    change_from=$5
    change_to=$7
    change_log=$9
    clean_build "$path_been_conv"
    make_build "$path_to_conv" "$path_been_conv"
    source $change_script "-e" "$change_ext" "-f" "$change_from" "-t" "$change_to" "-l" "$change_log"
    apply_build "$change_to" "$change_from"
}

function select_ext {
    find_foi -e "*" -w "." -t "f"
    for ext_file in ${ARR_FOI[@]}
    do
        cut_ext="${ext_file##*.}"
        if [[ "$cut_ext" =~ "/" ]]
        then
            :
        else
            lst_all_ext+=( "$cut_ext" )
        fi
    done
    lst_unique_ext=($(echo "${lst_all_ext[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
    
    for ext in ${lst_unique_ext[@]}
    do
        read -p "Include files with $ext extension? (Y/n): " answer
        answer="${answer,,}"

        if [[ "$answer" = "" ]] || [[ "$answer" = "y" ]] || [[ "$answer" = "yes" ]] || [[ "$answer" = "o" ]] || [[ "$answer" = "oui" ]]
        then
            lst_ext+=( "$ext" )
        fi
    done
}

#####Execution
###User's settings choice.
if [ $# = 0 ]
then
    cat $help;
else
    while getopts a:e:w:h option
    do
        case ${option}
        in
            a) action=${OPTARG};;
            e) lst_ext=( "${OPTARG}" );;
            w) where=$path_to_conv;;
            h) cat $help;;
            *) echo "Option not handled!"; cat $help; exit;;
        esac
    done

    ###User's action choice
    if [[ "${#lst_ext[@]}" = "0" ]]
    then
        select_ext
    fi
    
    ###Setup
    clean_build "$path_to_conv"
    make_build "." "$path_to_conv"
    
    clean_build "$path_been_conv"
    make_build "$path_to_conv" "$path_to_conv"

    for ext_build in ${lst_ext[@]}
    do
        find_foi -e "$ext_build" -w "$where" -t "f"
        lst_files+=( "${ARR_FOI[@]}" )
        
        files_build "$ext_build" "." "$path_to_conv"
    done
    echo "Found ${#lst_files[@]} original files"

    if [[ $action ]]
    then
        case $action
        in
            clean_utf8) 
                for extension in ${lst_ext[@]}
                do
                    source "$clean_utf8" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"
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
                    source "$conv_html" "-e" "$extension" "-f" "$path_to_conv" "-t" "$path_been_conv" "-l" "$path_to_logs"
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
fi
echo "Done!";
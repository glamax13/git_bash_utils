#!/bin/bash

script_folder="$(dirname ${BASH_SOURCE[0]})"
ext_file=""
from=""
to=""
max_comp=0
logs="/dev/null"

source "$(realpath -s $script_folder/../../global_conf.sh)"
source "$(realpath -s $script_folder/worker.sh)"
source "$progress_bar"
source "$find_foi"
source "$arr_maker"

clean=(); dirty=();

#Parameters
OPTIND=1
while getopts e:f:t:l: option
do
    case ${option}
    in
        e) ext_file=${OPTARG};;
        f) from=${OPTARG};;
        t) to=${OPTARG};;
        l) logs=${OPTARG};;
        *) echo "Option not handled!";;
    esac
done
###Setup
#Function
function output {
    wait
    for task in "${arr_task[@]}"
    do
        printf %s\\n "$(cat <&$task)" >> "$to/$file"
    done
    for fd in $(ls /proc/$$/fd/)
    do
        [ $fd -gt 2 ] && exec {fd}<&-
    done
    arr_task=()
}

#Comparisson arrays
make_arr "$script_folder/src/lst_clean_sort.txt"; clean+=( "${MAKE_ARR_RET[@]}" )
make_arr "$script_folder/src/lst_dirty_sort.txt"; dirty+=( "${MAKE_ARR_RET[@]}" )
max_comp=${#clean[@]}
arr_task=()
arr_line=()
echo "Les mentions {rep} seront à remplacer manuellements."

###Work
if [ $ext_file ]
then
    echo "Processing $ext_file files..."
    find_foi -e "$ext_file" -w "$from" -t "f"
    for file in ${ARR_FOI[@]}
    do
        nb_line="$(wc -l $file)"
        nb_line=${nb_line/$file/}
        if [ $nb_line -gt 999 ]
        then
            while IFS= read -r line || [ -n "$line" ]
            do
                arr_line+=("$line")
                if [ $((${#arr_line[@]} % 999)) -eq 0 ]
                then
                    exec {fd}< <(echo "$(worker "$arr_line")")
                    arr_task+=("$fd")
                    arr_line=()

                    if [ ${#arr_task[@]} -gt 13 ]
                    then
                        output
                    fi
                fi
            done < "$from/$file"
            output
        else
            while IFS= read -r line || [ -n "$line" ]
            do
                worker "$line" >> "$to/$file"
            done < "$from/$file"
        fi
    done
else
    echo "No ext provided"
fi
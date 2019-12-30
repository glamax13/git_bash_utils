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
#Comparisson arrays
make_arr "$script_folder/src/lst_clean_sort.txt"; clean+=( "${MAKE_ARR_RET[@]}" )
make_arr "$script_folder/src/lst_dirty_sort.txt"; dirty+=( "${MAKE_ARR_RET[@]}" )
max_comp=${#clean[@]}
arr_task=()
arr_res=()
echo "Les mentions {rep} seront à remplacer manuellements."

if [ $ext_file ]
then
    echo "Processing $ext_file files..."
    find_foi -e "$ext_file" -w "$from" -t "f"
    for file in ${ARR_FOI[@]}
    do 
        nb_line=0
        while IFS= read -r line || [ -n "$line" ]
        do
            exec {fd}< <(res=$(worker $line); echo $res) || exit 1
            arr_task+=("$!:$fd:$nb_line")
            nb_line=$(($nb_line+1))
            handler || exit 1
        done < "$from/$file"


        j=0
        nb_res=${#arr_res[@]}
        while [[ $j -lt $nb_res ]]
        do
            printf %s\\n ${arr_res[$j]} >> "$to/$file"
            j=$(($j+1))
        done
    done
else
    echo "No ext provided"
fi
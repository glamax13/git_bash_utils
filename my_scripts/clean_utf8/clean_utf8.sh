#!/bin/bash
script_folder="$(dirname ${BASH_SOURCE[0]})"
ext_file=""
from=""
to=""
max_comp=0

source "$(realpath -s $script_folder/../../global_conf.sh)"
source "$progress_bar"
source "$find_foi"
source "$arr_maker"

clean=(); dirty=();

function process {
    i=0
    ori=$1
    swap=$1

    while [[ $i -lt $max_comp ]]
    do
        selector="${dirty[$i]}"
        replacer="${clean[$i]}"
        swap="${swap//$selector/$replacer}"
        i=$(($i+1))
    done
    selector="{a_tilda_maj}"
    replacer="Ã"
    swap="${swap//$selector/$replacer}"
    if [ "$ori" != "$swap" ]
    then
        echo "$nb_line          $file" >> "$logs/double_utf8_changes.log"
        echo "$ori" >> "$logs/double_utf8_changes.log"
        echo "$swap" >> "$logs/double_utf8_changes.log"
        if [[ "$swap" =~ "{rep}" ]]
        then
            echo "$nb_line          $file" >> "$logs/double_utf8_to_change.log"
            echo "$ori" >> "$logs/double_utf8_to_change.log"
            echo "$swap" >> "$logs/double_utf8_to_change.log"
        fi
    fi
    printf %s\\n "$swap" >> "$to/$file"
    #echo $swap
}

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
make_arr "$script_folder/src/lst_clean_sort.txt"; clean+=( "${clean[@]}" "${MAKE_ARR_RET[@]}" )
make_arr <"$script_folder/src/lst_dirty_sort.txt"; dirty+=( "${dirty[@]}" "${MAKE_ARR_RET[@]}" )
max_comp=${#clean[@]}
#echo "Comparisson array: ${#clean[@]} clean values and ${#dirty[@]} dirty ones."
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
            process "$line"
            nb_line=$(($nb_line+1))
        done < "$from/$file"
    done
else
    echo "No ext provided"
fi
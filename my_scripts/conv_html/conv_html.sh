#!/bin/bash
script_folder="$(dirname ${BASH_SOURCE[0]})"
ext_file=""

source "$(realpath -s $script_folder/../../global_conf.sh)"
source "$find_foi"
source "$arr_maker"

clean=(); dirty=(); list=( "desi" "code" "extra" );

###Declaring functions
function process {
    ori=$1
    swap=$1
    
    if [[ $swap =~ "&" ]]
    then
        selector="&amp;"
        replacer="&"
        swap=${swap//$selector/$replacer}

        i=0
        while [[ $i -lt ${#clean[@]} ]]
        do
            selector=${dirty[$i]}
            replacer=${clean[$i]}
            swap=${swap//$selector/$replacer}
            i=$(($i+1))
        done

        if [ "$ori" != "$swap" ]
        then
            if [[ $swap =~ "{apos}" ]]
            then
                echo "$num_line          $file" >> ~/conv/log/html_to_changes.log
                echo "$ori" >> $logs/html_to_changes.log
                echo "$swap" >> $logs/html_to_changes.log
            fi
            echo "$num_line          $file" >> $logs/html_changes.log
            echo "$ori" >> $logs/html_changes.log
            echo "$swap" >> $logs/html_changes.log
        else
            echo "$ori" >> $logs/html_detect.log
        fi
    fi
    printf %s\\n "$swap" >> $to/$file
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
for rep_type in ${list[@]}
do
    make_arr "$script_folder/src/$rep_type-clean.regist"; clean+=( "${clean[@]}" "${MAKE_ARR_RET[@]}" )
    make_arr "$script_folder/src/$rep_type-dirty.regist"; dirty+=( "${dirty[@]}" "${MAKE_ARR_RET[@]}" )
done
#echo "Comparisson array: ${#clean[@]} clean values and ${#dirty[@]} dirty ones."

###Execution
if [ $ext_file ]
then
    echo "Processing $ext_file files..."
    find_foi -t "f" -w "$from" -e "$ext_file"
    for file in ${ARR_FOI[@]}
    do
        nb_line=$(wc -l < "$from/$file")
        echo "File : $file, lines : $nb_line"
        num_line=0
        while IFS= read -r line || [ -n "$line" ]
        do
            process "$line"
            num_line=$(($num_line+1))
        done < "$from/$file"
    done
else
    echo "No ext provided"
fi
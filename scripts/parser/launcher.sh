#!/bin/bash
script_folder="$(dirname ${BASH_SOURCE[0]})"

source "$(realpath -s $script_folder/../../global_conf.sh)"
source "$progress_bar"
source "$find_foi"
source "$select_ext"
source "$script_folder/deps/parser_files.sh"
source "$script_folder/deps/parser_lines.sh"
source "$arr_maker"

help="script_folder/help.txt"
advanced=""
ext_file=""
needle=""
from="."
thread=1
logs="."
lst_ext=()
lst_files=()

#Parameters
OPTIND=1
while getopts ae:n:f:t:l: option
do
    case ${option}
    in
        a) advanced="true";;
        e) ext_file=${OPTARG};;
		n) needle=${OPTARG};;
        f) from=${OPTARG};;
        t) thread=${OPTARG};;
        l) logs=${OPTARG};;
        *) echo "Option not handled!"; cat $help;;
    esac
done

if [ $ext_file ]
then
	lst_ext=( "$ext_file" )
else
	select_ext -f $from
    lst_ext="${LST_EXTENSION[@]}"
fi

for ext in ${lst_ext[@]}
do
	find_foi -w "$from" -e "$ext" -t "f"
	lst_files+=( "${ARR_FOI[@]}" )
done

if [ $ext_file ]
then
	find_foi -e "$ext_file" -w "$from" -t "f"
	lst_files=( "${ARR_FOI[@]}" )
    
    i=0
    for file in ${lst_files[@]}
    do
		if [ "$(($i%$thread))" = "0" ]
		then
			wait
            ProgressBar "$i" "${#lst_files[@]}" "$file"
		fi
        parse_files "$from" "$file" "$needle" "$logs" #&
		i=$(($i+1))
	done
    ProgressBar "$i" "${#lst_files[@]}" "$file"
    echo "i said stop"
    make_arr "$logs/PARSED_FILE"
    rm "$logs/PARSED_FILE"
    PARSED_FILE=( "${MAKE_ARR_RET[@]}" )
    wait

    
    for parsed in $PARSED_FILE
    do
        echo "$parsed" >> "$logs/parser.log"
        echo "$parsed"
        if [ $advanced ]
        then
            parse_lines "$from" "$parsed" "$needle" "$logs"
            make_arr "$logs/PARSED_LINE"
            #rm "$logs/PARSED_LINE"
            PARSED_LINE=( "${MAKE_ARR_RET[@]}" )
            for line in $PARSED_LINE
            do
                echo "$line" >> "$logs/parser.log"
            done
        fi
    done
else
	echo "No ext provided!"
fi
echo "Done! Results can be found at $logs/parser.log"
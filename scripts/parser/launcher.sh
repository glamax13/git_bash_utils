#!/bin/bash
script_folder="$(dirname ${BASH_SOURCE[0]})"

#region Dependencies fetching
source "$(realpath -s $script_folder/../../global_conf.sh)"
source "$progress_bar"
source "$find_foi"
source "$select_ext"
source "$script_folder/deps/parser_files.sh"
source "$script_folder/deps/parser_lines.sh"
source "$arr_maker"
#endregion

#region Variables definition
help="script_folder/help.txt"
advanced=""
ext_file=""
needle=""
from="."
thread=1
logs="."
lst_ext=()
lst_files=()
#endregion

#region Parameters selection
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
#endregion

#region Handling extension selection
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
#endregion

#region Processing folder
if [ $ext_file ]
then
	find_foi -e "$ext_file" -w "$from" -t "f"
	lst_files=( "${ARR_FOI[@]}" )
    #region Parsing files
    i=0
    for file in ${lst_files[@]}
    do  
        parse_files "$from" "$file" "$needle" "$logs"
		i=$(($i+1))
		if [ "$(($i%$thread))" = "0" ]
		then
            ProgressBar "$i" "${#lst_files[@]}" "$file"
		fi
	done
    #region Handling results
    if [ -e "$logs/PARSED_FILE" ]
    then
        make_arr "$logs/PARSED_FILE"
        rm "$logs/PARSED_FILE"
        PARSED_FILE=( "${MAKE_ARR_RET[@]}" )
        echo "###   New run   ###" >> "$logs/parser.log"
    else
        echo "Needle not found."
    fi
    #endregion
    #endregion

    for parsed in ${PARSED_FILE[@]}
    do
        echo "$parsed" >> "$logs/parser.log"
        #region Parsing lines
        if [ $advanced ]
        then
            parse_lines "$from" "$parsed" "$needle" "$logs"
            make_arr "$logs/PARSED_LINE"
            rm "$logs/PARSED_LINE"
            PARSED_LINE=( "${MAKE_ARR_RET[@]}" )
            for line in "${PARSED_LINE[@]}"
            do
                printf '%s\n' "$line" >> "$logs/parser.log"
            done
        fi
        #endregion
    done
else
	echo "No ext provided!"
fi
echo "Done! Results can be found at $logs/parser.log"
#endregion
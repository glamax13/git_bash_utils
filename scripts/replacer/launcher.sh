#!/bin/bash
replacer_timer="$(date "+%s")"
#####	Configuration
script_folder="$(dirname ${BASH_SOURCE[0]})"
action=""
ext_file=""
from=""
to=""
log="/dev/null"
verbose=""
nb_chunk=999
nb_thread=13

source "$(realpath -s $script_folder/../../global_conf.sh)"
source "$progress_bar"
source "$find_foi"
source "$arr_maker"

#####	Parameters
OPTIND=1
while getopts a:e:f:t:l:v option
do
    case ${option}
    in
		a) action=${OPTARG};;
        e) ext_file=${OPTARG};;
        f) from=${OPTARG};;
        t) to=${OPTARG};;
        l) log=${OPTARG};;
		v) verbose="-v";;
        *) echo "Option not handled!";;
    esac
done

#####	Setup
#		Function
function output {
    wait
    for task in ${arr_task[@]}
    do
        printf %s\\n "$(cat <&$task)" >> "$to/$file"
    done
    for fd in $(ls /proc/$$/fd/)
    do
        [ $fd -gt 2 ] && exec {fd}<&-
    done
    arr_task=()
    progress_bar $num_line $nb_line $file
}

###		Action
if [ $action ]
then
	#		Variables
	action_folder="$script_folder/$action"
	#		Import worker
	source "$action_folder/worker.sh"
	#		Comparisson arrays
	arr_ref_chars=("desi" "code" "lst" "extra")			#	Reference files names 
	for rep_type in ${arr_ref_chars[@]}
	do
		if [ -f "$action_folder/src/$rep_type-clean.regist" -a -f "$action_folder/src/$rep_type-dirty.regist" ]
		then											#	Populating reference arrays with existing files
			make_arr "$action_folder/src/$rep_type-clean.regist"; clean+=( "${clean[@]}" "${MAKE_ARR_RET[@]}" )
			make_arr "$action_folder/src/$rep_type-dirty.regist"; dirty+=( "${dirty[@]}" "${MAKE_ARR_RET[@]}" )
		fi
	done

	###		Work
	if [ $ext_file ]
	then
		echo "Processing $ext_file files..."
		find_foi -t "f" -w "$from" -e "$ext_file"
		for file in ${ARR_FOI[@]}
		do
			arr_task=()
			arr_line=()
			nb_line=$(wc -l < "$from/$file")
			num_line=0
			progress_bar $num_line $nb_line $file
			if [ $nb_line -gt $nb_chunk ]
			then
				while IFS= read -r line || [ -n "$line" ]           #   Reading the file line by line
				do
					arr_line+=("$line")                             #   Populating the array of lines
					if [ ${#arr_line[@]} -eq $nb_chunk ]
					then           
						exec {fd}< <(echo "$(worker "$arr_line")")  #   Processing a chunk of lines async
						arr_task+=("$fd")                           #   Saving the process/file descriptor index
						num_line=$(($num_line+${#arr_line[@]}))
						if [ ${#arr_task[@]} -gt $nb_thread ]       #   Threshold of simultaneous process
						then
							output                                  #   Writting processed lines to the output file in order
						fi
						arr_line=()                                 #   Reseting the array of lines for the next process
					fi
				done < "$from/$file"                                #   Feeding the file to the read loop
				if [ ${#arr_line[@]} -gt 0 ]                        #   Processing leftover lines
				then
					exec {fd}< <(echo "$(worker "$arr_line")")
					arr_task+=("$fd")
					num_line=$(($num_line+${#arr_line[@]}))
				fi
				output
			else
				while IFS= read -r line || [ -n "$line" ]           #   Lightweight processing for small files (reading file descriptors would take longer)
				do
					worker "$line" >> "$to/$file"
				done < "$from/$file"
			fi
		done
	else
		echo "No ext provided"
	fi
else
	echo "No action provided"
fi
echo "Executed $action replacement in $(($(date "+%s")-$replacer_timer)) seconds."
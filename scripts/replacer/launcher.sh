#!/bin/bash
function replace {
	local replacer_timer="$(date "+%s")"
	#####	Configuration
	local script_folder="$(dirname ${BASH_SOURCE[0]})"
	local action=""
	local ext_file=""
	local origin=""
	local destination=""
	local log="/dev/null"
	local verbose=""
	local quiet=""
	local nb_thread=1

	source "$script_folder/worker.sh"
	source "$(realpath -s $script_folder/../../global_conf.sh)"
	source "$progress_bar"
	source "$find_foi"

	#####	Parameters
	OPTIND=1
	while getopts a:e:o:d:t:l:vq option
	do
		case ${option}
		in
			a) action=${OPTARG};;
			e) ext_file=${OPTARG};;
			o) origin=${OPTARG};;
			d) destination=${OPTARG};;
			t) nb_thread=${OPTARG};;
			l) log=${OPTARG};;
			v) verbose="-v";;
			q) quiet="-q";;
			*) echo "Option not handled!";;
		esac
	done

	###		Action
	if [ $action ]
	then
		#		Variables
		action_folder="$script_folder/$action"
		
		###		Work
		if [ $ext_file ]
		then
			escape_type=""
			if [ "$action" = "conv_html" ]
			then
				case "$ext_file"
				in
					php) escape_type="php";;
					sql) escape_type="sql";;
					*) escape_type="default";;
				esac
				echo "Replacing with $escape_type escaped characters."
				sed_script="$action_folder/src/$action-$escape_type-ref.sed"
			else
				sed_script="$action_folder/src/$action-ref.sed"
			fi
			echo "Processing $ext_file files..."
			find_foi -t "f" -w "$origin" -e "$ext_file"
			nb_files="${#ARR_FOI[@]}"
			nb_file_processed="0"
			nb_process="0"
			nb_ended=""

			for file in ${ARR_FOI[@]}
			do
				progress_bar "$nb_file_processed" "$nb_files" "$file"
				worker -s "$sed_script" -o "$origin" -d "$destination" -l "$log" "$quiet" &
				nb_process=$(($nb_process+1))
				if [ "$nb_process" = "$nb_thread" ]
				then
					wait
					nb_file_processed=$(($nb_file_processed+$nb_process))
					nb_process=0
				fi
			done
			wait
			nb_file_processed=$(($nb_file_processed+$nb_process))
			progress_bar "$nb_file_processed" "$nb_files" "$file"

			echo "Some characters may not have been correctly replaced. Please take a look at the 'to-be-replaced' files in the $ext_file log folder."
		else
			echo "No ext provided"
		fi
	else
		echo "No action provided"
	fi
	echo "Executed $action replacement in $(($(date "+%s")-$replacer_timer)) seconds."
}
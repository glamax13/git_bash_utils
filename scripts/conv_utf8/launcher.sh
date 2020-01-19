#!/bin/bash
function conv {
	#####   Configuration
	local timer_conv_utf8="$(date "+%s")"
	local script_folder="$(dirname ${BASH_SOURCE[0]})"
	local ext_file=""
	local enc_to="utf-8"
	local enc_default="iso-8859-1"
	local verbose=""

	local nb_files=()
	unset nb_files
	declare -A nb_files

	source "$(realpath -s $script_folder/../../global_conf.sh)"
	source "$find_foi"

	### Parameters
	OPTIND=1
	while getopts e:o:d:l:v option
	do
		case ${option}
		in
			e) extension=${OPTARG};;
			o) origin=${OPTARG};;
			d) destination=${OPTARG};;
			l) logs=${OPTARG};;
			v) verbose="true";;
			*) echo "Option not handled!";;
		esac
	done

	### Work
	echo "Processing $extension files..."
	find_foi -t "f" -w "$origin" -e "$extension"
	for file in ${ARR_FOI[@]}
	do
		encod="$(file -b --mime-encoding "$origin/$file")"

		if [ ${nb_files[${encod}]} ]
		then
			nb_files[${encod}]="$((${nb_files[${encod}]}+1))"
		else
			nb_files[${encod}]=1
		fi

		if [ $encod != $enc_to ]
		then
			if [ "$verbose" = "true" -a "$encod" = "binary" ]
			then
				read -p "This file was found to be a binary, do you want to process it? (File: $file): "
				if [[ "$answer" = "" ]] || [[ "$answer" = "y" ]] || [[ "$answer" = "yes" ]] || [[ "$answer" = "o" ]] || [[ "$answer" = "oui" ]]
				then
					encod="$enc_default"
				fi
			else
				encod="$enc_default"
			fi
			if [ "$encod" = "unknown-8bit" ]
			then
				encod="$enc_default"
			fi
			iconv -f "$encod" -t "$enc_to" "$origin/$file" > "$destination/$file"
		else
			cp "$origin/$file" "$destination/$file"
		fi
	done

	for file_type in ${!nb_files[@]}
	do
		echo "${nb_files[${file_type}]} encoded as $file_type."
	done
	echo "Executed conv_utf8 in $(($(date "+%s")-$timer_conv_utf8)) seconds."
}
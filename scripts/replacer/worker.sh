#!/bin/bash
function worker {
	local action=""
	local script=""
	local origin=""
	local destination=""
	local log=""
	local quiet=""
	
	OPTIND=1
	while getopts a:s:o:d:l:q option
	do
		case ${option}
		in
			a) action=${OPTARG};;
			s) script=${OPTARG};;
			o) origin=${OPTARG};;
			d) destination=${OPTARG};;
			l) log=${OPTARG};;
			q) quiet="true";;
			*) echo "Option not handled!";;
		esac
	done
	if [ "$action" = "html" ]
	then
		sed -i.bak 's/&amp;/&/g' "$origin/$file"
	fi

	cat "$file" | sed -f "$sed_script" > "$destination/$file"
	grep -n "{rep}" "$destination/$file" >> "$log/$file.to-be-replaced.log"

	if [ ! $quiet ]
	then
		diff --suppress-common-lines "$destination/$file" "$origin/$file" >> "$log/$file.replaced.log"
	fi
}
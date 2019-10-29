#!/bin/bash

path_script_test="$(dirname ${BASH_SOURCE[0]})"
path_script_test="$(realpath -s $path_script_test)"
path_script_main="$(realpath -s $path_script_test/../launcher.sh)"
path_src="$path_script_test/src"
path_dirty="$path_src/dirty.txt"
path_clean="$path_src/clean.txt"
path_processed=""
test_ext=""
test_lst_ext=()
STATUS=""

content_dirty="$(cat $path_dirty)"
content_clean="$(cat $path_clean)"

OPTIND=1
while getopts e:w: option
do
	case ${option}
	in
		e) test_ext="${OPTARG}";;
		w) echo ${OPTARG};;
		*) echo "Option not handled";;
	esac
done

if [ $test_ext ]
then
	test_lst_ext=( "$test_ext" )
fi

function get_status {
	path_processed="$(realpath -s $path_script_test/../been_conv/$1)"
	file_clean=${1//"dirty"/"clean"}
	path_clean="$(realpath -s $path_src/$file_clean)"
	if [ -e "$path_processed" ]
	then
		content_processed="$(cat $path_processed)"
		content_clean="$(cat $path_processed)"

		if [ "$content_dirty" = "$content_processed" ]
		then
			STATUS="NO_MODIF"
		else
			if [ "$content_clean" = "$content_processed" ]
			then
				STATUS="MATCH"
			else
				STATUS="NO_MATCH"
			fi
		fi
	else
		STATUS="NO_FILE"
	fi
}

cd $path_src

for test_ext in ${test_lst_ext[@]}
do
	$path_script_main "-a" "full" "-w" "$path_src" "-e" "$test_ext"
	find . -name 'dirty.txt' -print0 > TEST_FILE
	
	while IFS=  read -r -d $'\0'; do
		lst_test_file+=("$REPLY")
	done <TEST_FILE
	rm -f test_file
	
	for test_file in  ${lst_test_file[@]}
	do
		get_status $test_file
		echo "$test_file: $STATUS"
	done
done
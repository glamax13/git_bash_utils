#!/bin/bash

path_dirty="./src/dirty.txt"
path_clean="./src/clean.txt"
path_processed="../been_conv/src/dirty.txt"

content_dirty="$(cat $path_dirty)"
content_clean="$(cat $path_clean)"

function is_valid {
	cat $path_processed
	if [ -e "$path_processed" ]
	then
		content_processed="$(cat $path_processed)"

		if [ "$content_dirty" = "$content_processed" ]
		then
			echo "failed. Content hasn't been modified."
		else
			if [ "$content_clean" = "$content_processed" ]
			then
				echo "success. Content does match the clean one."
			else
				echo "failed. Content doesn't match the clean one."
			fi
		fi
	else
		echo "failed. Test didn't went through."
	fi
}

if [ ${#content_dirty[@]} = 0 ] || [ ${#content_clean[@]} = 0 ]
then
	echo "Incorrect testing files. Quitting."
	exit
fi

printf "Test #1a: "
../launcher.sh -a full -w ./src
is_valid
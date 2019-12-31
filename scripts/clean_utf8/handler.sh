#!/bin/bash
function handler {
	if [[ $(($nb_line % 33)) -eq 0 ]]
	then
		wait
		for task in $arr_task
		do
			printf %s\\n "$(cat <&$task)" >> "$to/$file"
			exec {$task}>&-
		done
		arr_task=()
		fd=10
	fi
}
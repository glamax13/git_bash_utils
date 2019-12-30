#!/bin/bash
function worker {
    i=0
    ori=$1
    swap=$1

    while [[ $i -lt $max_comp ]]
    do
        selector="${dirty[$i]}"
        replacer="${clean[$i]}"
        swap="${swap//$selector/$replacer}"
        i=$(($i+1))
    done
    selector="{a_tilda_maj}"
    replacer="Ã"
    swap="${swap//$selector/$replacer}"
    if [ "$ori" != "$swap" ]
    then
		echo -e "$nb_line	$file\n$ori\n$swap" >> "$logs/double_utf8_changes.log"
        if [[ "$swap" =~ "{rep}" ]]
        then
			echo -e "$nb_line	$file\n$ori\n$swap" >> "$logs/double_utf8_to_change.log"
        fi
    fi
    echo "$swap"
}

function handler {
	echo "$nb_line"
	if [[ $(($nb_line % 3)) -eq 0 ]]
	then
		echo "BH"
		while [[ ${#arr_task} -gt 0 ]]
		do
			for task in $arr_task
			do
				echo $task
				pid=${task%:*}
				if ! kill -0 $pid 2>/dev/null
				then
					data=${task#*:}
					fd=${data%:*}
					num=${data#*:}
					arr_res[$num]="$(cat <&$fd)" # Retrieving the task's output
					arr_task="${arr_task[@]/$task,/}" # Removing the task from the list
				fi
			done
		done
	fi
}
#!/bin/bash
function worker {
	verbose=""
	if [ "$1" = "-v" ]
	then
		verbose="true"
		shift
	fi
    
    i=0
    while [ $i -lt ${#arr_line[@]} ]
    do
        line=${arr_line[$i]}
        i=$(($i+1))
        ori=$line
        swap=$line
    
        j=0
        while [[ $j -lt $max_comp ]]
        do
            selector="${dirty[$j]}"
            replacer="${clean[$j]}"
            swap="${swap//$selector/$replacer}"
            j=$(($j+1))
        done
        selector="{a_tilda_maj}"
        replacer="Ã"
        swap="${swap//$selector/$replacer}"
        if [ "$ori" != "$swap" ]
        then
            echo "$(echo "$nb_line	$file"; echo "$ori"; echo "$swap")" >> "$logs/double_utf8_changes.log"
            if [[ "$swap" =~ "{rep}" ]]
            then
                echo "$(echo "$nb_line	$file"; echo "$ori"; echo "$swap")" >> "$logs/double_utf8_to_change.log"
            fi
        fi
        echo "$swap"
    done
}
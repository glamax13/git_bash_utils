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
    printf %s\\n "$swap"
}
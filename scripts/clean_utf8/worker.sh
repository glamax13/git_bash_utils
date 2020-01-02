#!/bin/bash
function worker {
    i=0
    arr_output=()
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
            echo -e "$nb_line	$file\n$ori\n$swap" >> "$logs/double_utf8_changes.log"
            if [[ "$swap" =~ "{rep}" ]]
            then
                echo -e "$nb_line	$file\n$ori\n$swap" >> "$logs/double_utf8_to_change.log"
            fi
        fi
        echo "$swap"
    done
}
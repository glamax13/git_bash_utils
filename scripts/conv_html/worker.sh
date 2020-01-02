#!/bin/bash

function worker {
    i=0
    while [ $i -lt ${#arr_line[@]} ]
    do
        line=${arr_line[$i]}
        i=$(($i+1))
		ori=$line
		swap=$line
		
		if [[ $swap =~ "&" ]]
		then
			selector="&amp;"
			replacer="&"
			swap=${swap//$selector/$replacer}

			j=0
			while [[ $j -lt ${#clean[@]} ]]
			do
				selector=${dirty[$j]}
				replacer=${clean[$j]}
				swap=${swap//$selector/$replacer}
				j=$(($j+1))
			done

			if [ "$ori" != "$swap" ]
			then
				if [[ $swap =~ "{apos}" ]]
				then
					echo "$num_line          $file" >> ~/conv/log/html_to_changes.log
					echo "$ori" >> $logs/html_to_changes.log
					echo "$swap" >> $logs/html_to_changes.log
				fi
				echo "$num_line          $file" >> $logs/html_changes.log
				echo "$ori" >> $logs/html_changes.log
				echo "$swap" >> $logs/html_changes.log
			else
				echo "$ori" >> $logs/html_detect.log
			fi
		fi
		echo "$swap"
	done
}
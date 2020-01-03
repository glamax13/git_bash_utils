#!/bin/bash
# Notice: values from main process are duplicated for the subprocess. Changes in main won't affect sub after seperation.
# File descriptors are also duplicated from main by default HOWEVER this behaviour has been bypassed in main by {fd}<subprocess.
function worker {
    i=0
    while [ $i -lt ${#arr_line[@]} ]				#Looping over lines that have been attributed to this process
    do
        line=${arr_line[$i]}
        i=$(($i+1))
		ori=$line
		swap=$line
		
		if [[ $swap =~ "&" ]]						#Searching for "&" as it is required in all HTML characters. Character may be encoded without ";" so we won't take it in account.
		then
			selector="&amp;"
			replacer="&"
			swap=${swap//$selector/$replacer}		#Encoding characteres twice will also encode the "&" from previously encoded characters

			j=0
			while [[ $j -lt ${#clean[@]} ]]			#Looping over all known HTML characters
			do
				selector=${dirty[$j]}
				replacer=${clean[$j]}
				swap=${swap//$selector/$replacer}	#Trying to replace all occurence of the character
				j=$(($j+1))
			done

			if [ "$ori" != "$swap" ]				#Logging changes
			then
				if [[ $swap =~ "{apos}" ]]
				then
					echo "$(echo "$(($num_line+$i))          $file"; echo "$ori"; echo "$swap")" >> ~/conv/log/html_to_changes.log
				fi
				echo "$(echo "$(($num_line+$i))          $file"; echo "$ori"; echo "$swap")"	>> $logs/html_changes.log
			else									#Logging the fact that an "&" has been found and might be a character that failed to be replaced
				echo "$(($num_line+$i))	$ori"	>> $logs/html_detect.log
			fi
		fi
		echo "$swap"								#Outputing processed lines
	done
}
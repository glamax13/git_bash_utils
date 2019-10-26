#!/bin/bash
# Author : Teddy Skarin

# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)
function ProgressBar {
	_pg_message=""
	# Process data
	_progress=(${1}*100/${2}*100)/100
	_done=(${_progress}*4)/10
	_left=40-$_done
	# Build progressbar string lengths
	_done=$(printf "%${_done}s")
	_left=$(printf "%${_left}s")
	# 1.2 Build progressbar strings and print the ProgressBar line
	_pg_message="\rProgress ($3) : [${_done// /#}${_left// /-}] ${_progress}%%"
	
	if [ $_progress = 100 ]
	then
		_pg_message="$_pg_message Done with $3."
	fi
	printf "$_pg_message"
}
# Author : Teddy Skarin

# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)
function ProgressBar {
	_pg_current_val=$1
	_pg_max_val=$2
	_pg_file=$3
	_pg_progress=0
	_pg_done=0
	_pg_left=0
	_pg_message=""


	# Process data
	_pg_progress=$(((${_pg_current_val}*100/${_pg_max_val}*100)/100))
	_pg_done=$(((${_progress}*4)/10))
	_pg_left=$((40-$_done))
	# Build progressbar string lengths
	_pg_done=$(printf "%${_done}s")
	_pg_left=$(printf "%${_left}s")
	# 1.2 Build progressbar strings and print the ProgressBar line
	_pg_message="Progress ($_pg_file) : [${_done// /#}${_left// /-}] ${_progress}%%"
	
	printf "\r$_pg_message"
	
	if [ $_pg_progress = 100 ]
	then
		printf "  Done with $_pg_file.\n"
	fi
}
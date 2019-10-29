function parse_fold {
	search_from=$1
	search_file=$2
	search_needle=$3
	search_logs=$4
    search_msg=""
	content=$(cat "$search_from/$search_file")
	if [[ "${content,,}" =~ "${search_needle,,}" ]]
	then
		echo "$search_file" >> "$search_logs/PARSED_FOLD"
	fi
}
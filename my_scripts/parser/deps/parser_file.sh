function parse_file {
	search_from=$1
	search_file=$2
	search_needle=$3
	search_logs=$4
    search_num=0
    search_line=""
	

    while IFS=$' \t\n\r' read -r search_line || [ -n "$search_line" ]
    do
        if [[ "$search_needle" =~ "$search_line" ]]
        then
            echo "$search_num: $search_line" >> "$search_logs/PARSED_LINE" 
        fi
        search_num=$(($search_num+1))
    done <"$search_from/$search_file"
}
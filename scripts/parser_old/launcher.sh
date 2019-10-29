#!/bin/bash
ext_file=""
needle=""
from=""
logs=""
lst_files=()

function search {
	num_thread=$1
	search_from=$2
	search_file=$3
	search_needle=$4
	search_logs=$5
	
	content=$(cat "$search_from/$search_file")
	if [[ "$content" =~ "$search_needle" ]]
	then
		echo "Found $search_needle in $search_file"
		echo "Found $search_needle in $search_file" >> "$logs/parser.log"
	fi
}

function find_foi {
	OPTIND=1
	while getopts t:w:e: option
	do
		case ${option}
		in
			e) find_ext=${OPTARG};;
			w) find_where=${OPTARG};;
			t) find_type=${OPTARG};;
			*) echo "option not handled"
		esac
	done
	folder_ori="$(pwd)"
	find_ext="*$find_ext"
	ARR_FOI=()
	cd "$find_where"
	
	find \. \
		-name "*${find_ext}" \
		\! \( \
			-path '*/.git/*' \
			-o -path '*/.idea/*' \
			-o -path '*/ckeditor/*' \
			-o -path '*/.vscode/*' \
			-o -path '*/newsletter/*' \
			-o -path '*/vendor/*' \
			-o -name '.gitignore' \
			-o -name '.gitkeep' \
			-o -name 'FILE_FOI' \
			-o -name '.' \) \
		-type "${find_type}" \
				-print0 >FILE_FOI

	while IFS=  read -r -d $'\0'; do
		ARR_FOI+=("$REPLY")
	done <FILE_FOI
	rm -f FILE_FOI

	cd "$folder_ori"
}

#Parameters
OPTIND=1
while getopts e:n:f:l: option
do
    case ${option}
    in
        e) ext_file=${OPTARG};;
		n) needle=${OPTARG};;
        f) from=${OPTARG};;
        l) logs=${OPTARG};;
        *) echo "Option not handled!";;
    esac
done

if [ $ext_file ]
then
	find_foi -e "$ext_file" -w "$from" -t "f"
	lst_files=( "${ARR_FOI[@]}" )
    i=0
    for file in ${lst_files[@]}
    do	
		if [ $i = 5 ]
		then
			i=0
			wait
		fi
        search $i $from $file $needle $logs &
		i=$(($i+1))
	done
else
	echo "No ext provided!"
fi
wait
echo "Done! Results can be found at $logs/parser.log"
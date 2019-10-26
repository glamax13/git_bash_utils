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
		-name "${find_ext}" \
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
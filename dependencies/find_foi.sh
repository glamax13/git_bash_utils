function find_foi {
	_ff_ori="$(pwd)"
	_ff_where="."
	_ff_ext="*"
	_ff_type="f"
	ARR_FOI=()
	
	OPTIND=1
	while getopts t:w:e: option
	do
		case ${option}
		in
			e) _ff_ext=${OPTARG};;
			w) _ff_where=${OPTARG};;
			t) _ff_type=${OPTARG};;
			*) echo "option not handled"
		esac
	done
	
	_ff_ext="*$_ff_ext"


	cd "$_ff_where"
	find \. \
		-name "${_ff_ext}" \
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
			-o -name '\.' \) \
		-type "${_ff_type}" \
				-print0 >FILE_FOI

	while IFS=  read -r -d $'\0'; do
		ARR_FOI+=("$REPLY")
	done <FILE_FOI
	rm -f FILE_FOI

	cd "$_ff_ori"
}
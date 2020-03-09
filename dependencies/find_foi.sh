function find_foi() {
	local ori="$PWD"
	local where="."
	local ext="*"
	local type="f"
	ARR_FOI=()

	OPTIND=1
	while getopts w:t:e: option; do
		case ${option} in

		w) where=${OPTARG} ;;
		t) type=${OPTARG} ;;
		e) ext=${OPTARG} ;;
		*) echo "option not handled" ;;
		esac
	done

	ext="*$ext"

	#TODO dynamique regex exclusion
	cd "$where"
	find \. \
	-name "${ext}" \
	\! \( \
	-path '*/.git/*' \
	-o -path '*/.idea/*' \
	-o -path '*/ckeditor/*' \
	-o -path '*/.vscode/*' \
	-o -path '*/newsletter/*' \
	-o -path '*/vendor/*' \
	-o -path '*/*ffichettes*/*' \
	-o -path '*/docandmatsh/*' \
	-o -name '.gitignore' \
	-o -name '.gitkeep' \
	-o -name 'FILE_FOI' \
	-o -name '\.' \) \
	-type "${type}" \
	-print0 >FILE_FOI

	while IFS= read -r -d $'\0'; do
		ARR_FOI+=("$REPLY")
	done <FILE_FOI
	rm -f FILE_FOI

	cd "$ori"
}

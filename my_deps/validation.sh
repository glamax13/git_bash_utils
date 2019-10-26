
function validation {
	message=""
	valid_answer=""
	
	OPTIND=1
	while getopts m: option
	do
		case ${option}
		in
			m) message=${OPTARG}
		esac
	done
	read -p "$message? (Y/n): " valid_answer
    valid_answer="${valid_answer,,}"
	if [[ "$valid_answer" = "" ]] || [[ "$valid_answer" = "y" ]] || [[ "$valid_answer" = "yes" ]] || [[ "$valid_answer" = "o" ]] || [[ "$valid_answer" = "oui" ]]
	then
		VALID="true"
	else
		VALID=""
	fi
}
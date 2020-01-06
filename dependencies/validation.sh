
function validation {
	local message=""
	local answer=""
	VALID="false"
	
	OPTIND=1
	while getopts m: option
	do
		case ${option}
		in
			m) message=${OPTARG}
		esac
	done

	while [ "$VALID" = "false" ]
	do
		read -p "$message? (Y/n): " answer
		answer="${answer,,}"
		if [[ "$answer" = "y" ]] || [[ "$answer" = "yes" ]] || [[ "$answer" = "o" ]] || [[ "$answer" = "oui" ]] || [[ "$answer" = "" ]]
		then
			VALID="true"
		elif [[ "$answer" = "n" ]] || [[ "$answer" = "no" ]] || [[ "$answer" = "non" ]]
		then
			VALID=""
		else
			echo "Invalid answer : $answer. Please try again with yes or no."
			VALID="false"
		fi
	done
}
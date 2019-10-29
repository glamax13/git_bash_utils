
function validation {
	_v_message=""
	_v_answer=""
	VALID="false"
	
	OPTIND=1
	while getopts m: option
	do
		case ${option}
		in
			m) _v_message=${OPTARG}
		esac
	done

	while [ "$VALID" = "false" ]
	do
		read -p "$_v_message? (Y/n): " _v_answer
		_v_answer="${_v_answer,,}"
		if [[ "$_v_answer" = "y" ]] || [[ "$_v_answer" = "yes" ]] || [[ "$_v_answer" = "o" ]] || [[ "$_v_answer" = "oui" ]] || [[ "$_v_answer" = "" ]]
		then
			VALID="true"
		elif [[ "$_v_answer" = "n" ]] || [[ "$_v_answer" = "no" ]] || [[ "$_v_answer" = "non" ]]
		then
			VALID=""
		else
			echo "Invalid answer : $_v_answer. Please try again with yes or no."
			VALID="false"
		fi
	done
}
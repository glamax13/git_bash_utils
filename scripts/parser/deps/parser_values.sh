function parse_values {
	_se_lst_unique=($(echo "${_se_lst_all[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
}

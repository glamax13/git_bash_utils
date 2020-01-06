function make_arr {
    _am_file_path="$1"
    MAKE_ARR_RET=()

    while IFS=$' \t\n\r' read -r value || [ -n "$value" ]
    do
        MAKE_ARR_RET+=("$value")
        _am_nb_val=$(($nb_val+1))
    done <$_am_file_path
}
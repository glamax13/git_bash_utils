function make_arr {
    nb_val=0
    file_path="$1"
    MAKE_ARR_RET=()

    while IFS=$' \t\n\r' read -r value || [ -n "$value" ]
    do
        MAKE_ARR_RET+=("$value")
        nb_val=$(($nb_val+1))
    done <$file_path

    echo "Retrieved $nb_val values."
}
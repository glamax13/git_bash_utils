function select_ext {
    source "$validation"
    local origin="."
    local cut_ext=""
    local lst_all=()
    local lst_unique=()
    LST_EXTENSION=()

    #Parameters
    OPTIND=1
    while getopts f: option
    do
        case ${option}
        in
            f) origin=${OPTARG};;
            *) echo "Option not handled!";;
        esac
    done

    find_foi -e "*" -w "$origin" -t "f"
    for ext_file in ${ARR_FOI[@]}
    do
        cut_ext="${ext_file##*.}"
        if [[ "$cut_ext" =~ "/" ]]
        then
            :
        else
            lst_all+=( "$_se_cut_ext" )
        fi
    done
    lst_unique=($(echo "${_se_lst_all[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
    
    for ext in ${_se_lst_unique[@]}
    do
		validation -m "Include files with $ext extension"
        if [ $VALID ]
        then
            LST_EXTENSION+=( "$ext" )
        fi
    done
}
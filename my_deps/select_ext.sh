
source "$validation"
function select_ext {
    sel_ext_from="."
    cut_ext=""
    lst_all_ext=()
    lst_unique_ext=()
    LST_EXTENSION=()

    #Parameters
    OPTIND=1
    while getopts f: option
    do
        case ${option}
        in
            f) sel_ext_from=${OPTARG};;
            *) echo "Option not handled!";;
        esac
    done

    find_foi -e "*" -w "$sel_ext_from" -t "f"
    for ext_file in ${ARR_FOI[@]}
    do
        cut_ext="${ext_file##*.}"
        if [[ "$cut_ext" =~ "/" ]]
        then
            :
        else
            lst_all_ext+=( "$cut_ext" )
        fi
    done
    lst_unique_ext=($(echo "${lst_all_ext[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
    
    for ext in ${lst_unique_ext[@]}
    do
		validation -m "Include files with $ext extension?"
        if [ $VALID ]
        then
            LST_EXTENSION+=( "$ext" )
        fi
    done
}
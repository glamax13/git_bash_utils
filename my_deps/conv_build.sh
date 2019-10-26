function make_build {
    from="$1"
    to="$2"
    nb_folder=0
    find_foi -e "*" -w "$from" -t "d"
    for folder in ${ARR_FOI[@]}
    do
        mkdir "$to/$folder"
        nb_folder=$(($nb_folder+1))
    done
}

function files_build {
    find_foi -e "$1" -w "$2" -t "f"
    for sel_file in ${ARR_FOI[@]}
    do
        cp "$2/$sel_file" "$3/$sel_file"
    done
}

function copy_build {
    for dir in $1
    do
        cp "$dir/*" "$2/$(basename $dir)"
    done
}

function apply_build {
    find_foi -e "*" -w "$1" -t "f"
    for f_ow in ${ARR_FOI[@]}
    do
        mv "$1/$f_ow" "$2/$f_ow"
    done
}

function clean_build {
    rm -rf "$1"
    mkdir "$1"
}
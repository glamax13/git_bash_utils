function make_build {
    _mb_from="$1"
    _mb_to="$2"
    _mb_folder=""

    rm -rf "$_mb_to"
    mkdir "$_mb_to"

    find_foi -e "*" -w "$_mb_from" -t "d"
    for _mb_folder in ${ARR_FOI[@]}
    do
        mkdir "$_mb_to/$_mb_folder"
    done
}

function files_build {
    _fb_find_ext="$1"
    _fb_from="$2"
    _fb_to="$3"
    _fb_sel_file=""

    find_foi -e "$_fb_find_ext" -w "$_fb_from" -t "f"
    for _fb_sel_file in ${ARR_FOI[@]}
    do
        cp "$_fb_from/$_fb_sel_file" "$_fb_to/$_fb_sel_file"
    done
    echo "Found ${#ARR_FOI[@]} original files."
}

function apply_build {
    _ab_from=$1
    _ab_to=$2
    _ab_file=""

    find_foi -e "*" -w "$_ab_from" -t "f"
    for _ab_file in ${ARR_FOI[@]}
    do
        mv "$_ab_from/$_ab_file" "$_ab_to/$_ab_file"
    done
}
#Copy folder and subfolder from origin to destination
function make_build {
    local origin="$1"
    local destination="$2"

    rm -rf "$destination"
    mkdir "$destination"

    find_foi -e "*" -w "$origin" -t "d"
    for build_folder in ${ARR_FOI[@]}
    do
        mkdir "$destination/$build_folder"
    done
}

#Copy files from origin to destination in there proper folder
function files_build {
    local find_ext="$1"
    local origin="$2"
    local destination="$3"

    find_foi -e "$find_ext" -w "$origin" -t "f"
    for build_file in ${ARR_FOI[@]}
    do
        cp "$origin/$build_file" "$destination/$build_file"
    done
}

#Overwrite file from origin to destination
function apply_build {
    local origin=$1
    local destination=$2
    
    find_foi -e "*" -w "$_ab_from" -t "f"
    for build_file in ${ARR_FOI[@]}
    do
        mv "$origin/$build_file" "$destination/$build_file"
    done
}
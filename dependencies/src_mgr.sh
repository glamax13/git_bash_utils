#Copy folder and subfolder from origin to destination
function dup_folders {
    local origin="$1"
    local destination="$2"

    rm -rf "$destination"
    mkdir "$destination"

    find_foi -w "$origin" -t "d" -e "*"
    for build_folder in ${ARR_FOI[@]}
    do
        mkdir "$destination/$build_folder"
    done
}

#Copy files from origin to destination in there proper folder
function dup_files {
    local origin="$1"
    local destination="$2"
    local find_ext="$3"

    find_foi -w "$origin" -t "f" -e "$find_ext"
    for build_file in ${ARR_FOI[@]}
    do
        cp "$origin/$build_file" "$destination/$build_file" &
    done
    wait
}

#Overwrite file from origin to destination
function merge_changes {
    local origin=$1
    local destination=$2
    
    find_foi -w "$origin" -t "f" -e "*"
    for build_file in ${ARR_FOI[@]}
    do
        mv "$origin/$build_file" "$destination/$build_file" &
    done
    wait
}
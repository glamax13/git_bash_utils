#!/bin/bash
###Provides dependencies locations and settings to the modules

#Default paths
path_root="$(dirname ${BASH_SOURCE[0]})"
path_root="$(realpath -s $path_root)"

path_deps="$path_root/dependencies"
path_scripts="$path_root/scripts"

#Dependencies
progress_bar="$path_deps/progress_bar.sh"
src_mgr="$path_deps/src_mgr.sh"
find_foi="$path_deps/find_foi.sh"
arr_maker="$path_deps/arr_maker.sh"
validation="$path_deps/validation.sh"
select_ext="$path_deps/select_ext.sh"

#Scripts
conv_utf8="$path_scripts/conv_utf8/launcher.sh"
clean_utf8="$path_scripts/clean_utf8/launcher.sh"
conv_html="$path_scripts/conv_html/launcher.sh"
replacer="$path_scripts/replacer/launcher.sh"
parser="$path_scripts/parser/launcher.sh"
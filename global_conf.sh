#!/bin/bash
###Provides dependencies locations and settings to the modules

#Default paths
path_root="$(dirname ${BASH_SOURCE[0]})"
path_root="$(realpath -s $path_root)"

path_deps="$path_root/dependencies"
path_scripts="$path_root/scripts"

path_to_logs="$path_root/logs"
path_to_conv="$path_root/to_conv"
path_been_conv="$path_root/been_conv"

#Dependencies
progress_bar="$path_deps/progress_bar.sh"
conv_build="$path_deps/conv_build.sh"
find_foi="$path_deps/find_foi.sh"
arr_maker="$path_deps/arr_maker.sh"
validation="$path_deps/validation.sh"
select_ext="$path_deps/select_ext.sh"

#Scripts
clean_utf8="$path_scripts/clean_utf8/launcher.sh"
conv_utf8="$path_scripts/conv_utf8/launcher.sh"
conv_html="$path_scripts/conv_html/launcher.sh"
parser="$path_scripts/parser/launcher.sh"
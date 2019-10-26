#!/bin/bash
path_root="$(dirname ${BASH_SOURCE[0]})"

path_deps="$path_root/my_deps"
path_scripts="$path_root/my_scripts"

path_to_logs="$path_root/my_logs"
path_to_conv="$path_root/to_conv"
path_been_conv="$path_root/been_conv"

path_my_scripts="$path_root/my_scripts"

clean_utf8="$path_scripts/clean_utf8/clean_utf8.sh"
conv_utf8="$path_scripts/conv_utf8/conv_utf8.sh"
conv_html="$path_scripts/conv_html/conv_html.sh"

#Dependencies
progress_bar="$path_deps/progress_bar.sh"
conv_build="$path_deps/conv_build.sh"
find_foi="$path_deps/find_foi.sh"
arr_maker="$path_deps/arr_maker.sh"
validation="$path_deps/validation.sh"
select_ext="$path_deps/select_ext.sh"
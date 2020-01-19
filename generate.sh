#!/bin/bash
script_folder="$(dirname ${BASH_SOURCE[0]})"
source "$(realpath -s $script_folder/global_conf.sh)"
source "$arr_maker"


#		Comparisson arrays
arr_ref_chars=("desi" "code" "extra")			#	Reference files names 
for rep_type in ${arr_ref_chars[@]}
do
	make_arr "/home/glamax-13/Smithy/repos_center/git_bash_utils/scripts/replacer_legacy/html/src/$rep_type-clean.regist"; clean=( "${clean[@]}" "${MAKE_ARR_RET[@]}" )
	make_arr "/home/glamax-13/Smithy/repos_center/git_bash_utils/scripts/replacer_legacy/html/src/$rep_type-dirty.regist"; dirty=( "${dirty[@]}" "${MAKE_ARR_RET[@]}" )
done
echo "${#clean[@]} and ${#dirty[@]}"
j=0
while [ $j -lt ${#clean[@]} ]			#Looping over all known HTML characters
do
	selector=${dirty[$j]}
	replacer=${clean[$j]}
	echo "s/$selector/$replacer/g" >> "html_ref.sed"
	j=$(($j+1))
done
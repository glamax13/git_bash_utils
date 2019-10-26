#!/bin/bash

function contains {
    if [ $encod = 'utf-8' ]
    then
        :
    else
        echo "!$1!            $file" >> ~/my_scripts/list_encod_b.txt
    fi
}

for file in $(find \. -type f \! \( -path '*.git/*' -o -path '*.idea/*' \))
do
    encod=$(file -b --mime-encoding $file)
    echo $encod
    contains $encod
done
#!/bin/bash

for file in `find *`; do
	echo "$(date -r "$file" | cut -d " " -f 2-4) ${file}"
done

if [[ ! -e 2018111023.txt ]]; then
	touch "2018111023.txt"
fi

IFS=':' read -r -a arr <<< "$PATH"

for loc in "${arr[@]}"; do
	for file in $loc/*; do
		com=$(echo "$file" | cut -d"/" -f4)
		if [[ "$com" =~	^lo ]]; then
			printf "${com}: $(man -f ${com} | cut -d" " -f 13-)\n" >> 2018111023.txt
		fi
	done
done

echo "Max Line Length: $(wc -L 2018111023.txt | cut -d " " -f 1)"
echo "Line count: $(wc -l 2018111023.txt | cut -d " " -f 1)"

sed -i -e "s/function/method/g" 2018111023.txt


#!/bin/bash

maxLineLength=0

for file in *; do
	echo "$(date -r "$file" | cut -d " " -f 2-4) ./${file}"
done

if [[ ! -e 2018111023.txt ]]; then
	touch "2018111023.txt"
fi

coms="$(compgen -c "lo")"
echo "$coms" > 2018111023.txt

while read -r line || [[ -n "$line" ]]; do
	char_count="$(echo "${line}" | wc -c)"
	if [[ "$maxLineLength" < "$char_count" ]]; then
		maxLineLength="$char_count"
	fi
done < 2018111023.txt
# for file in /usr/bin/*; do
# 	doced_file="$(echo $file | cut -d "/" -f 4)"
# 	if [[ $doced_file == lo* ]]; then
# 		char_count_file_name="$(echo "$doced_file" | wc -c)"
# 		if [ "$maxLineLength" -lt "$char_count_file_name" ]; then
# 			maxLineLength="$char_count_file_name"
# 		fi
# 		printf "${doced_file}\n" >> 2018111023.txt
# 	fi
# done

echo "Max Line Length: ${maxLineLength}"
echo "Line count: $(wc -l 2018111023.txt | cut -d " " -f 1)"

## under repair start

sed -i -e "s/function/method/g" 2018111023.txt

## under repair end

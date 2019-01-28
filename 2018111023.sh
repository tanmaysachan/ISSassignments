#!/bin/bash

movie_ratings_path="$1"
all_movies_path="$2"

if [[ "$all_movies_path" =~ /$ ]]; then
	all_movies_path=${all_movies_path:0:$((${#all_movies_path}-1))}
fi

mkdir $all_movies_path/Bad
mkdir $all_movies_path/Average
mkdir $all_movies_path/Good
mkdir $all_movies_path/Awesome

for file in $all_movies_path/*; do
	if [[ "$file" =~ .mp4$ ]]; then
		file_name=$(echo "$file" | cut -d "." -f 1 | cut -d "/" -f 5)
		rating=$(grep "$file_name" $movie_ratings_path | cut -d ":" -f 2)
		echo $file_name
		echo $rating
		if [[ $rating < 5  ]]; then
			mv "$file" "${all_movies_path}/Bad/"
		elif [[ $rating < 8 ]]; then
			mv "$file" "${all_movies_path}/Average/"
		elif [[ $rating < 9 ]]; then
			mv "$file" "${all_movies_path}/Good/"
		else
			mv "$file" "${all_movies_path}/Awesome/"
		fi
	fi
done


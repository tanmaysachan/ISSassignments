#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Welcome to the Song Diary!"
	echo "A tool to keep track of your songs."
	echo
	echo "Use the -h flag for help"
	exit 1
fi

# global vars

song_name="NULL"
song_name_orig=""
artist=""
artist_orig=""
genre=""
genre_orig=""
yt_link=""
yt_link_orig=""
searched_song="NULL"
search_count=0
header="|----Song-name----||-----artist------||------genre------||-----yt_link-----"
delete_successful=0
id=0

#############

if [[ ! -e ~/SongDiary/cache ]]; then
	mkdir -p ~/SongDiary
	touch ~/SongDiary/cache
fi

# functions declarations go here

print_usage() {
	printf "Usage -s flag for adding the song name\n"
	printf "           (mandatory for adding songs)\n"
	printf "      -a flag for adding the artist\n"
	printf "      -g flag for adding the genre\n"
	printf "      -y flag for adding the youtube link\n"
	printf "      -l flag to list all existing songs\n"
	printf "      -d flag for deleting a song, takes song name as argument\n"
	printf "      -e flag for editing an entry, takes song ID as argument\n"
	printf "      -S flag for searching, takes pattern as an argument\n"
	printf "                  (returns all songs matching the pattern)\n"
	printf "      -D flag for resetting the diary (warning: deletes all entries)\n"
	printf "\n"
	printf "*Use quotes(\"\") when passing space separated arguments\n"
	printf "\nExample usage:\n"
	printf "./script.sh -s \"hello\" -a \"adele\" -g \"pop\" -y \"https://www.youtube.com/watch?v=YQHsXMglC9A\"\n"
	printf "Adds the song Hello, by Adele to the diary\n"
}

gen_id() {
	id=$(("$(wc -l ~/SongDiary/cache | cut -d" " -f 1)"+1))
}

fix_ids() {
	touch ~/SongDiary/tmpcache
	local tmp=0
	while read -r line || [[ -n "$line" ]]; do
		IFS=',' read -r -a arr <<< "$line"
		tmp=$(($tmp+1))
		if [[ "${arr[4]}" != "$tmp" ]]; then
			arr[4]="$tmp"
		fi
		echo "${arr[0]},${arr[1]},${arr[2]},${arr[3]},${arr[4]}" >> ~/SongDiary/tmpcache	
	done < ~/SongDiary/cache
	mv ~/SongDiary/tmpcache ~/SongDiary/cache
}

reset_songs() {
	read -p "Confirm action? [y/N] " c
	if [[ "$c" == [yY] || "$c" == [yY][eE][sS] ]]; then
		echo
	else
		echo "Aborted"
		exit 0
	fi
	echo "Resetting song diary..."
	if [[ -e ~/SongDiary/cache ]]; then
		rm ~/SongDiary/cache
		touch ~/SongDiary/cache
	fi
	echo "Done!"
}

delete() {
	local arg="$1"
	local flag=0
	while read -r line || [[ -n "$line" ]]; do
		#echo "$line"
		IFS=',' read -r -a arr <<< "$line"
		#echo "${arr[0]}"
		if [[ "${arr[0]}" =~ "${arg}" ]]; then
			flag=1
			echo "***${arr[0]}***"
			read -p "Delete this song? [y/N] " c </dev/tty
			if [[ "$c" == [yY] || "$c" == [yY][eE][sS] ]]; then
				printf "\n"
				echo "Deleting..."
				
				#single command used for deletion (sed)

				sed -i "/${line}/d" ~/SongDiary/cache

				#######################################
				delete_successful=1
				printf "Done!\n"
			else
				printf "Aborted\n"
			fi
		fi
	done < ~/SongDiary/cache
	if [[ "$flag" == 0 ]]; then
		echo "Song not found."
	fi
	fix_ids
}

update_list() {
	tmp=1
	while read -r line || [[ -n "$line" ]]; do
		IFS=',' read -r -a arr <<< "$line"
		song_name=${arr[0]}
		artist=${arr[1]}
		genre=${arr[2]}
		yt_link=${arr[3]}
		id=${arr[4]}
		id_e="$id"
		if [ ${#song_name} -gt 14 ]; then
			song_name="|${song_name:0:14}...|"
		else
			space_left=$((18-${#song_name}-1))
			song_name=$(printf "%s%*s" "$song_name" $space_left " ")
			song_name="|${song_name}|"
		fi

		if [ ${#artist} -gt 14 ]; then
			artist="|${artist:0:14}...|"
		else
			space_left=$((18-${#artist}-1))
			artist=$(printf "%s%*s" "$artist" $space_left " ")
			artist="|${artist}|"
		fi

		if [ ${#genre} -gt 14 ]; then
			genre="|${genre:0:14}...|"
		else
			space_left=$((18-${#genre}-1))
			genre=$(printf "%s%*s" "$genre" $space_left " ")
			genre="|${genre}|"
		fi

		if [ ${#yt_link} -gt 0 ]; then
			yt_link="|${yt_link}"
		else
			yt_link="|${yt_link}"
		fi

		if [ "$tmp" -eq 1 ] && [ "$1" -eq 1 ]; then
			if [[ "$(($(wc -l ~/SongDiary/cache | cut -d" " -f1)))" -lt 10 ]]; then
				echo "ID|${header}"
			else
				echo "ID|${header}"
			fi
			tmp=0
		fi

		if [[ "$(($(wc -l ~/SongDiary/cache | cut -d" " -f1)))" -lt 10 ]]; then
			id_e=" ${id}|"		
		else
			if [ "$id" -lt 10 ]; then
				id_e=" ${id}|"
			else
				id_e="${id}|"
			fi
		fi
		
		if [ "$1" -eq 1 ]; then
			echo "${id_e}${song_name}${artist}${genre}${yt_link}"
		fi
	done < ~/SongDiary/cache
}

list_all_songs() {
	if [ "$(wc -l < ~/SongDiary/cache)" -eq 0 ]; then
		echo "Diary is empty."
		exit 0
	fi
	update_list 1
}

search_songs() {
	local arg="$1"
	local flag=0
	while read -r line || [[ -n "$line" ]]; do
		if [[ "$line" =~ "$arg" ]] && [[ "$3" == 0 ]]; then
			if [[ "$flag" -eq 0 ]]; then
				echo "Search results:"
				flag=1
			fi
			searched_song="$line"
			search_count=$(($search_count+1))
			IFS=',' read -r -a arr <<< "$line"
			for elem in "${arr[@]}"; do
				if [[ "$elem" == "" ]]; then
					elem="NIL"
				fi
			done
			echo "id: ${arr[4]}, song-name: ${arr[0]}, artist: ${arr[1]}, genre: ${arr[2]}, yt_link: ${arr[3]}"
		fi
		IFS=',' read -r -a arr <<< "$line"
		if [[ "${arr[0]}" == "$arg" ]] && [[ "$3" == 1 ]]; then
			if [[ "$flag" == 0 ]]; then
				echo "Search results:"
				flag=1
			fi
			searched_song="$line"
			search_count=$(($search_count+1))
			IFS=',' read -r -a arr <<< "$line"
			echo "id: ${arr[4]}, song-name: ${arr[0]}, artist: ${arr[1]}, genre: ${arr[2]}, yt_link: ${arr[3]}"
		fi
	done < ~/SongDiary/cache
	if [ "$flag" -eq 0 ] && [ "$2" -eq 1 ]; then
		echo "No results found."
	fi
}

edit_song() {
	local arg="$1"
	read -p "Enter the field you want to edit(1, 2, 3, 4 for Song name, artist, genre, yt link
	respectively): " field
	read -p "Enter its new value: " new_val
	field=$((field-1))
	song=$(grep -E ",${arg}$" ~/SongDiary/cache)
	IFS=',' read -r -a arr <<< "$song"
	arr[$field]="$new_val"
	sed -i "/,${arg}$/d" ~/SongDiary/cache
	echo "${arr[0]},${arr[1]},${arr[2]},${arr[3]},${arr[4]}" >> ~/SongDiary/cache
	fix_ids
	echo "Song edited successfully"
	exit 0
}

# function declarations end here

# handling flags



while getopts 'ls:a:g:y:hDd:S:e:' flag; do
	case "${flag}" in
		l) list_all_songs; exit;;
		s) song_name="${OPTARG}" ;;
		a) artist="${OPTARG}" ;;
		g) genre="${OPTARG}" ;;
		y) yt_link="${OPTARG}" ;;
		e) edit_song "${OPTARG}" ;;
		S) search_songs "${OPTARG}" 1 0; exit;;
		d) delete "${OPTARG}"; exit;;
		D) reset_songs; exit;;
		h) print_usage; exit;;
	esac
done

################

if [[ ${song_name} == "NULL" ]]; then
	echo "Use -s {song-name} flag for the song name"
	exit 1
fi

song_name_orig="$song_name"
artist_orig="$artist"
genre_orig="$genre"
yt_link_orig="$yt_link"

searched_song="NULL"

search_songs "${song_name_orig}" 0 1

if [[ "$searched_song" == "NULL" ]]; then
	echo
else
	echo
	echo "Song already in diary. Skipping..."
	exit 1
fi

gen_id

# appending song to cache

echo "${song_name_orig},${artist_orig},${genre_orig},${yt_link_orig},${id}" >> ~/SongDiary/cache

printf "\n"

echo "|----Song-Info----|"
printf "Song name:    ${song_name}\n"
printf "Artist:       ${artist}   \n"
printf "Genre:        ${genre}    \n"
printf "Youtube link: ${yt_link}  \n"

# updating list

update_list 0

printf "\nSong added successfully!\n"
exit 0

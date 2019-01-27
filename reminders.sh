#!/bin/bash

if [[ $# == 0  ]]; then
	echo "Welcome to the terminal-reminders app"
	echo
	echo "Run the command with -h flag for help"
	exit 0
fi

if [[ ! -e ~/Reminders/cache  ]]; then
	mkdir -p ~/Reminders
	touch ~/Reminders/cache
fi

## global vars go here

id=1
activation_time=0
body=""

## global vars end here

## function definitions go here

gen_id() {
	id=$(("$(wc -l ~/Reminders/cache | cut -d" " -f 1)"+1))
}

add_reminder() {
	activation_time="$1"
	body="$2"
	gen_id
	echo "${id},${activation_time},${body}" >> ~/Reminders/cache
	echo "Reminder successfully added."
}

fix_ids() {
	touch ~/Reminders/tmpcache
	local tmp=0
	while read -r line || [[ -n "$line" ]]; do
		IFS=',' read -r -a arr <<< "$line"
		tmp=$(($tmp+1))
		if [[ "${arr[0]}" != "$tmp" ]]; then
			arr[0]="$tmp"
		fi
		echo "${arr[0]},${arr[1]},${arr[2]}" >> ~/Reminders/tmpcache	
	done < ~/Reminders/cache
	mv ~/Reminders/tmpcache ~/Reminders/cache
}

delete_reminder() {
	local idT="$1"
	sed -i "/^${idT}/d" ~/Reminders/cache
	echo "Reminder successfully deleted"
}

list_reminders() {
	printf "\n"
	printf "**List of Notes**\n" 
	printf "\n"
	local tmp=0
 	while read -r line || [[ -n "$line" ]]; do
 		IFS=',' read -r -a arr <<< "$line"
		tmp=$(($tmp+1))	
		printf "Note ID: %s\n" "${arr[0]}"
		printf "Time to show: %s\n" "${arr[1]}"
		printf "Reminder body: %s\n" "${arr[2]}"
		printf ":)-------note %s end-------\n" "${tmp}"
		printf "\n"
	done < ~/Reminders/"$1"	
}

sort_reminders() {
	touch ~/Reminders/tmpcache
	sort -t$',' -k2 ~/Reminders/cache > ~/Reminders/tmpcache
	mv ~/Reminders/tmpcache ~/Reminders/cache
	fix_ids
}

edit_reminder() {
	local tid="$1"
	note=$(grep -E "^${tid}," ~/Reminders/cache)
	echo $note
	IFS=',' read -r -a arr <<< "$note"
	read -p "Which field do you want to edit? Enter 1, 2 for Time, Body respectively: " field
	read -p "Enter its new value: " new_val
	delete_reminder "$tid"
	arr["$field"]="$new_val"
	echo ${arr["$field"]}
	echo "${arr[0]},${arr[1]},${arr[2]}" >> ~/Reminders/cache
	fix_ids
	echo "Reminder successfully edited"
}

print_usage() {
	printf "Usage: -a,--add-reminder to add a reminder, requires 2 args\n"
	printf "                         time and body respectively\n"
	printf "                         (time format should be yy-mm-dd hh:mm:ss)\n"
	printf "       -r,--run to start the reminders app, and show scheduled\n"
	printf "                         reminders at scheduled times\n"
	printf "       -l,--list-reminders to list all reminders, has an\n"
	printf "                         optional argument(string) to search through note\n"
	printf "       -d,--delete-reminder to delete a reminder, requires 1 arg\n"
	printf "                         NOTE ID to find the note to delete\n"
	printf "       -e,--edit-reminder to edit a reminder, requires 1 arg\n"
	printf "			 NOTE ID to find the note to edit\n"
	printf "          --reset flag to delete all reminders\n"
}

reset() {
	rm -rf ~/Reminders/cache
	touch ~/Reminders/cache
	echo "Data has been reset."
}

run() {
	echo "Running..."
	while [[ "$(wc -l ~/Reminders/cache | cut -d" " -f1)" > 0 ]]; do
		exec_note=$(grep -E "^1," ~/Reminders/cache)
		IFS=',' read -r -a arr <<< "$exec_note"
		s1=$(date --date="${arr[1]}" +%s)
		s2=$(date +%s)
		dif=$((s1-s2))
		sleep "${dif}s"
		echo "${arr[2]}"
		notify-send "${arr[2]}"
		delete_reminder 1
		fix_ids
	done
	echo "Reminders exhausted."
}

## function definitions end here

## input handling goes here

if [[ "$1" == "--run" || "$1" == "-r" ]]; then
	run
	exit 0
fi

if [[ "$1" == "--add-reminder" || "$1" == "-a" ]]; then
	if [[ "$#" != 3 ]]; then
		print_usage
		exit 1
	fi
	add_reminder "$2" "$3"
	fix_ids
	exit 0
fi

if [[ "$1" == "--delete-reminder" || "$1" == "-d"  ]]; then
	if [[ "$#" != 2 ]]; then
		print_usage
		exit 1
	fi
	delete_reminder "$2"
	fix_ids
	exit 0
fi

if [[ "$1" == "--list-reminders" || "$1" == "-l"  ]]; then
	if [[ "$#" == 1 ]]; then
		sort_reminders
		list_reminders cache
	fi
	if [[ "$#" == 2 ]]; then
		touch ~/Reminders/tmpcache
		grep "$2" ~/Reminders/cache >> ~/Reminders/tmpcache
		list_reminders tmpcache
		rm ~/Reminders/tmpcache
	fi
	if [[ "$#" > 2 ]]; then
		print_usage
		exit 1
	fi
	exit 0
fi

if [[ "$1" == "--edit-reminder" || "$1" == "-e" ]]; then
	if [[ "$#" != 2 ]]; then
		print_usage
		exit 1
	fi
	edit_reminder $2
	exit 0
fi

if [[ "$1" == "--help" || "$1" == "-h"  ]]; then
	print_usage
	exit 0
fi

if [[ "$1" == "--reset" ]]; then
	reset
	exit 0
fi

printf "Bad usage. Use the -h,--help flag for help.\n"
## input handling ends here


#!/bin/bash

cycles="$1"

if [[ $# == 0 ]]; then
	printf "Welcome to Break Manager!\n"
	printf "Enter the number of cycles you\n"
	printf "wish to work for\n"
	read -p "> " cycles
fi

work() {
	local arg="$1"
	echo "work"
#	if ! [ -x "$(command -v notify-send)" ]; then
#		printf "notify-send not installed\n"
#		printf "If you wish to receive notifications\n"
#		printf "Please install notify-send\n"
#	else
#		notify-send -t 5000 "You should be working now!"
#	fi
	sleep "${arg}m"
}

take_break() {
	local arg="$1"
	echo "break"
#	if ! [ -x "$(command -v notify-send)" ]; then
#		printf "notify-send not installed\n"
#		printf "If you wish to receive notifications\n"
#		printf "Please install notify-send\n"
#	else
#		notify-send -t 5000 "Time to take a break!"
#	fi
	sleep "${arg}m"
}

for i in $(seq 1 "$cycles"); do
	printf "${i}# "
	work 25
	printf "${i}# "
	if [[ "$i" != 0 && $(("$i"%4)) == 0 ]]; then
		take_break 15
	else
		take_break 5
	fi
done

echo "Finished"

#!/bin/bash

if [[ $# == 0  ]]; then
	echo "Welcome to the terminal-reminders app"
	echo
	echo "Run the command with -h flag for help"
fi

if [[ ! -n ~/Reminders/cache  ]]; then
	mkdir -p ~/Reminders
	touch ~/Reminders/cache
fi

## global vars go here

activation_time=0
body=""
freq=0

## global vars end here

## function definitions go here

add_reminder() {
	echo "Add reminder"
	#shift
	while getopts 't:b:f:' flag; do
		case "${flag}" in
			t) activation_time="${OPTARG}" ;;
			b) body="${OPTARG}" ;;
			f) freq="${OPTARG}" ;;
		esac
	done
        printf "${activation_time}**${body}**${freq}\n\n"
}

delete_reminder() {
	echo "Delete reminder"
}

list_reminders() {
	echo "List reminders"
}

edit_reminder() {
	echo "Edit reminder"
}

print_usage() {
	echo "Usage::"
}

## function definitions end here

## input handling goes here

if [[ "$1" == "--add-reminder" || "$1" == "-a" ]]; then
	add_reminder
fi

if [[ "$1" == "--delete-reminder" || "$1" == "-d"  ]]; then
	delete_reminder
fi

if [[ "$1" == "--list-reminders" || "$1" == "-l"  ]]; then
	list_reminders
fi

if [[ "$1" == "--edit-reminder" || "$1" == "-e" ]]; then
	edit_reminder
fi

if [[ "$1" == "--help" || "$1" == "-h"  ]]; then
	print_usage
fi

if [[ "$1" == "--reset" ]]; then
	reset
fi
## input handling ends here


#!/bin/bash

print_usage() {
	printf "Usage: The script expects 2 arguments, the pattern\n"
	printf "       to match followed by the URL of the webpage"
	printf "\n\n"
	printf "Example usage:\n"
	printf "./script.sh google www.google.com\n"
	printf "(counts the occurrences of the word google)\n"
}

if [[ $# == 0 ]]; then
	printf "A simple bash script to count the occurrences of\n"
	printf "a pattern in the body of a web page!\n"
	printf "\nUse the -h flag for help.\n"
	exit 0
fi

if [[ "$1" == "-h" ]]; then
	print_usage
	exit 0
fi


if [[ $# < 2 || $# > 2 ]]; then
	printf "Please enter the correct amount of arguments.\n"
	printf "Use the -h flag for help.\n"
	exit 1
fi

pattern="$1"

url="$2"

if curl -o /dev/null --silent --head --fail "$url"; then
	echo "URL exists! Counting..."
	echo
else
	echo "error: URL not found"
	exit 1
fi

text=$(curl -sL --fail "$url")


# sed -i '/<script/,/<\/script>/d' tmp.txt

if [[ ! -e tmp.txt ]]; then
	touch tmp.txt
fi
echo "$text" > tmp.txt


sed -i '/<script/,/<\/script>/d' tmp.txt
sed -i '/<style/,/<\/style>/d' tmp.txt
sed -i 's/<[^>]*>//g' tmp.txt

# cat tmp.txt

count=$(cat tmp.txt | grep -ic "$pattern")

rm tmp.txt

printf "${pattern} ${count}\n"

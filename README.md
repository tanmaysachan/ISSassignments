# Q1
Use the -h flag with the script to see the usage of the flags.

Use the -s flag to add a song(followed by a string, i.e. the song name),
along with optional -a,-y,-g flags for artist, yt link, and
genre respectively.

The -l flag lists all the songs added so far in a table format.

Use the -d flag to delete an entry. The -d flag requires a string to be passed, and it will
try to match the string with all existing song names, and display the songs matching the
strings and prompt the user to confirm delete, or ignore.

The -D flag will prompt the user to clear the entire song directory. This will delete all the
songs stored so far.

Use the -e flag to edit an entry. It expects an ID to be passed to it. IDs are visible
using the -l flag and are dynamic(i.e. they change after deletion operation)

Use the -S flag to search for songs. It expects a string to be passed, and similar to the delete
flag it will search for all the songs that match with the string. Unlike the delete flag, it will
try to match the string with other song details as well, not restricted to the song name only.
For eg, you can list all songs by a certain artist.

Examples ->

./script.sh -s "Hello" -a "Adele" # adds the song Hello by artist Adele to the list
./script.sh -d "Hello" # searches for songs to delete which have Hello in their song name
./script.sh -e 2 # edit the song with ID 2
./script.sh -D # deletes all the songs
./script.sh -S "Adele" # searches for songs which have Adele in their details


# Q2

Simple usage
run ./script.sh "pattern_to_match" "url"


# Q3

run ./script.sh "cycles"
the bonus version sends desktop notifications as well

# Q4

Run the script with the -h flag for help.
Use the -a or --add-reminder flag to add a reminder. It expects two arguments in order.
Time and Body.
Time should have the format (yyyy-mm-dd hh:mm:ss)

Use the -l or --list-reminders to list all the existing reminders, can pass a string as argument
to search specific notes.
Use the -e or --edit-reminder to edit a reminder. Expects ID as an argument
Use the -r or --run flag to run the application. It will start sending notifications 
of due reminders
Use the --reset flag to reset the app, deleting all reminders


# Q5

Done as per the requirements.


# Q6

Run ./script.sh "movie_input_file_path" "all_movies_path"


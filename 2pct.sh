#!/bin/bash

# 2pct.sh

# 2pct.sh is a script that processes a tex file line by line. 
# If a line starts with %%, the rest of the line is executed as a shell command. 
# The output of the shell command is captured and written to the output tex file. 
# If the command fails, the error message is prepended with %%. 
# If a line does not start with %%, it is written to the output file as is.

# Get the directory where the script is located
TWO_PCT_DIR=$(dirname "$(readlink -f "$0")")

BOLDBLUE='\033[1;34m'
NC='\033[0m' # No Color

# Source the 2pct_lib.sh file
source "$TWO_PCT_DIR/2pct_lib.sh"

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_file output_file"
    exit 1
fi

input_file="$1"
output_file="$2"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file $input_file does not exist."
    exit 2
fi

# Remove the output file if it exists, then create an empty output file
if [ -f "$output_file" ]; then
    rm "$output_file"
fi
touch "$output_file"

# Read the input file line by line
while IFS= read -r line || [ -n "$line" ]; do

    # Trim leading whitespace and check the first two characters
    trimmed_line=$(echo "$line" | sed 's/^[ \t]*//')
    if [[ "$trimmed_line" == %%* ]]; then

        # Extract command after %%
        command=$(echo "$trimmed_line" | cut -c3-)

        # Execute command and capture output and error
        printf "  Running: %s\n" "$command"
        output=$(eval "$command" 2>&1)
        exit_status=$?

        if [ $exit_status -ne 0 ]; then
            # If command fails, prepend %% to the error message and make sure it's on one line
            echo "%%${output}" | tr '\n' ' ' >> "$output_file"
            echo >> "$output_file"
        else
            # If command succeeds, append the output
            echo "$output" >> "$output_file"
        fi
    else
        # Append the line as is to the output file
        echo "$line" >> "$output_file"
    fi
done < "$input_file"

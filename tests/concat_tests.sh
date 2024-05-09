#!/bin/bash

# Loop through test files and concatenate their contents
output=""
for test_number in {0..17}; do
    file_name="test_${test_number}.p1"
    if [ -e "$file_name" ]; then
        content=$(<"$file_name")
        output="$output\nTest $test_number:\n$content\n"
    else
        output="$output\nTest $test_number: Test file '$file_name' not found.\n"
    fi
done

# Write the concatenated content to a file
echo -e "$output" > test_contents.txt


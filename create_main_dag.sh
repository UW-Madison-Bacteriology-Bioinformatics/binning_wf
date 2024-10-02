#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <list of samples> <output_file>"
    exit 1
fi

input_file="$1"
output_file="$2"

# Create or empty the output file
> "$output_file"

# Read each line from the input file
while IFS= read -r line; do
    # Append the text and write to the output file
    echo "SUBDAG EXTERNAL ${line} binning_wf_${line}.dag" >> "$output_file"
done < "$input_file"

echo "CONFIG dagman.dag" >> "$output_file"

echo "Processing complete. Output written to $output_file."


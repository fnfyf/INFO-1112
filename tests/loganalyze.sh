#!/bin/bash

# TODO
if [ $# -eq 0 ]; then
    input="$(pwd)"
else
    input="$1"
fi
file=$(find "$input" -type f -name "*.log" -mtime -7)
count=0
total=0
mostError=file
most=0
: > "analysisData.log"
for f in $file; do
    filename=$(basename "$f")
    if [[ $filename = "analysisData" || $filename = "summary.log" ]]; then
        continue
    fi
    count=$(grep -iwo "error" "$f" | wc -l)
    total=$((total+count))

    echo "$f: $count errors" | tee -a "analysisData.log"
    if [ $count -gt $most ]; then
        most=$count
        mostError=$f
    fi
done
echo "Total errors: $total"
echo "$mostError"
echo "Total errors : $total" > "summary.log"
echo "File with the most errors: $mostError ($most errors)" >> "summary.log"

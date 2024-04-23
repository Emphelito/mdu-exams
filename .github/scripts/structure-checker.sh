#!/bin/bash

total_mismatches_folders=0
total_folders=0

for folder in *; do
    if [ -d "$folder" ]; then
        total_folders=$((total_folders+1))
        awk_match=$(echo "$folder" | awk '/^[A-Z]{3}[0-9]{3}\ \-\ [A-Z]{1}.*$/')
        if [ -z "$awk_match" ]; then
            printf "\033[1;33mFolder\t%s\tdoes not match the pattern \033[0m\n" "$folder"
            total_mismatches_folders=$((total_mismatches_folders+1))

        fi
    fi
done
 
total_mismatches=0
total_files=0

for folder in *; do
    if [ -d "$folder" ]; then
        for file in "$folder"/*; do
            if [ -f "$file" ]; then
                total_files=$((total_files+1))
                fileName=$(echo "$file" | awk -F/ '{print $NF}')
                awk_match=$(echo "$fileName" | awk '/^[A-Z]{3}[0-9]{3}\ [0-9]{4}\-[0-9]{2}\-[0-9]{2}\ Exam(\-Solutions)?.pdf$/')
                if [ -z "$awk_match" ]; then
                    printf "\033[1;33mFile\t%s\tdoes not match the pattern\033[0m\n" "$file"
                    total_mismatches=$((total_mismatches+1))
                fi
            fi
        done
    fi
done


if [ $total_mismatches_folders -gt 0 ] || [ $total_mismatches -gt 0 ]; then
    printf "\033[1;31m%d folders and %d files do not match the pattern \033[0m\n" $total_mismatches_folders $total_mismatches
    exit 1
else
    exit 0
fi

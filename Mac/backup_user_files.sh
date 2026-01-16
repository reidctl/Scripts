#!/bin/bash
# Backup user files on Mac.


USERNAME=$1
USERFOLDER="/Users/$USERNAME"
OUTPUT="/Volumes/Backup/${USERNAME}_backup_$(date +%Y%m%d)"

cd "$USERFOLDER" || exit
zip -e -r "$OUTPUT" Documents Desktop Downloads

echo "Backup created: $OUTPUT"

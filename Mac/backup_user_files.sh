#!/bin/bash
# Backup user files on Mac.


USERNAME=$1
USERFOLDER="/Users/$USERNAME"
OUTPUT="/Volumes/Backup/${USERNAME}_backup_$(date +%Y%m%d)"

# Take ownership of user file recursively
echo "Taking ownership of $USERNAME folder"
chown -R tas "$USERFOLDER"


cd "$USERFOLDER" || exit
zip -e -r "$OUTPUT" Documents Desktop Downloads

echo "Backup created: $OUTPUT"

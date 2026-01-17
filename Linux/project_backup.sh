#!/bin/bash

set -e

trap 'notify-send "Nextcloud Backup FAILED" \
  "One or more project backups failed. Check logs." \
  -i dialog-error' ERR

PROJECTS=("c-garrett16.github.io" "c-programming" "dmenu" "dotfiles" "Scripts" "test-rpg")


for p in "${PROJECTS[@]}"; do
  /home/cgreid/Projects/Scripts/Linux/archive_encrypt_backup.sh "$p"
done


notify-send "Nextcloud Backup" \
  "All project backups completed successfully." \
  -i dialog-information

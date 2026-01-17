#!/bin/bash
set -e


FOLDER_TO_BACKUP="$1"

PROJECT_SRC="/home/cgreid/Projects"
BACKUP_DST="/home/cgreid/Nextcloud/Backups"
NOW=$(date +"%Y-%m-%d")
DEST_NAME="${FOLDER_TO_BACKUP}_backup_${NOW}.tar.gz"
KEEP=10
PREFIX="${FOLDER_TO_BACKUP}_backup_"
PASSPHRASE_FILE="$HOME/.local/share/backup_secrets/gpg_passphrase"

if [[ -z "$FOLDER_TO_BACKUP" ]]; then
  echo "Usage: $0 <folder_name>"
  exit 1
fi

if [[ ! -d "$PROJECT_SRC/$FOLDER_TO_BACKUP" ]]; then
  echo "Error: $PROJECT_SRC/$FOLDER_TO_BACKUP does not exist"
  exit 1
fi

mkdir -p "$BACKUP_DST"

cd "$PROJECT_SRC"

## ---- Archival & Encryption ---- ##
echo "Creating backup of $FOLDER_TO_BACKUP..."
tar -czvf "$DEST_NAME" "$FOLDER_TO_BACKUP" 

echo "Encrypting archive..."
gpg --batch --yes --pinentry-mode loopback \
  --passphrase-file "$PASSPHRASE_FILE" \
  -c "$DEST_NAME"

FINAL_NAME="${DEST_NAME}.gpg"

rm "$DEST_NAME"

mv "$FINAL_NAME" "$BACKUP_DST"

## ---- Rotation ---- ##
ls -1t "$BACKUP_DST"/"${PREFIX}"*.tar.gz.gpg 2>/dev/null \
  | tail -n +$((KEEP+1)) \
  | xargs -r rm -f

echo "Backup complete:"
echo "$FINAL_NAME can be found at $BACKUP_DST"


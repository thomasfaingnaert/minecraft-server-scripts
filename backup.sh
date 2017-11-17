#!/usr/bin/env bash

# Screen session name
SESSION_NAME='survival'

# Directory of world files
WORLD_DIR='world'

# Backup directory
BACKUP_DIR='~/backups/survival'

# Main filename for backup archives
BACKUP_FILENAME='world'

# Maximum amount of backups to keep
MAX_BACKUPS=24

################################################################################

# Save world and turn off saving
if ! screen -r -S $SESSION_NAME -X stuff '\nsave-all\nsave-off\n';
then
    echo 'Screen is attached. Skipping world backup.'
    exit 1
fi

# Wait until the server has written everything out
CMD="inotifywait -m -r $WORLD_DIR | grep -v ACCESS"
waitsilence -timeout 5s -command "$CMD"

# Create backup directory, if it doesn't exist already
mkdir -p $BACKUP_DIR

# Remove oldest backup
rm -f "$BACKUP_DIR/$BACKUP_FILENAME-hour-$MAX_BACKUPS.tar.gz"

# Move backups by one
for (( i=$MAX_BACKUPS; i > 0; i-- ))
do
    mv -- "$BACKUP_DIR/$BACKUP_FILENAME-hour-$((i-1)).tar.gz" "$BACKUP_DIR/$BACKUP_FILENAME-hour-$i.tar.gz"
done

# Create new backup
tar -cpvzf "$BACKUP_DIR/$BACKUP_FILENAME-hour-0.tar.gz" "$WORLD_DIR"

# Turn saving back on and inform players backup is complete
screen -S $SESSION_NAME -X stuff '\nsave-on\nsay World backup completed.\n'


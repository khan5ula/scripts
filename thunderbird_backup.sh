#!/bin/bash

# Define directory paths
srcPath="/home/kristian/.thunderbird/zwtfjvtw.default-release/"
destPath="/home/kristian/cache/thunderbird_backup/"

# Check whether the given directories exist
if [ -d "$srcPath" ] && [ -d "$destPath" ]; then
  # Grab the current date
  timestamp=$(date '+%Y-%m-%d')

  # Make a new directory using the timestamp
  backupDir="${destPath}${timestamp}"

  # Check whether the directory already exists
  if [ ! -d "$backupDir" ]; then
    mkdir "$backupDir"

    # Copy the source directory to the newly created directory
    cp -r "$srcPath" "$backupDir"

    # Check if the copy was successful
    if [ $? -eq 0 ]; then
      echo "Backup completed successfully."
    else
      echo "Error occurred during backup."
    fi
  else
    echo "A backup directory with the given timestamp already exists."
  fi

  # Count the directories with the given format
  countOfBackupDirs=$(ls -l "$destPath" | grep '^d' | grep -cE '[0-9]{4}-[0-9]{2}-[0-9]{2}')

  if [ "$countOfBackupDirs" -gt 3 ]; then
    # Remove the oldest directory
    oldestDir=$(ls -lt "$destPath" | grep '^d' | grep -E '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 | awk '{print $9}')
    rm -rf "${destPath:?}/$oldestDir"
  fi

else
  echo "Source or destination directory does not exist."
fi

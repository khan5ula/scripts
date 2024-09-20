#!/bin/bash

# Exit the script if any command fails
set -xe

# Copy the Music directory to a temporary location
echo "Creating a safe copy of the music directory..."
timestamp=$(date '+%Y-%m-%d')
working_dir="music-temp-${timestamp}"

if [ -d "${working_dir}" ]; then
  rm -r "${working_dir}"
fi

mkdir "${working_dir}"
cp -r "$HOME/Music" "$working_dir"

# Run the umlaut converter in the temporary location
echo "Running the umlaut converter"
music_umlaut_converter "${working_dir}"

mount_point="/run/media/kristian/8CF6-B3C01"

# Ensure the SD card is mounted before proceeding
if mount | grep -q "${mount_point}"; then
  # Copy the converted music directory to the SD card
  rsync -av --progress --delete "${working_dir}/" "${mount_point}"
else
  echo "Failed to mount the SD card. Exiting."
  exit 1
fi

# Unmount the SD card
sudo umount "${mount_point}"

# Remove the mount point directory after unmounting
sudo rmdir "${mount_point}"

# Remove the backup directory
rm -r "${working_dir}"

echo "Music sync completed successfully."

#!/bin/bash
# ------------------------------------------------------------------------------
# Script Name : upload_to_drive.sh
## Author     : Neelima Gali
# Date        : 2025-04-09
# Description : Uploads all ZIP files from 'github_zips/' to a specified Google drive folder
# ------------------------------------------------------------------------------

# Folder containing downloaded zip files
ZIP_FOLDER="github_zips"

# rclone remote name (configured via `rclone config`)
REMOTE_NAME="mydrive1"

# Create a remote folder name with date
REMOTE_FOLDER="ZipsBackup_$(date +%Y-%m-%d)"

# Check if ZIP folder exists
if [ ! -d "$ZIP_FOLDER" ]; then
    echo "Folder '$ZIP_FOLDER' not found!"
    exit 1
fi

# Check if rclone is installed
if ! command -v rclone &> /dev/null; then
    echo " rclone is not installed!"
    exit 1
fi

# Upload to Google Drive
echo "Uploading ZIPs to Google Drive..."
rclone copy "$ZIP_FOLDER" "$REMOTE_NAME:$REMOTE_FOLDER" --progress

if [ $? -eq 0 ]; then
    echo "Upload complete: $REMOTE_NAME/$REMOTE_FOLDER"
else
    echo "Upload failed. Please check rclone or network connection."
fi

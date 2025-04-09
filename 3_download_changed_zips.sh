#!/bin/bash
# ------------------------------------------------------------------------------
# Script Name   : 3_download_changed_zips.sh
# Author        : Neelima Gali
# Date          : 2025-04-09
# Description   : Downloads ZIP archives of all branches from all repositories
#                 of a GitHub user, and only saves them if the content has changed.
#                 Uses checksums to avoid duplicate downloads.
# ------------------------------------------------------------------------------

# Prompt user for GitHub credentials
read -p "Enter your GitHub Username: " GITHUB_USER
read -s -p "Enter your GitHub Token: " GITHUB_TOKEN

# Create output directory and checksum file if they don't exist
mkdir -p github_zips
touch github_zips/checksums.txt

# Fetch all repository names for the given user using GitHub API
repos=$(curl -s -u "$GITHUB_USER:$GITHUB_TOKEN" "https://api.github.com/users/$GITHUB_USER/repos" | jq -r '.[].name')

#Loop through each repository

for repo in $repos; do
  echo "processing repo: $repo"
  branches=$(curl -s -u "$GITHUB_USER:$GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_USER/$repo/branches" | jq -r '.[].name')

  # Loop through each branch in the repo
  for branch in $branches; do
    zip_name="github_zips/${repo}-${branch}.zip"  # Final zip file name
    tmp_zip="temp.zip"  # Temporary file for comparison

    echo "Downloading branch: $branch"
    # Download the ZIP of the branch
    curl -sL -u "$GITHUB_USER:$GITHUB_TOKEN" \
      "https://github.com/$GITHUB_USER/$repo/archive/refs/heads/$branch.zip" -o "$tmp_zip"

    # Compute checksum of the downloaded file
    new_checksum=$(sha256sum "$tmp_zip" | awk '{print $1}')

    # Retrieve the previous checksum (if any) for the same repo and branch
    old_checksum=$(grep "${repo}-${branch}" github_zips/checksums.txt | awk '{print $2}')

    # If checksums differ, update the ZIP and save the new checksum
    if [ "$new_checksum" != "$old_checksum" ]; then
      mv "$tmp_zip" "$zip_name"

      # Remove old checksum entry (if exists), then append the new one
      sed -i "/${repo}-${branch}/d" github_zips/checksums.txt
      echo "${repo}-${branch}.zip $new_checksum" >> github_zips/checksums.txt
      echo "Updated: $zip_name"
    else
      echo "No changes for $repo:$branch"
      rm "$tmp_zip"
    fi
  done
done
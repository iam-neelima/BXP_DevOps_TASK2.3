#!/bin/bash
#-------------------------------------------------------------------------------
# Script Name : 1_dowmload_all_zips.sh
# Author      : Neelima Gali
# Date        : 09-04-2025
# Description : Downloads all branches from all repositories of a 
#               specified GitHub user as ZIP files.
#------------------------------------------------------------------------------

# -------------------USER CONFIGURATION and AUTHENTICATION --------------------

read -p "Enter your GitHub Username: " GITHUB_USER
read -s -p "Enter your GitHub Token: " GITHUB_TOKEN
echo
mkdir -p github_zips

# -------------------- Step 1: Get all repositories ---------------------------

repos=$(curl -s -u "$GITHUB_USER:$GITHUB_TOKEN" "https://api.github.com/users/$GITHUB_USER/repos" | jq -r '.[].name')

# -------------------- Step 2: Loop through each repo and fetch branches -------
for repo in $repos; do
  echo "Processing repo: $repo"

  # Get all branches
  branches=$(curl -s -u "$GITHUB_USER:$GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_USER/$repo/branches" | jq -r '.[].name')
  
  # Loop through branches and download ZIPs
  for branch in $branches; do
    echo "  Downloading branch: $branch"
    zip_name="github_zips/${repo}-${branch}.zip"
    curl -sL -u "$GITHUB_USER:$GITHUB_TOKEN" "https://github.com/$GITHUB_USER/$repo/archive/refs/heads/$branch.zip" -o "$zip_name"
    echo "Downloaded $zip_name"
  done
done
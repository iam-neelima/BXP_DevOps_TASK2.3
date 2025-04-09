#!/bin/bash
# ------------------------------------------------------------------------------
# Script Name   : 2_upload_zips.sh
# Author        : Neelima Gali
# Date          : 2025-04-09
# Description   : This script automates the process of pushing ZIP files stored
#                 in a local directory ("github_zips") to a specified GitHub repository.
# ------------------------------------------------------------------------------
# NOTE: This script uses a Personal Access Token (PAT) for GitHub authentication.
# ------------------------------------------------------------------------------

# Prompt for GitHub username
read -p "Enter GitHub Username: " GITHUB_USER

# Prompt for GitHub Personal Access Token
read -s -p "Enter GitHub Token: " GITHUB_TOKEN
echo  # For newline after silent input

# Prompt user for the target GitHub repository name 
read -p "Enter Repo to Push Zips To: " TARGET_REPO

# Change to the directory containing ZIP files
cd github_zips || exit  # Exit if directory doesn't exist

# Initialize a new git repository (or reinitialize if already present)
git init

# Add GitHub remote using PAT for authentication
git remote add origin "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$TARGET_REPO.git"

# Stage all files in the directory (ZIPs assumed)
git add .

# Commit the files with a message
git commit -m "Upload ZIPs"

# Create or switch to the 'main' branch
git branch -M main

# Force push to the 'main' branch of the target repo
git push -u origin main --force

# Success message
echo "Zips uploaded to $TARGET_REPO"

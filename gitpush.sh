#!/bin/bash

# Usage: ./gitpush.sh "Your commit message"

# If no commit message, use a default
if [ -z "$1" ]; then
  msg="Update"
else
  msg=$1
fi

echo "Adding all files..."
git add .

echo "Committing with message: $msg"
git commit -m "$msg"

echo "Pushing to origin main..."
git push origin main

echo "✅ Done!"


#!/bin/bash

# Define repository and directory
REPO_OWNER="zorp-corp"
REPO_NAME="nockchain"
TARGET_DIR="hoon/apps/dumbnet/lib"

# Fetch file list
FILES=$(curl -s https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/contents/$TARGET_DIR | jq -r '.[] | select(.type == "file") | .name')

# Iterate over each file
for FILE in $FILES; do
  echo "## $FILE"
  RAW_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/master/$TARGET_DIR/$FILE"
  curl -s $RAW_URL | awk '
    /^::/ {
      if (!in_block) {
        in_block=1;
      }
      print "- Line " NR ": " $0;
    }
    !/^::/ {
      if (in_block) {
        print "";
        in_block=0;
      }
    }'
  echo ""
done
 

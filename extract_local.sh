#!/bin/bash

# Usage: ./scan_comments.sh path/to/directory

TARGET_DIR="$1"

if [ -z "$TARGET_DIR" ]; then
  echo "Usage: $0 path/to/directory"
  exit 1
fi

echo "Finding all comments in files, for directory $1"

# Find all regular files within the target directory
find "$TARGET_DIR" -type f | while read -r FILE; do
  echo "## ${FILE#$TARGET_DIR/}"  # Strip leading directory path
  awk '
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
    }' "$FILE"
  echo ""
done

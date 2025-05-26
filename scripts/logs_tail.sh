  GNU nano 7.2                                                                                                    logs_tail.sh                                                                                                              
#!/bin/bash

# Default number of lines to tail if not provided
NUM_LINES=5
I=0
# Parse -n argument
while getopts "n:" opt; do
  case $opt in
    n) NUM_LINES="$OPTARG" ;;
    *) echo "Usage: $0 -n <number_of_lines>"; exit 1 ;;
  esac
done

#We don't need an nLimit variable with * arg. Nice.
# Loop through all nX folders in current directory
for dir in ./n*/; do
  # Remove trailing slash for cleaner output
  dir_name="${dir%/}"
  I=$((I + 1))
  log_file="${dir_name}/node.log"
  
  if [ -f "$log_file" ]; then
    echo "Logs for Node $I:"
    tail -n "$NUM_LINES" "$log_file"
    echo "------------------------"
  else
    echo "No log file found in $dir_name"
  fi
done

#!/bin/bash
#script shamelessly written by chatgpt+

# --- Usage ---
if [[ $# -lt 2 ]]; then
  echo "Usage:"
  echo "  $0 [--stats] [--cap-lines N] <search string> <file path>"
  echo "  $0 --extract-words <file path>"
  exit 1
fi

# --- Initialize flags ---
MODE="search"
CAP_LINES=0

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --extract-words)
      MODE="extract"
      FILE_PATH="$2"
      shift 2
      ;;
    --stats)
      MODE="stats"
      shift
      ;;
    --cap-lines)
      CAP_LINES="$2"
      shift 2
      ;;
    *)
      if [[ -z "$SEARCH_TERM" ]]; then
        SEARCH_TERM="$1"
      elif [[ -z "$FILE_PATH" ]]; then
        FILE_PATH="$1"
      fi
      shift
      ;;
  esac
done

# --- Validate file ---
if [[ ! -f "$FILE_PATH" ]]; then
  echo "Error: File '$FILE_PATH' not found."
  exit 1
fi

# --- Extract-words mode ---
if [[ "$MODE" == "extract" ]]; then
  WORDS=$(strings "$FILE_PATH" \
    | grep -oE '\b[a-zA-Z]{5,12}\b' \
    | tr '[:upper:]' '[:lower:]' \
    | sort | uniq)

  OUTPUT=$(echo "$WORDS" | paste -sd, -)
  echo "{$OUTPUT}"
  exit 0
fi

# --- Search / Stats mode ---
CLEANED=$(strings "$FILE_PATH")
MATCHED=$(echo "$CLEANED" | grep -i "$SEARCH_TERM")

# --- Stats mode output ---
if [[ "$MODE" == "stats" ]]; then
  TOTAL_LINES=$(echo "$CLEANED" | wc -l)
  MATCHED_LINES=$(echo "$MATCHED" | wc -l)

  if [[ $TOTAL_LINES -eq 0 ]]; then
    PERCENT="0.00"
  else
    PERCENT=$(awk "BEGIN { printf \"%.2f\", ($MATCHED_LINES / $TOTAL_LINES) * 100 }")
  fi

  echo "=== Stats ==="
  echo "Total lines       : $TOTAL_LINES"
  echo "Matched lines     : $MATCHED_LINES"
  echo "Match percentage  : $PERCENT%"
  echo
fi

# --- Output matched lines (limited if needed) ---
if [[ "$CAP_LINES" -gt 0 ]]; then
  echo "$MATCHED" | head -n "$CAP_LINES"
else
  echo "$MATCHED"
fi

#!/bin/bash
set -e

# Load configuration
source "$(dirname "$0")/dirs.conf"

# Check required files
[ ! -f "$HEADER_FILE" ] && { echo "Header file missing"; exit 1; }
[ ! -f "$FOOTER_FILE" ] && { echo "Footer file missing"; exit 1; }

# Function to update header and footer in an HTML file
update_file() {
  local file="$1"
  local backup="${file}.bak"

  echo "Processing: $file"

  cp "$file" "$backup"

  # Extract body with sed, replace header/footer by matching <div id="header">...</div> etc.
  awk -v header="$(<"$HEADER_FILE")" -v footer="$(<"$FOOTER_FILE")" '
    BEGIN { h=0; f=0 }
    /<div[^>]+id=["'"'"']header["'"'"']/ { print header; h=1; next }
    /<div[^>]+id=["'"'"']footer["'"'"']/ { print footer; f=1; next }

    h && /<\/div>/ { h=0; next }
    f && /<\/div>/ { f=0; next }

    !(h || f) { print }
  ' "$backup" > "$file"
}

# Find and process all .html files under DOCROOT
find "$DOCROOT" -type f -name '*.html' | while read -r htmlfile; do
  update_file "$htmlfile"
done

echo "All files updated with new header and footer. Backups saved as .bak"

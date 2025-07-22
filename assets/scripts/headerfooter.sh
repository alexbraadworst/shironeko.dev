#!/bin/bash

# headerfooter.sh - Header and footer HTML loader
# Copyright (c) 2025 alexbraadworst
# Licensed under the MIT License (MIT)
# https://opensource.org/licenses/MIT

# Load configuration
source "$(dirname "$0")/dirs.conf"

# Syntax for this config file:
# DOCROOT="/path/to/docroot"
# BLOG_DIR="$DOCROOT/path/to/blogs"
# CSS_PATH="/path/to/css"
# HEADER_FILE="$DOCROOT/path/to/header"
# FOOTER_FILE="$DOCROOT/path/to/footer"

set -e
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
  BEGIN { in_header=0; in_footer=0 }
  
  # Detect header start tag and print replacement, then skip original block
  /<div[^>]+class=["'"'"']header["'"'"']/ {
    print header
    in_header=1
    next
  }
  
  # Detect footer start tag and print replacement, then skip original block
  /<footer[^>]*>/ {
    print footer
    in_footer=1
    next
  }
  
  # Detect header end tag, stop skipping lines
  in_header && /<\/div>/ {
    in_header=0
    next
  }
  
  # Detect footer end tag, stop skipping lines
  in_footer && /<\/footer>/ {
    in_footer=0
    next
  }
  
  # Skip lines inside header or footer blocks
  in_header || in_footer {
    next
  }
  
  # Print lines outside header/footer
  { print }
' "$backup" > "$file"

}

# Find and process all .html files under DOCROOT
find "$DOCROOT" -type f -name '*.html' ! -path "*/assets/*" | while read -r htmlfile; do
  update_file "$htmlfile"
done

echo "All files updated with new header and footer. Backups saved as .bak"

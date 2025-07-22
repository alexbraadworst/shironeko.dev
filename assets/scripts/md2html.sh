#!/bin/bash

# md2html.sh - Markdown to HTML conversion script
# Copyright (c) 2025 alexbraadworst
# Licensed under the MIT License (MIT)
# https://opensource.org/licenses/MIT

# Path to blog directories
source "$(dirname "$0")/dirs.conf"

# Syntax for this config file:
# DOCROOT="/path/to/docroot"
# BLOG_DIR="$DOCROOT/path/to/blogs"
# CSS_PATH="/path/to/css"
# HEADER_FILE="$DOCROOT/path/to/header"
# FOOTER_FILE="$DOCROOT/path/to/footer"


# Find all .md files
find "$BLOG_DIR" "$GALLERY_DIR" -type f -name "*.md" | while read -r mdfile; do
  htmlfile="${mdfile%.md}.html"
  filename=$(basename "$mdfile" .md)
  title=$(echo "$filename" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g') # Title Case

  echo "Converting $mdfile → $htmlfile"

  # Convert markdown to HTML body
  body=$(pandoc "$mdfile" -f markdown -t html)

  # Begin writing HTML output
  {
    echo '<!DOCTYPE html>'
    echo '<html lang="en">'
    echo '<head>'
    echo "  <meta charset=\"UTF-8\">"
    echo "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
    echo "  <title>$title</title>"
    echo "  <link rel=\"stylesheet\" href=\"$CSS_PATH\">"
    echo '</head>'
    echo '<body>'

    # Optional shared header
    [ -f "$HEADER_FILE" ] && cat "$HEADER_FILE"

    # bg div
    echo '<div class="page">'
    # Start content div
    echo '<div class="content">'

    # Insert the converted body
    echo "$body"

   # Back link depending on parent dir
    if [[ "$mdfile" == "$GALLERY_DIR"* ]]; then
      echo '<a href="/gallery"><em>Back to index</em></a>'
    else
      echo '<a href="/blog"><em>Back to index</em></a>'
    fi

    # End content div
    echo '</div>'

    # end bg div
    echo '</div>'


    # Optional shared footer
    [ -f "$FOOTER_FILE" ] && cat "$FOOTER_FILE"

    echo '</body>'
    echo '</html>'
  } > "$htmlfile"

done
#!/bin/bash

# render-fileshare.sh - Static fileshare list renderer
# Copyright (c) 2025 alexbraadworst
# Licensed under the MIT License (MIT)
# https://opensource.org/licenses/MIT

source "$(dirname "$0")/dirs.conf"

# Syntax for this config file:
# DOCROOT="/path/to/docroot"
# BLOG_DIR="$DOCROOT/path/to/blogs"
# CSS_PATH="/path/to/css" (href)
# HEADER_FILE="$DOCROOT/path/to/header"
# FOOTER_FILE="$DOCROOT/path/to/footer"

FILES_JSON="$DOCROOT/fileshare/files.json"
OUTPUT_HTML="$DOCROOT/fileshare/index.html"
TITLE="file shares"

if [ ! -f "$FILES_JSON" ]; then
  echo "Error: files.json not found at $FILES_JSON"
  exit 1
fi

# Generate HTML
{
  echo '<!DOCTYPE html>'
  echo '<html lang="en">'
  echo '<head>'
  echo '  <meta charset="UTF-8">'
  echo '  <meta name="viewport" content="width=device-width, initial-scale=1.0">'
  echo "  <title>$TITLE</title>"
  echo "  <link rel=\"stylesheet\" href=\"$CSS_PATH\">"
  echo '</head>'
  echo '<body>'

  [ -f "$HEADER_FILE" ] && cat "$HEADER_FILE"
  echo '<div class="page">'
  echo '<div class="content">'
  echo "  <h2>$TITLE</h2>"
  echo '   <p style="text-align: center;">'
  echo "      i've got a nextcloud server, thought i'd share some of the files off it that might be of interest to others. most of these were obtained through the kindness of others, "
  echo "      be it torrenting (seed your torrents) or soulseek, and through me purchasing them. have fun!"
  echo    "</p>"
  echo '  <table id="files-table">'
  echo '    <thead><tr><th>name</th><th>url</th><th>purpose</th></tr></thead>'
  echo '    <tbody>'

  jq -r '.[] | [.name, .url, .purpose] | @tsv' "$FILES_JSON" | while IFS=$'\t' read -r name url purpose; do
    echo "      <tr><td>${name}</td><td><a href=\"${url}\" target=\"_blank\">${url}</a></td><td>${purpose}</td></tr>"
  done

  echo '    </tbody>'
  echo '  </table>'
  echo '</div>'
  echo '</div>'

  [ -f "$FOOTER_FILE" ] && cat "$FOOTER_FILE"

  echo '</body>'
  echo '</html>'
} > "$OUTPUT_HTML"

echo "Generated fileshare page: $OUTPUT_HTML"

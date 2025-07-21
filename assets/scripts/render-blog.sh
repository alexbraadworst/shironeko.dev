#!/bin/bash

# render-blog.sh - Blog index table generator
# Copyright (c) 2025 alexbraadworst
# Licensed under the MIT License (MIT)
# https://opensource.org/licenses/MIT

# Path to directories
source "$(dirname "$0")/dirs.conf"

# Syntax for this config file:
# DOCROOT="/path/to/docroot"
# BLOG_DIR="$DOCROOT/path/to/blogs"
# CSS_PATH="/path/to/css" (href)
# HEADER_FILE="$DOCROOT/path/to/header"
# FOOTER_FILE="$DOCROOT/path/to/footer"

POSTS_JSON="$BLOG_DIR/posts.json"
OUTPUT_HTML="$BLOG_DIR/index.html"
TITLE="blog"

if [ ! -f "$POSTS_JSON" ]; then
  echo "Error: posts.json not found at $POSTS_JSON"
  exit 1
fi

# Generate HTML index
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

  echo '<div class="content">'
  echo "  <h2>$TITLE</h2>"
  echo '   <p style="text-align: center;">'
  echo "      here's my blog posts and other writings. i write them and put them on this random website because i'm stupid. "
  echo "      it's mostly a mix of creative writing, rants, and other stuff, hope you derive some enjoyment out of reading them :>"
  echo    "</p>"
  echo '  <table id="blog-table">'
  echo '    <thead><tr><th>title</th><th>date</th></tr></thead>'
  echo '    <tbody>'

  # Use jq to extract and loop over posts
  jq -r '.[] | [.title, .url, .date] | @tsv' "$POSTS_JSON" | while IFS=$'\t' read -r title url date; do
    echo "      <tr><td><a href=\"$url\">$title</a></td><td>$date</td></tr>"
  done

  echo '    </tbody>'
  echo '  </table>'
  echo '</div>'

  [ -f "$FOOTER_FILE" ] && cat "$FOOTER_FILE"

  echo '</body>'
  echo '</html>'
} > "$OUTPUT_HTML"

echo "Generated index: $OUTPUT_HTML"

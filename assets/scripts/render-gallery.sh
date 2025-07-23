#!/bin/bash

# render-gallery.sh - Gallery index generator (image-focused blog posts)
# Copyright (c) 2025 alexbraadworst
# Licensed under the MIT License (MIT)
# https://opensource.org/licenses/MIT

# Path to directories
source "$(dirname "$0")/dirs.conf"

POSTS_JSON="$GALLERY_DIR/posts.json"
OUTPUT_HTML="$GALLERY_DIR/index.html"
IMAGE_DIR="$GALLERY_DIR/images"
TITLE="gallery"

# Strip metadata from all images recursively
echo "Stripping metadata from images in: $IMAGE_DIR"
find "$IMAGE_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -exec exiftool -overwrite_original -all= {} +

# Generate HTML
{
  echo '<!DOCTYPE html>'
  echo '<html lang="en">'
  echo '<head>'
  echo '  <meta charset="UTF-8">'
  echo '  <meta name="viewport" content="width=device-width, initial-scale=1.0">'
  echo "  <title>$TITLE</title>"
  echo "  <link rel=\"stylesheet\" href=\"$CSS_PATH\">"
  echo "  <link rel=\"stylesheet\" href="/blog/blogstyle.css">"
  echo '</head>'
  echo '<body>'

  [ -f "$HEADER_FILE" ] && cat "$HEADER_FILE"
  echo '<div class="page">'
  echo '<div class="content">'
  echo "  <h2>$TITLE</h2>"
  echo '  <p style="text-align: center;">photos, fragments, and visual musings</p>'
  echo '  <table id="blog-table">'
  echo '    <thead><tr><th>title</th><th style="text-align: center;">image(s)</th><th style="text-align:right;">date</th></tr></thead>'
  echo '    <tbody>'

  jq -r '.[] | [.title, .url, .date, .images[]?] | @tsv' "$POSTS_JSON" | \
    awk -F'\t' 'BEGIN { OFS="\t" } {
      titles[$2]=$1; dates[$2]=$3; images[$2]=images[$2] "<img src=\"" $4 "\" style=\"max-height:100px; margin:2px;\">"
    } END {
      for (url in titles) {
        print "<tr><td><a href=\"" url "\">" titles[url] "</a></td><td style=\"text-align:center\">" images[url] "</td><td style=\"text-align:right; white-space: nowrap;\">" dates[url] "</td></tr>"
      }
    }'


  echo '    </tbody>'
  echo '  </table>'
  echo '</div>'
  echo '</div>'

  [ -f "$FOOTER_FILE" ] && cat "$FOOTER_FILE"
  echo '</body>'
  echo '</html>'
} > "$OUTPUT_HTML"

echo "Generated gallery index: $OUTPUT_HTML"

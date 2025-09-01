#!/bin/bash
# Strip metadata from all images in /blog/media
source "$(dirname "$0")/dirs.conf"

MEDIA_DIR="$BLOG_DIR/media"

# Check for exiftool
if ! command -v exiftool &> /dev/null; then
  exit 1
fi

# Find and strip metadata in-place
find "$MEDIA_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.tiff" \) \
  -exec exiftool -overwrite_original -all= {} \;

echo "✅ Metadata stripped from all images in $MEDIA_DIR"

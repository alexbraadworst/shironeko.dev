#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/images/folder"
  exit 1
fi

IMG_DIR="$1"

find "$IMG_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | while read -r img; do
  base=$(basename "$img")
  ext="${base##*.}"
  name="${base%.*}"

  # Skip already -full images
  if [[ "$name" == *"-full" ]]; then
    continue
  fi

  highres="$IMG_DIR/${name}-full.${ext}"
  lowres="$IMG_DIR/${name}.${ext}"

  # Rename original to highres if needed
  if [ ! -f "$highres" ]; then
    mv "$img" "$highres"
    echo "Renamed $img to $highres"
  fi

  # Generate low-res if missing or outdated
  if [ ! -f "$lowres" ] || [ "$highres" -nt "$lowres" ]; then
    if [[ "$ext" =~ ^(jpg|jpeg|JPG)$ ]]; then
      magick "$highres" -quality 75 "$lowres"
    elif [[ "$ext" =~ ^png$ ]]; then
      magick "$highres" -strip -define png:compression-level=9 "$lowres"
    else
      magick "$highres" -resize 1200x\> "$lowres"
fi

    echo "Generated low-res $lowres"
  fi
done


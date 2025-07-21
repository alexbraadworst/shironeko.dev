#!/bin/bash

source "$(dirname "$0")/dirs.conf"
find "$DOCROOT" -type f -name '*.html.bak' -exec rm -v {} +
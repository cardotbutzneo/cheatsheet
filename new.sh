#!/bin/bash

## Create a new base folder

if [ -z "$1" ]; then
    echo "[ERROR] Abort, need the name of the directory"
    echo "Usage: ./new.sh [-h | dir_name]"
    exit 1
fi

if [[ "$1" == "-h" ]]; then
    echo "Help <new.sh>"
    echo "-h: help file"
    echo "Usage: ./new.sh dir_name [file1 file2 ...]"
    exit 0
fi

DIR="$1"
shift

mkdir -p "$DIR"

cat > "$DIR/start.md" << EOF
# Overview

EOF

for f in "$@"; do
    touch "$DIR/$f.md"
done
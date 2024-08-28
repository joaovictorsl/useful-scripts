#!/bin/bash

# Default values
SRC_DIR="."
DST_DIR="."
USER=$(whoami)
HOST="localhost"
PORT="22"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --srcDir) SRC_DIR="$2"; shift ;;
        --dstDir) DST_DIR="$2"; shift ;;
        --user) USER="$2"; shift ;;
        --host) HOST="$2"; shift ;;
        --port) PORT="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Resolve absolute paths
SRC_DIR=$(realpath "$SRC_DIR")
if [ "$DST_DIR" == "." ]; then
    DST_DIR="$SRC_DIR"
fi

# Main loop
while true; do
    rsync -ar --update --delete --port="$PORT" "$SRC_DIR" "$USER@$HOST:$DST_DIR"
    sleep 1
done

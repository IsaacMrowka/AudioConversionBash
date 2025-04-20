#!/bin/bash

FLAC_DIR="/home/isaac/Music/copied/Torrents/FLAC2"
MP3_DIR="/home/isaac/Music/converted"

# Clean target dir
echo "Cleaning $MP3_DIR..."
rm -rf "$MP3_DIR"
mkdir -p "$MP3_DIR"

# Copy full folder structure and .flac files
echo "Copying files from $FLAC_DIR to $MP3_DIR..."
rsync -a "$FLAC_DIR/" "$MP3_DIR/"

# Collect all .flac files
mapfile -d '' flac_files < <(find "$MP3_DIR" -type f -name "*.flac" -print0)

# Convert each
for file in "${flac_files[@]}"; do
    output_path="${file%.flac}.mp3"

    echo "Converting: $file -> $output_path"
    ffmpeg -i "$file" -c:a libmp3lame -b:a 320k "$output_path" -y

    if [[ $? -eq 0 ]]; then
        echo "Successfully converted: $file"
        rm "$file"
    else
        echo "Error converting: $file"
    fi
done

echo "All done — conversion and cleanup complete."

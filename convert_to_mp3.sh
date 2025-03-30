#!/bin/bash

FLAC_DIR="/home/isaac/Music/copied/Torrents/FLAC2"
MP3_DIR="/home/isaac/Music/converted"

rsync -a --include '*/' --exclude '*' "$FLAC_DIR/" "$MP3_DIR/"

find "$FLAC_DIR" -type f -name "*.flac" -print0 | while IFS= read -r -d '' file; do
    rel_path="$(realpath --relative-to="$FLAC_DIR" "$file")"
    output_path="$MP3_DIR/${rel_path%.flac}.mp3"

    mkdir -p "$(dirname "$output_path")"

    echo "Converting: $file -> $output_path"
    ffmpeg -i "$file" -c:a libmp3lame -b:a 320k "$output_path"

    if [[ $? -eq 0 ]]; then
        echo "Successfully converted: $file -> $output_path"
    else
        echo "Error converting: $file"
    fi

done < <(find "$FLAC_DIR" -type f -name "*.flac" -print0)

echo "Conversion process completed"

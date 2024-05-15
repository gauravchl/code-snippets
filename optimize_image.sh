#!/bin/bash

# Script to optimize the large size images using squoosh-cli
# Also uses exiftool to preserve the orientation of from exif data image as it was captured
# Accepts 2 arguments, from and to integer to precess the images in a folder

# /Users/gc/Public/GS/Traditinoal/100MSDCF/

# Change directory to where the images are located
IMAGES_DIR="/Users/gc/Public/GS/Gaurav_Ji/01_Photo/"
OUT_DIR="/Users/gc/Desktop/GS_Wed_Optimize/Gaurav_Ji/01_Photo"
cd "$IMAGES_DIR" || exit

echo "Hello world"

# Define variables for file range
FROM_FILE="$1"
TO_FILE="$2"

export NODE_OPTIONS="--max-old-space-size=4096 --trace-warnings --no-warnings"

# Loop through .JPG files and process only those within the specified range
file_num=0
for image in *.JPG; do
    if [[ -f "$image" && "$file_num" -ge "$FROM_FILE" && "$file_num" -le "$TO_FILE" ]]; then
        echo " "
        echo " "
        echo "File Number: $file_num"
        echo "Processing ${IMAGES_DIR}${image}"
        
        # Read orientation metadata using ExifTool
        orientation=$(exiftool -Orientation -n "${IMAGES_DIR}${image}" | awk '{print $NF}')

        NODE_OPTIONS="$NODE_OPTIONS" squoosh-cli --mozjpeg '{quality:75}' -d $OUT_DIR "${IMAGES_DIR}${image}"

        # Set the orientation metadata using ExifTool
        exiftool -Orientation="$orientation" -n "${OUT_DIR}/${image}" -overwrite_original
    fi
    file_num=$((file_num + 1))
done
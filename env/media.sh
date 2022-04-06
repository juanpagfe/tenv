#!/bin/bash

###############################################################################################
#                                                                                             #
#                                        MEDIA FUNCTIONS                                      #
#                                                                                             #
###############################################################################################

function vconvert() {
    file=$1
    to=$2
    if [ ! -f "$file" ]; then
        echo "You need to specify a file in the first parameter $file"
        return 1
    fi
    extension="${file##*.}"
    if [ -z "$to" ] | [ $to = $extension ]; then
        echo "You need to specify a export codec (mp4,avi). And it must be different from source($extension)"
        return 1
    fi
    base="${file%.*}"
    echo ffmpeg -i $file -codec copy "${base}.$2"
    ffmpeg -i $file -codec copy "${base}.$2"
}

function vcompress() {
    file=$1
    if [ ! -f "$file" ]; then
        echo "You need to specify a file in the first parameter $file"
        return 1
    fi
    base="${file%.*}"
    extension="${file##*.}"
    echo ffmpeg -i $file -vcodec libx265 -crf 28 "$base-min.$extension"
    ffmpeg -i $file -vcodec libx265 -crf 28 "$base-min.$extension"
}

function vprepare() {
    file=$1
    if [ ! -f "$file" ]; then
        echo "You need to specify a file in the first parameter $file"
        return 1
    fi
    base="${file%.*}"
    extension="${file##*.}"
    vconvert $file mp4
    vcompress $base.mp4
}

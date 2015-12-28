#!/bin/bash

cd "$1"

for file in *.white.* ; do
    if [[ ! -f $1/${file%.*.*}.black.png ]] && [[ ! -f $1/${file%.*.*}.black.svg ]]; then
        echo The following white logo has no black version: $1/$file
    fi
done

for file in *.black.svg ; do
    if [[ -f ${file%.*.*}.black.png ]]; then
        echo The following black logo has an obsolete png version: $1/$file
    fi
done

for file in *.white.svg ; do
    if [[ -f ${file%.*.*}.white.png ]]; then
        echo The following white logo has an obsolete png version: $1/$file
    fi
done

for file in *.black.svg ; do
    if [[ -f $1/${file%.*.*}.white.png ]]; then
        echo The following black logo is an svg, but has a white png: $1/$file
    fi
done

for file in *.svg ; do
    if grep -q "</text>" $file; then
        echo This svg contains text: $1/$file
    fi
done

for file in *.svg ; do
    if grep -q "data:image/png" $file; then
        echo This svg contains a png image: $1/$file
    fi
done

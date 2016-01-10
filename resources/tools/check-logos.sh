#!/bin/bash

cd "$1"

for file in * ; do
    if [[ ! -f ${file%.*.*}.default.png ]] && [[ ! -f ${file%.*.*}.default.svg ]]; then
        echo The following logo has no default version: $file
    fi
done

for file in *.default.svg ; do
    if [[ -f ${file%.*.*}.*.png ]]; then
        echo The following default logo is an svg, but has one or more png alternatives: $file
    fi
done

for file in *.svg ; do
    if grep -q "</text>" $file; then
        echo This svg contains text: $file
    fi
    if grep -q "data:image/png" $file; then
        echo This svg contains a png image: $file
    fi
done

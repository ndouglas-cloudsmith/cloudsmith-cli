#!/bin/bash

PACKAGE="h11==0.14.0"

for i in {1..30}; do
    echo "Downloading copy $i..."
    pip download "$PACKAGE" --no-deps --only-binary=:all:
    
    # Find the downloaded wheel file (handles name like h11-0.14.0-py3-none-any.whl)
    FILE=$(ls h11-0.14.0-*.whl | head -n 1)
    
    if [[ -f "$FILE" ]]; then
        cp "$FILE" "h11_copy_$i.whl"
        rm "$FILE"
    else
        echo "❌ Download failed or file not found!"
        exit 1
    fi
done

echo "✅ Downloaded 30 copies."

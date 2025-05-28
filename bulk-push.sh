#!/bin/bash

REPO="acme-corporation/acme-repo-one"
API_KEY="$CLOUDSMITH_API_KEY"
TAG="workflow1"

for file in *.whl; do
    echo "📦 Uploading $file to Cloudsmith..."
    cloudsmith push python "$REPO" "$file" -k "$API_KEY" --tags "$TAG"

    if [ $? -eq 0 ]; then
        echo "✅ Successfully uploaded: $file"
    else
        echo "❌ Failed to upload: $file"
    fi
done

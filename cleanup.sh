#!/bin/bash

# Set your API key and repo
API_KEY="$CLOUDSMITH_API_KEY"
REPO="acme-corporation/acme-repo-one"
QUERY="format:python AND tag:workflow1"

# Get the identifier of the first matching package
PACKAGE_IDENTIFIER=$(cloudsmith list packages "$REPO" -k "$API_KEY" -q "$QUERY" \
  --output-format json | jq -r '.[0].identifier')

# Check if a package was found
if [ -n "$PACKAGE_IDENTIFIER" ]; then
  echo "Deleting package with identifier: $PACKAGE_IDENTIFIER"

  # Delete the package
  cloudsmith delete package "$REPO" "$PACKAGE_IDENTIFIER" -k "$API_KEY" --yes
else
  echo "No package found matching the tag and format."
fi

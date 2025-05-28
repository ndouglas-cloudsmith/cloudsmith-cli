#!/bin/bash

# Cloudsmith API details
API_KEY="${CLOUDSMITH_API_KEY}"   # Your Cloudsmith API key
OWNER="acme-corporation"          # Your organization/owner
REPOSITORY="acme-repo-one"        # Your repository
TAG="workflow1"                   # The tag to filter packages by
PAGE_SIZE=250                     # Number of packages per API page

# API endpoint
BASE_URL="https://api.cloudsmith.io/v1/packages/${OWNER}/${REPOSITORY}/"

# Function to delete tagged packages
function delete_tagged_packages() {
    echo "Fetching packages with tag '$TAG' from repository '$REPOSITORY'..."

    # Fetch total page count
    page_count=$(curl -sI -H "X-Api-Key: $API_KEY" "$BASE_URL?query=tag:$TAG&page_size=$PAGE_SIZE" \
        | grep -i "X-Pagination-Page-Total" | awk '{print $2}' | tr -d '\r')

    echo "Total Pages: ${page_count}"

    current_page=1
    packages_deleted=0

    while [ "$current_page" -le "$page_count" ]; do
        # Fetch packages with the tag
        packages=$(curl -s -H "X-Api-Key: $API_KEY" \
            -G "$BASE_URL" \
            --data-urlencode "query=tag:$TAG" \
            --data-urlencode "page=$current_page" \
            --data-urlencode "page_size=$PAGE_SIZE")

        names=($(echo "$packages" | jq -r '.[].name'))
        slugs=($(echo "$packages" | jq -r '.[].slug_perm'))

        if [[ "${#slugs[@]}" -eq 0 ]]; then
            echo "No more packages found on page $current_page."
            break
        fi

        for i in "${!slugs[@]}"; do
            echo "Deleting package ${names[$i]}, ID: ${slugs[$i]}"
            response=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
                -H "X-Api-Key: ${API_KEY}" \
                "${BASE_URL}${slugs[$i]}/")

            if [ "$response" -eq 204 ]; then
                echo "Successfully deleted package: ${names[$i]}"
                ((packages_deleted++))
            else
                echo "Failed to delete package: ${names[$i]} (Status code: $response)"
            fi
        done

        ((current_page++))
    done

    echo "Total Packages Deleted: $packages_deleted"
}

# Run the function
delete_tagged_packages

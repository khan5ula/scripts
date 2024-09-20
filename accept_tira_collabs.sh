#!/bin/bash

# Scripts to accept github collaboration requests for tira courses

# GitHub API token
TOKEN=$(grep -Po "(?<=^github_api_token=).*" ./resources/.apikey)

# Get the list of collaboration invitations
invitations=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user/repository_invitations)

# Loop through each invitation
echo "$invitations" | jq -c '.[]' | while read -r invitation; do
  # Extract invitation ID and HTML URL
  invite_id=$(echo "$invitation" | jq -r '.id')
  html_url=$(echo "$invitation" | jq -r '.html_url')

  # Check whether the invitation is for TIRA coursework
  if echo "$html_url" | grep -iq "tira"; then
    echo "Accepting invitation ID: $invite_id (URL: $html_url)"

    # Accept the invitation
    curl -s -L \
      -X PATCH \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $TOKEN" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "https://api.github.com/user/repository_invitations/$invite_id"
  else
    echo "Skipping invitation ID: $invite_id (URL: $html_url)"
  fi
done

echo "All invitations have been processed."

#!/bin/sh

filename="order-tests-linux.tar.gz"
# filename="order-tests-linux-x86-64.tar.gz"

# Fetch release information
response=$(curl --silent --show-error --fail \
  https://api.github.com/repos/edufolly/order_tests/releases/latest 2>&1)

curl_exit_code=$?

if [ $curl_exit_code -ne 0 ]; then
  echo "Error: Failed to retrieve release information from GitHub API" >&2
  echo "Curl output: $response" >&2
  exit 1
fi

# Get download URL
url=$(echo "$response" | jq -r --arg fname "$filename" \
  '.assets[] | select(.name == $fname).browser_download_url')

if [ -z "$url" ]; then
  echo "Error: Download asset '$filename' not found in latest release" >&2
  exit 1
fi

# Download file
if ! curl --silent --fail --remote-name --location "$url"; then
  echo "Error: Failed to download $filename" >&2
  exit 1
fi

# Verify downloaded file
if [ ! -f "$filename" ]; then
  echo "Error: Downloaded file '$filename' not found" >&2
  exit 1
fi

# Extract archive
if ! tar -xf "$filename"; then
  echo "Error: Failed to extract $filename" >&2
  rm -f "$filename"
  exit 1
fi

# Verify extracted content
if [ ! -f "order-tests" ]; then
  echo "Error: Extracted directory 'order-tests' not found" >&2
  rm -f "$filename"
  exit 1
fi

# Install to system
destination="/usr/local/bin"
if [ ! -w "$destination" ]; then
  echo "Error: Insufficient permissions to write to $destination" >&2
  echo "       Run the script with sudo or choose a different location" >&2
  rm -f "$filename"
  exit 1
fi

if ! mv "order-tests" "$destination"; then
  echo "Error: Failed to move order-tests to $destination" >&2
  rm -f "$filename"
  exit 1
fi

# Cleanup
rm -f "$filename"

echo "Success: order-tests installed to $destination"

#!/bin/bash

set -e

URL="http://localhost:8080"

echo "Testing endpoint: "$URL""

status_code=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$status_code" -eq 200 ]; then
    echo "PASSED"
else
    echo "FAILED"
fi

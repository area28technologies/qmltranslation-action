#!/bin/sh

set -e

echo "running entrypoint command(s)"
response=$(sh -c " $INPUT_COMMAND")
echo "::set-output name=response::$response"


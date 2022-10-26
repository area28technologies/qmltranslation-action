#!/bin/bash

set -e
set -o nounset
set -o xtrace

echo "running entrypoint command(s)"

$INPUT_COMMAND

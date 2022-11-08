#!/bin/bash

echo "running entrypoint command(s)"
response=$(sh -c " $INPUT_COMMAND")
status=$?
echo "::set-output name=response::$response"
if [[ $status -eq 0 ]]; then exit 0; else exit 1; fi


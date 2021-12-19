#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Extract "foo" and "baz" arguments from the input into
# FOO and BAZ shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "SUBSCRIPTION=\(.subscription)"')"

# Extracting resource group IDs from subscription
ID=$(az resource list --subscription "$SUBSCRIPTION" --query '[].id')

# Producing a JSON object containing result value
jq -n --arg id "$ID" '{"id":$id}'

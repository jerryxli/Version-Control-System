#!/bin/dash

# Testing of pigs-init

PATH="$PATH:$(dirname "$(realpath "$0")")"

OUR_DIR=$(mktemp -d)
OUR_OUT=$(mktemp)
OUR_ERR=$(mktemp)

REF_DIR=$(mktemp -d)
REF_OUT=$(mktemp)
REF_ERR=$(mktemp)

trap 'rm -rf "$OUR_DIR" "$REF_DIR"' EXIT

cd "$REF_DIR" || exit 
2041 pigs-init > "$REF_OUT" 2> "$REF_ERR"
ls -d .pig >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-init >> "$REF_OUT" 2>> "$REF_ERR"
REF_EXIT=$?

cd "$OUR_DIR" || exit 
pigs-init > "$OUR_OUT" 2> "$OUR_ERR"
ls -d .pig >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-init >> "$OUR_OUT" 2>> "$OUR_ERR"
OUR_EXIT=$?

if 
    diff "$OUR_OUT" "$REF_OUT" > /dev/null && 
    diff "$OUR_ERR" "$REF_ERR" > /dev/null &&
    [ "$OUR_EXIT" -eq "$REF_EXIT" ]
then 
    echo "Test Passed"
else 
    diff "$OUR_OUT" "$REF_OUT"
    diff "$OUR_ERR" "$REF_ERR"
fi

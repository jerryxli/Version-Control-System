#!/bin/dash

# Testing of pigs-add

PATH="$PATH:$(dirname "$(realpath "$0")")"

OUR_DIR=$(mktemp -d)
OUR_OUT=$(mktemp)
OUR_ERR=$(mktemp)

REF_DIR=$(mktemp -d)
REF_OUT=$(mktemp)
REF_ERR=$(mktemp)

trap 'rm -rf "$OUR_DIR" "$REF_DIR"' EXIT

cd "$REF_DIR" || exit 
# error testing
2041 pigs-add a > "$REF_OUT" 2> "$REF_ERR"
2041 pigs-init >> "$REF_OUT" 2>> "$REF_ERR"
ls -d .pig >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add a >> "$REF_OUT" 2>> "$REF_ERR"
touch a >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add a >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add a >> "$REF_OUT" 2>> "$REF_ERR"
# working properly
touch b >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add a b >> "$REF_OUT" 2>> "$REF_ERR"
touch c d e >> "$REF_OUT" 2>> "$REF_ERR"
echo 1>d >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add c d e >> "$REF_OUT" 2>> "$REF_ERR"
REF_EXIT=$?

cd "$OUR_DIR" || exit 
pigs-add a > "$OUR_OUT" 2> "$OUR_ERR"
pigs-init >> "$OUR_OUT" 2>> "$OUR_ERR"
ls -d .pig >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add a >> "$OUR_OUT" 2>> "$OUR_ERR"
touch a >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add a >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add a >> "$OUR_OUT" 2>> "$OUR_ERR"
touch b >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add a b >> "$OUR_OUT" 2>> "$OUR_ERR"
touch c d e >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 1>d >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add c d e >> "$OUR_OUT" 2>> "$OUR_ERR"
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

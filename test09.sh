#!/bin/dash

# Testing pigs branch

PATH="$PATH:$(dirname "$(realpath "$0")")"

OUR_DIR=$(mktemp -d)
OUR_OUT=$(mktemp)
OUR_ERR=$(mktemp)

REF_DIR=$(mktemp -d)
REF_OUT=$(mktemp)
REF_ERR=$(mktemp)

trap 'rm -rf "$OUR_DIR" "$REF_DIR"' EXIT

cd "$REF_DIR" || exit 
2041 pigs-branch >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-init >> "$REF_OUT" 2>> "$REF_ERR"
echo 1 > a >> "$REF_OUT" 2>> "$REF_ERR"
echo 2 > b >> "$REF_OUT" 2>> "$REF_ERR"
echo 3 > c >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add a b c >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit -m "first" >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-branch branch1 >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-branch branch1 >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-branch branch2 >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-branch >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-branch -d branch1 >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-branch >> "$REF_OUT" 2>> "$REF_ERR"

REF_EXIT=$?

cd "$OUR_DIR" || exit 
pigs-status >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-init >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 1 > a >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 2 > b >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 3 > c >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add a b c  >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit -m "first" >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-branch branch1 >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-branch branch1 >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-branch branch2 >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-branch >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-branch -d branch1 >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-branch >> "$OUR_OUT" 2>> "$OUR_ERR"

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

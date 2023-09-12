#!/bin/dash

# Testing of pigs-commit with -a flag

PATH="$PATH:$(dirname "$(realpath "$0")")"

OUR_DIR=$(mktemp -d)
OUR_OUT=$(mktemp)
OUR_ERR=$(mktemp)

REF_DIR=$(mktemp -d)
REF_OUT=$(mktemp)
REF_ERR=$(mktemp)

trap 'rm -rf "$OUR_DIR" "$REF_DIR"' EXIT

cd "$REF_DIR" || exit 
2041 pigs-init >> "$REF_OUT" 2>> "$REF_ERR"
echo line 1 > a >> "$REF_OUT" 2>> "$REF_ERR"
echo lol > c >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add a c >> "$REF_OUT" 2>> "$REF_ERR"

2041 pigs-commit -m "hello1" >> "$REF_OUT" 2>> "$REF_ERR"
echo line 2 >> a >> "$REF_OUT" 2>> "$REF_ERR"
echo world >> b >> "$REF_OUT" 2>> "$REF_ERR"
echo boo >> c >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit -a -m "hello2" >> "$REF_OUT" 2>> "$REF_ERR"
# commited -a because was already in index
2041 pigs-show 1:a >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-show 1:c >> "$REF_OUT" 2>> "$REF_ERR"
# not commited -a because was not already in index
2041 pigs-show 0:b >> "$REF_OUT" 2>> "$REF_ERR"
REF_EXIT=$?

cd "$OUR_DIR" || exit 
pigs-init >> "$OUR_OUT" 2>> "$OUR_ERR"
echo line 1 > a >> "$OUR_OUT" 2>> "$OUR_ERR"
echo lol > c >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add a c >> "$OUR_OUT" 2>> "$OUR_ERR"

pigs-commit -m "hello1" >> "$OUR_OUT" 2>> "$OUR_ERR"
echo line 2 >> a >> "$OUR_OUT" 2>> "$OUR_ERR"
echo world >> b >> "$OUR_OUT" 2>> "$OUR_ERR"
echo boo >> c >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit -a -m "hello2" >> "$OUR_OUT" 2>> "$OUR_ERR"

pigs-show 1:a >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-show 1:c >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-show 0:b >> "$OUR_OUT" 2>> "$OUR_ERR"
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

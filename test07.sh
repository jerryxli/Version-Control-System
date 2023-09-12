#!/bin/dash

# Testing pigs status 1

PATH="$PATH:$(dirname "$(realpath "$0")")"

OUR_DIR=$(mktemp -d)
OUR_OUT=$(mktemp)
OUR_ERR=$(mktemp)

REF_DIR=$(mktemp -d)
REF_OUT=$(mktemp)
REF_ERR=$(mktemp)

trap 'rm -rf "$OUR_DIR" "$REF_DIR"' EXIT

cd "$REF_DIR" || exit 
2041 pigs-status >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-init >> "$REF_OUT" 2>> "$REF_ERR"
echo 1 > a >> "$REF_OUT" 2>> "$REF_ERR"
echo 2 > b >> "$REF_OUT" 2>> "$REF_ERR"
echo 3 > c >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add a b c >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit -m "first" >> "$REF_OUT" 2>> "$REF_ERR"
echo hi >> a >> "$REF_OUT" 2>> "$REF_ERR"
echo hi2 >> b >> "$REF_OUT" 2>> "$REF_ERR"
echo hi3 >> c >> "$REF_OUT" 2>> "$REF_ERR"
echo lol > d >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add b c >> "$REF_OUT" 2>> "$REF_ERR"
echo boo >> b >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-rm --force a >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-rm --cached b >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-rm --force c >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-rm d >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-status >> "$REF_OUT" 2>> "$REF_ERR"
REF_EXIT=$?

cd "$OUR_DIR" || exit 
pigs-status >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-init >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 1 > a >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 2 > b >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 3 > c >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add a b c  >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit -m "first" >> "$OUR_OUT" 2>> "$OUR_ERR"
echo hi >> a >> "$OUR_OUT" 2>> "$OUR_ERR"
echo hi2 >> b >> "$OUR_OUT" 2>> "$OUR_ERR"
echo hi3 >> c >> "$OUR_OUT" 2>> "$OUR_ERR"
echo lol > d >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add b c >>"$OUR_OUT" 2>> "$OUR_ERR"
echo boo >> b >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-rm --force a >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-rm --cached b >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-rm --force c >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-rm d >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-status >> "$OUR_OUT" 2>> "$OUR_ERR"
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

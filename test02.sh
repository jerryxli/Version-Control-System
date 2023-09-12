#!/bin/dash

# Testing of pigs-commit

PATH="$PATH:$(dirname "$(realpath "$0")")"

OUR_DIR=$(mktemp -d)
OUR_OUT=$(mktemp)
OUR_ERR=$(mktemp)

REF_DIR=$(mktemp -d)
REF_OUT=$(mktemp)
REF_ERR=$(mktemp)

trap 'rm -rf "$OUR_DIR" "$REF_DIR"' EXIT


# error testing pigs-commit 
cd "$REF_DIR" || exit 
2041 pigs-commit > "$REF_OUT" 2> "$REF_ERR"
2041 pigs-commit -m "hello" >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-init >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit -m "hello" >> "$REF_OUT" 2>> "$REF_ERR"
# working properly
touch a >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add a >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit -m "hello" >> "$REF_OUT" 2>> "$REF_ERR"
touch b c d >> "$REF_OUT" 2>> "$REF_ERR"
echo 1>d >> "$REF_OUT" 2>> "$REF_ERR"
echo 3>c >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add b d >> "$REF_OUT" 2>> "$REF_ERR"
rm b >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit -m "hello2" >> "$REF_OUT" 2>> "$REF_ERR"
echo hello>a >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit -m "hello3" >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-log >> "$REF_OUT" 2>> "$REF_ERR"
REF_EXIT=$?

cd "$OUR_DIR" || exit 
pigs-commit > "$OUR_OUT" 2> "$OUR_ERR"
pigs-commit -m "hello" >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-init >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit -m "hello" >> "$OUR_OUT" 2>> "$OUR_ERR"
touch a >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add a >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit -m "hello" >> "$OUR_OUT" 2>> "$OUR_ERR"
touch b c d >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 1>d >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 3>c >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add b d >> "$OUR_OUT" 2>> "$OUR_ERR"
rm b >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit -m "hello2" >> "$OUR_OUT" 2>> "$OUR_ERR"
echo hello>a >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit -m "hello3" >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-log >> "$OUR_OUT" 2>> "$OUR_ERR"
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

#!/bin/dash

# Testing of pigs show

PATH="$PATH:$(dirname "$(realpath "$0")")"

OUR_DIR=$(mktemp -d)
OUR_OUT=$(mktemp)
OUR_ERR=$(mktemp)

REF_DIR=$(mktemp -d)
REF_OUT=$(mktemp)
REF_ERR=$(mktemp)

trap 'rm -rf "$OUR_DIR" "$REF_DIR"' EXIT

cd "$REF_DIR" || exit 
2041 pigs-show 0:a >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-init >> "$REF_OUT" 2>> "$REF_ERR"
touch a b c d >> "$REF_OUT" 2>> "$REF_ERR"
echo 1>d >> "$REF_OUT" 2>> "$REF_ERR"
echo 3>c >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add c d >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit -m "hello1" >> "$REF_OUT" 2>> "$REF_ERR"
echo hello>b >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add b >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit -m "hello2" >> "$REF_OUT" 2>> "$REF_ERR"
# error testing
2041 pigs-show 0:a >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-show 2:c >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-show 1:e >> "$REF_OUT" 2>> "$REF_ERR"
# working
echo hello>b >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-add b >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-commit -m "hello2" >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-show 1:b >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-show 0:b >> "$REF_OUT" 2>> "$REF_ERR"
2041 pigs-show :b >> "$REF_OUT" 2>> "$REF_ERR"

REF_EXIT=$?

cd "$OUR_DIR" || exit 
pigs-show 0:a >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-init >> "$OUR_OUT" 2>> "$OUR_ERR"
touch a b c d >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 1>d >> "$OUR_OUT" 2>> "$OUR_ERR"
echo 3>c >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add c d >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit -m "hello1" >> "$OUR_OUT" 2>> "$OUR_ERR"
echo hello>b >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add b >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit -m "hello2" >> "$OUR_OUT" 2>> "$OUR_ERR"

pigs-show 0:a >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-show 2:c >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-show 1:e >> "$OUR_OUT" 2>> "$OUR_ERR"

echo hello>b >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-add b >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-commit -m "hello2" >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-show 1:b >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-show 0:b >> "$OUR_OUT" 2>> "$OUR_ERR"
pigs-show :b >> "$OUR_OUT" 2>> "$OUR_ERR"

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

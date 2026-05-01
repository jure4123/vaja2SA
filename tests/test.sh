#!/bin/bash

# build
g++ main.cpp radix.cpp -o program

# test input
echo "5 3 1 4 2" > input.txt

# run
./program input.txt > output.txt

# preveri (prilagodi glede na nalogo!)
EXPECTED="1 2 3 4 5"

OUTPUT=$(cat output.txt)

if [ "$OUTPUT" != "$EXPECTED" ]; then
  echo "Test failed"
  exit 1
else
  echo "Test passed"
fi
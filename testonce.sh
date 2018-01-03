#!/bin/bash
address=$(./string2addr.sh "$1" "$2");
check=$(./checkaddr.sh "$address");
echo -e "$1\t$address\t$2\t$check";

#!/bin/bash
file=$1;
iterations=$2;
while read string; do
  #echo "$string"
  address=$(./string2addr.sh "$string" "$iterations");
  check=$(./checkaddr.sh "$address");
  echo -e "$string\t$address\t$iterations\t$check";
  sleep 0.5;
done <"$file"

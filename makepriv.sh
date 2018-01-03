#!/bin/bash
# https://github.com/grondilu/bitcoin-bash-tools
var=$1;
for (( i=1; i<=$2; i++ ))
do
   if [[ "$i" == 1 ]]
   then
      var=$(echo -n "$var" | sha256sum);
   else
      var=$(echo -n "$var" | xxd -r -p | sha256sum -b)
   fi
done
var=($(echo "$var"));
var=$(echo "$var" | tr '[:lower:]' '[:upper:]');
echo "$var";

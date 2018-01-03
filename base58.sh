#!/bin/bash
# https://en.bitcoin.it/wiki/Wallet_import_format
# https://en.bitcoin.it/wiki/Base58Check_encoding

# array of base58 characters
base58=(1 2 3 4 5 6 7 8 9 A B C D E F G H J K L M N P Q R S T U V W X Y Z a b c d e f g h i j k m n o p q r s t u v w x y z);

# the number to encode
number=$(echo "$1" | tr '[:lower:]' '[:upper:]');

# for division
x="$number";
# the result
ret="";
# binary flag for exiting while loop
b=0;

# as long as b equals zero do while loop
while [[ b -eq 0 ]]
do
   # get residual of number x divided by 58 (58 is 3A in hexadecimal)
   residual=$(echo "obase=16;ibase=16;$x%3A" | bc);
   # get decimal encoding of residual which is used as index for base58 array
   index=$(echo "obase=10;ibase=16;$residual" | bc);
   # divide number by 58
   x=$(echo "obase=16;ibase=16;$x/3A" | bc);

   # concatenate partial results
   ret="${base58[$index]}""$ret";

   # is number already equal to zero
   b=$(echo "obase=16;ibase=16;$x==0" | bc);
done

# get two character substrings from number
arr=$(echo "$number" | fold -w2);
# get array of two character substrings
arr=($(echo "$arr" | tr " " "\n"));
c=0;
# get leading ones
while [[ "${arr[$c]}" == "00" ]]
do
   ret="${base58[0]}""$ret";
   c=$((c+1));
done

# return the resulting string
echo "$ret";

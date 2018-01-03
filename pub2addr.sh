#!/bin/bash
# https://bitcoin.stackexchange.com/questions/8247/how-can-i-convert-a-sha256-hash-into-a-bitcoin-base58-private-key
# https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses

public_key=$1;
#echo "$public_key";
private_key=$(echo "$public_key" | tr '[:upper:]' '[:lower:]');
#echo "$public_key";
sha256pkey=($(echo -n "$public_key" | xxd -r -p | sha256sum -b));
#echo "$sha256pkey";
ripemd160pkey=$(echo -n "$sha256pkey" | xxd -p -r | openssl rmd160 -binary | xxd -p);
#echo "$ripemd160pkey";
# bitcoin: 00
# litecoin: 30
plus00ripemd160pkey="$2""$ripemd160pkey";
#echo "$plus00ripemd160pkey";
foo=($(echo -n "$plus00ripemd160pkey" | xxd -r -p | sha256sum -b));
#echo "$foo";
foo=($(echo -n "$foo" | xxd -r -p | sha256sum -b));
#echo "$foo";
checksum=$(echo "$foo" | head -c 8);
#echo "$checksum";
foo="$plus00ripemd160pkey""$checksum";
#echo "$foo";
address=$(./base58.sh "$foo");
#address=$(python ../python-bitcoin-blockchain-parser/base58.py "$foo")
echo "$address"

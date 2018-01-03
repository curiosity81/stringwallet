#!/bin/bash
private_key=$(./makepriv.sh "$1" "$2");
#echo "$private_key";
public_key=$(./priv2pub "$private_key");
#echo "$public_key";
address=$(./pub2addr.sh "$public_key" "00");
echo "$address";

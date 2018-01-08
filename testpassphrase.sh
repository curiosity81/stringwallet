#!/bin/bash
string=$2;

IFS=';' read -r -a array <<< "$string";
#echo "${array[0]}"

private_key=$(./makepriv.sh "$string" "$1");
#echo "$private_key";
checksum=($(echo -n "$private_key" | xxd -r -p | sha256sum -b));
checksum=$(echo -n "$checksum" | tr '[:lower:]' '[:upper:]');
checksum=$(echo -n "$checksum" | tail -c 4);
#echo "$checksum";

if [[ "$checksum" != "$3" ]]
then
   echo "ERROR: passphrase is wrong!";
   exit;
fi

echo "passphrase seems to be correct";

public_key=$(./priv2pub "$private_key");
address=$(./pub2addr.sh "$public_key" "00");

echo "   private key:"
echo "      $private_key";
echo "   public key:"
echo "      $public_key";
echo "   address:"
echo "      $address";

#!/bin/bash
string=$2;

IFS=';' read -r -a array <<< "$string";
#echo "${array[0]}"

len=$(( ${#array[@]} - 4));

string="";
for (( i=0; i<$len; i++ ))
do
   #echo "${array[$i]}";
   string="$string""${array[$i]};";
done

string=$(echo -n "$string" | head -c -1);
#echo "$string";

private_key=$(./makepriv.sh "$string" "$1");
#echo "$private_key";
checksum=($(echo -n "$private_key" | xxd -r -p | sha256sum -b));
checksum=$(echo -n "$checksum" | tr '[:lower:]' '[:upper:]');
#echo "$checksum";
checksum=$(echo -n "$checksum" | tail -c 4 | tr '[:lower:]' '[:upper:]');
#echo "$checksum";

index=0;
for i in {0..3}
do
   prefix=$(echo -n "$checksum" | head -c 1);
   checksum=$(echo -n "$checksum" | tail -c +2);

   foo=$(echo "obase=10;ibase=16;$prefix" | bc);
   index=$(echo "obase=10;ibase=10;$index + $foo" | bc);

   if [[ "$index" -ge "$len" ]]
   then
      index=$(echo "obase=10;ibase=10;$index-$len" | bc)
   fi

   #echo "$index";
   #echo "${array[$index]}";

   j=$(( $len + $i ));
   if [[ "${array[$index]}" != "${array[$j]}" ]]
   then
      echo "ERROR: passphrase is wrong!";
      exit;
   fi
done

echo "passphrase seems to be correct";

public_key=$(./priv2pub "$private_key");
address=$(./pub2addr.sh "$public_key" "00");

echo "   private key:"
echo "      $private_key";
echo "   public key:"
echo "      $public_key";
echo "   address:"
echo "      $address";

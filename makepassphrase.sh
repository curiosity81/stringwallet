#!/bin/bash
number_of_words=$2;

size_of_universe=$(aspell -d en dump master | wc -l);
number_of_choices=0;
for (( i=0; i<$number_of_words; i++ ))
do
   number_of_choices=$(echo "obase=10;ibase=10;l($size_of_universe-$i)/l(2) + $number_of_choices" | bc -l);
done

word_list=$(aspell -d en dump master | shuf | head -n "$number_of_words");

#echo "$word_list";
string=$(echo -n "$word_list" | tr '\r\n' ';');
#echo "$string";

IFS=';' read -r -a array <<< "$string";
#echo "${array[0]}"

private_key=$(./makepriv.sh "$string" "$1");
#echo "$private_key";
checksum=($(echo -n "$private_key" | xxd -r -p | sha256sum -b));
checksum=$(echo -n "$checksum" | tr '[:lower:]' '[:upper:]');
checksum=$(echo -n "$checksum" | tail -c 4);
#echo "$checksum";

public_key=$(./priv2pub "$private_key");
address=$(./pub2addr.sh "$public_key" "00");

echo "passphrase:";
echo "   $string";
echo "checksum:";
echo "   $checksum";
echo "private key:";
echo "   $private_key";
echo "public key:";
echo "   $public_key";
echo "address:";
echo "   $address";
echo "size of universe:";
echo "   $size_of_universe";
echo "number of possible choices:";
echo "   choose($size_of_universe, $number_of_words) = 2^$number_of_choices";

#!/bin/bash
address=$1;

rnumber=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/urandom);
wget -O - --no-check-certificate -o /dev/null https://blockchain.info/address/$address > /tmp/$rnumber;

total_received=$(grep "total_received" /tmp/$rnumber | grep -Eo "[0-9.]+[[:space:]]BTC" | grep -Eo "[0-9.]+");
final_balance=$(grep "final_balance" /tmp/$rnumber | grep -Eo "[0-9.]+[[:space:]]BTC" | grep -Eo "[0-9.]+");

echo -e "$total_received\t$final_balance";

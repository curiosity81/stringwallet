# Stringwallet
Collection of scripts for creating string wallets. Code is not optimized for speed.

## WARNINGS
USE AT YOUR OWN RISK!

THIS REPOSITORY IS FOR EDUCATIONAL PURPOSES ONLY.

ONLY SEND FUNDS TO GENERATED ADDRESSES IF YOU UNDERSTAND THE LINUX BASH SO THAT YOU ARE ABLE TO REPRODUCE POTENTIAL BUGS AND CORRESPONDING PRIVATE KEYS!

WARNING: WEAK SEEDS CAN LEAD TO FUND LOSS!

SOME RULES FOR STRINGWALLET SEEDS:

1. NEVER USE ONLY ONE WORD WHICH CAN BE FOUND IN A DICTIONARY!
2. NEVER USE A COMBINATION OF WORDS WHICH CAN BE FOUND IN A BOOK OR IN A LIST ON THE INTERNET!
3. NEVER HASH THE SEED ONLY ONCE!
4. ALWAYS CHECK THE BLOCKCHAIN IF ADDRESS WAS ALREADY USED!

## Introduction
Having private keys in a wallet saved on some device is quite complex: Firstly, the private keys must be generated from enough entropy. Secondly, the wallet must be encrypted with an additional good, i.e., long and complex, passphrase, which must be remembered. Thirdly, the hardware the wallet is saved on should be long-living. Fourthly, one has to create several backups of the wallet, so that the loss of one ore more devices is negligible.

A good stringwallet has the advantage, that only the first and second point are complex. A stringwallet needs no specific hardware. In the best case, the seed can be remembered. However, memorable seeds are weak and might be robbed quickly. In the case, where the seed is hard to remember, the seed can be written down on a sheet of paper. Backups can easily be created by writing down the seed on several different sheets of paper. The sheets of paper can be hidden. Moreover, the sheets can be cut into two or more pieces, which can be stored at different places so that it is unlikly that an attacker has access to the full seed. Other versions of "two factor authentication" are possible.

## Methods
There are roughly 2^256 Bitcoin private keys. Sampling words without replacement from a dictionary can generate more different lists of words than there exist Bitcoin private keys. For instance, 16 words sampled from a dictionary containing 100.000 words results in 100.000\*99.999\*...\*99.985 = 2^265.75 possible word lists. Assuming that hashing distributes these strings evenly between 0 and 2^256, security should be high enough. Especially, since there exist only 2^160 Bitcoin addresses such that ~2^96 private keys map to the same address.

## Files
- base58.sh \<hex string\>:
  Translates a hex string into base58. Quite slow.
- makepriv.sh \<string\> \<number\>:
  Hashes \<string\> \<number\> of times and returns hash as hex string.
- priv2pub \<hex string\>:
  Returns public key as hex string given the private key as hex string.
- pub2addr.sh \<hex string\>:
  Translates public key as hex string into base85 \*coin-address.
- string2addr.sh \<string\> \<number\>:
  Hashes \<string\> \<number\> of times and produces address from corresponding private key.
- testonce.sh \<string\> \<number\>:
  Returns funds of address generated from \<string\> and \<number\> of hash iterations.
- checkaddr.sh \<address\>:
  Returns funds of address using blockchain.info.
- test.sh \<file\>:
  Returns funds of addresses generated from strings using blockchain.info. Each line represents a string.
- makelib.sh:
  Creates random list of 1000 words from some dictionary and removes german umlauts. Adapt it correspondingly. Intended to create lists of words, which can be printed out. From this list, 16 to 20 or even more words can be selected to represent a new passphrase string for a stringwallet.
- makepassphrase.sh \<number of iterations\> \<number of words\>:
  Creates \<number of words\> words and the corresponding keys via \<number of iterations\> hashing rounds. The last four words are used as checksum. Checksum is not necessary for deriving the private key. See examples below.  
- testpassphrase.sh \<number of iterations\> \<passphrase\>:
  Checks passphrase. Only works if passphrase has four checksum words. See examples below.

## To do
- Add secure default parameters to scripts.
- Add the possibility to generate a bunch of address from one seed.

## Examples:
### Good passphrase
```
./makepassphrase.sh 100 16
passphrase:   
  Nubian's;Fairbanks;plaza's;economy;westernizing;walkaways;commerce;codex's;balefully;horseman;stanchion;portability's;immaculate;griper;crowdfunded;flippers;westernizing;stanchion;griper;Nubian's
private key:
   6BE5D473A71D98FDFDE0E06ABA4DB323CF6992583FF8F12DA5B3B2DF67C8A102
public key:
   04763851BE043B7FBA8855C1CB947DD3E0CC869A8FD63C33FAA3C37BDFDB0E6B3CF530C62C4BD9AA3A4F75929C1F602D68DF0092DF944A3D924FCCAC6FE22A245D
address:
   1BLeXrujA5QW8wFnC1D8FddnGxQzTUPJNc
number of possible choices
   2^271.12188820084398622673
```

```
./testpassphrase.sh 100 "Nubian's;Fairbanks;plaza's;economy;westernizing;walkaways;commerce;codex's;balefully;horseman;stanchion;portability's;immaculate;griper;crowdfunded;flippers;westernizing;stanchion;griper;Nubian's"
passphrase seems to be correct
   private key:
      6BE5D473A71D98FDFDE0E06ABA4DB323CF6992583FF8F12DA5B3B2DF67C8A102
   public key:
      04763851BE043B7FBA8855C1CB947DD3E0CC869A8FD63C33FAA3C37BDFDB0E6B3CF530C62C4BD9AA3A4F75929C1F602D68DF0092DF944A3D924FCCAC6FE22A245D
   address:
      1BLeXrujA5QW8wFnC1D8FddnGxQzTUPJNc
```

```
./testpassphrase.sh 100 "Nubian's;Fairbanks;plaza's;economy;westernizing;walkaways;commerce;codexs;balefully;horseman;stanchion;portability's;immaculate;griper;crowdfunded;flippers;westernizing;stanchion;griper;Nubian's"
ERROR: passphrase is wrong!
```

### Good passphrase
```
./makepriv.sh "Nubian's;Fairbanks;plaza's;economy;westernizing;walkaways;commerce;codex's;balefully;horseman;stanchion;portability's;immaculate;griper;crowdfunded;flippers" 100
6BE5D473A71D98FDFDE0E06ABA4DB323CF6992583FF8F12DA5B3B2DF67C8A102
```

```
./string2addr.sh "Nubian's;Fairbanks;plaza's;economy;westernizing;walkaways;commerce;codex's;balefully;horseman;stanchion;portability's;immaculate;griper;crowdfunded;flippers" 100
1BLeXrujA5QW8wFnC1D8FddnGxQzTUPJNc
```

```
./testonce.sh "Nubian's;Fairbanks;plaza's;economy;westernizing;walkaways;commerce;codex's;balefully;horseman;stanchion;portability's;immaculate;griper;crowdfunded;flippers" 100
Nubian's;Fairbanks;plaza's;economy;westernizing;walkaways;commerce;codex's;balefully;horseman;stanchion;portability's;immaculate;griper;crowdfunded;flippers	1BLeXrujA5QW8wFnC1D8FddnGxQzTUPJNc	100	0	0
```

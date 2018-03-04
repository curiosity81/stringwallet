# stringwallet
Collection of scripts for creating string wallets. Code is not optimized for speed.

## WARNINGS
USE AT YOUR OWN RISK!

THIS REPOSITORY IS FOR EDUCATIONAL PURPOSES ONLY.

ONLY SEND FUNDS TO GENERATED ADDRESSES IF YOU UNDERSTAND THE LINUX BASH SO THAT YOU ARE ABLE TO REPRODUCE POTENTIAL BUGS AND CORRESPONDING PRIVATE KEYS!

WARNING: [WEAK SEEDS](https://bitcointalk.org/index.php?topic=177389) CAN LEAD TO [FUND LOSS](https://www.deepdotweb.com/2016/02/18/hackers-make-103000-cracking-bitcoin-wallets/)! 

SOME RULES FOR STRING WALLET SEEDS:

1. NEVER USE ONLY ONE WORD WHICH CAN BE FOUND IN A DICTIONARY!
2. NEVER USE A COMBINATION OF WORDS WHICH CAN BE FOUND IN A BOOK OR IN A LIST ON THE INTERNET!
3. NEVER HASH THE SEED ONLY ONCE!
4. ALWAYS CHECK THE BLOCKCHAIN IF ADDRESS WAS ALREADY USED!

## Introduction
Having private keys in a wallet saved on some device is quite complex: Firstly, the private keys must be generated from enough entropy. Secondly, the wallet must be encrypted with an additional good, i.e., long and complex, passphrase, which must be remembered. Thirdly, the hardware the wallet is saved on should be long-living. Fourthly, one has to create several backups of the wallet, so that the loss of one ore more devices is negligible.

A good string wallet has the advantage, that only the first and second point are complex. A string wallet needs no specific hardware. In the best case, the seed can be remembered. However, memorable seeds are weak and will be [robbed quickly](https://www.reddit.com/r/Bitcoin/comments/1ndsxi/a_test_of_brainwallet_passphrases/). In the case, where the seed is hard to remember, the seed can be written down on a sheet of paper. Backups can easily be created by writing down the seed on several different sheets of paper. The sheets of paper can be hidden. Moreover, the sheets can be cut into two or more pieces, which can be stored at different places so that it is unlikly that an attacker has access to the full seed. Other versions of "two factor authentication" are possible.

## Methods
Assuming that the random generator works perfectly:

### Seeds from string
There are roughly 2^256 Bitcoin private keys. Sampling 40 characters with replacement from the set of printable characters on a standard keyboard results in ~100^40 = 2^265.754 possible strings. Assuming that hashing distributes these strings evenly between 0 and 2^256, security should be high enough. Especially, since there exist only 2^160 Bitcoin addresses such that ~2^96 private keys map to the same address.

### Seeds from word list
Also sampling words without replacement from a dictionary can generate more different lists of words than there exist Bitcoin private keys. For instance, 16 words sampled from a dictionary containing 100.000 words results in 100.000\*99.999\*...\*99.985 = 2^265.753 possible word lists.

### Hashing
Hashing the seed many times, so that the computation of the key pair slows down noticeably, further increases the complexity of a brute force attack.

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
  Creates random list of 1000 words from some dictionary and removes german umlauts. Adapt it correspondingly. Intended to create lists of words, which can be printed out. From this list, 16 to 20 or even more words can be selected to represent a new passphrase string for a string wallet.
- makepassphrase.sh \<number of iterations\> \<number of words\>:
  Creates \<number of words\> words and the corresponding keys via \<number of iterations\> hashing rounds. The last four words are used as checksum. Checksum is not necessary for deriving the private key. See examples below.  
- testpassphrase.sh \<number of iterations\> \<passphrase\>:
  Checks passphrase. Only works if passphrase has four checksum words. See examples below.

## To do
- Add secure default parameters to scripts.
- Add the possibility to generate a bunch of address from one seed.

## Examples:
### Creating seed string + checksum
```
./makepassphrase.sh 100 16
passphrase:
   Edda;nonmagnetic;fins;cleaved;suffix;Paganini's;peddlers;hut;Creation;disheveling;novelizes;contemptible;snitched;boyfriends;barnacled;Nahuatls
checksum:
   1BF7
private key:
   01C9B6EBE004D09A7738E3FFBC08243CDBBE3ADB38E9E7BBDFEA41F5E52A2655
public key:
   041D1D584B40A8A7D526CC9A6CD6561EFD3518766C9B6B77BD04018BDC50A484EF0B391FE89D37F6B57F0E86337DA0FF097D4279A9B93995F8B941F68DCC3F3ED8
address:
   1FXXPUteTEAKpRaYw22hV58ADq6JBcdsXo
size of universe:
   126187
number of possible choices:
   2^271.12188820084398622673
```

```
./testpassphrase.sh 100 "Edda;nonmagnetic;fins;cleaved;suffix;Paganini's;peddlers;hut;Creation;disheveling;novelizes;contemptible;snitched;boyfriends;barnacled;Nahuatls" "1BF7"
passphrase seems to be correct
   private key:
      01C9B6EBE004D09A7738E3FFBC08243CDBBE3ADB38E9E7BBDFEA41F5E52A2655
   public key:
      041D1D584B40A8A7D526CC9A6CD6561EFD3518766C9B6B77BD04018BDC50A484EF0B391FE89D37F6B57F0E86337DA0FF097D4279A9B93995F8B941F68DCC3F3ED8
   address:
      1FXXPUteTEAKpRaYw22hV58ADq6JBcdsXo
```

```
./testpassphrase.sh 100 "Edda;nonmagnetic;fins;cleaved;suffix;Paganini's;peddlers;hut;Creation;disheviling;novelizes;contemptible;snitched;boyfriends;barnacled;Nahuatls" "1BF7"
ERROR: passphrase is wrong!
```

### Working with seed strings
```
./makepriv.sh "Edda;nonmagnetic;fins;cleaved;suffix;Paganini's;peddlers;hut;Creation;disheveling;novelizes;contemptible;snitched;boyfriends;barnacled;Nahuatls" 100
01C9B6EBE004D09A7738E3FFBC08243CDBBE3ADB38E9E7BBDFEA41F5E52A2655
```

```
./string2addr.sh "Edda;nonmagnetic;fins;cleaved;suffix;Paganini's;peddlers;hut;Creation;disheveling;novelizes;contemptible;snitched;boyfriends;barnacled;Nahuatls" 100
1FXXPUteTEAKpRaYw22hV58ADq6JBcdsXo
```

```
./testonce.sh "Edda;nonmagnetic;fins;cleaved;suffix;Paganini's;peddlers;hut;Creation;disheveling;novelizes;contemptible;snitched;boyfriends;barnacled;Nahuatls" 100
Edda;nonmagnetic;fins;cleaved;suffix;Paganini's;peddlers;hut;Creation;disheveling;novelizes;contemptible;snitched;boyfriends;barnacled;Nahuatls	1FXXPUteTEAKpRaYw22hV58ADq6JBcdsXo	100	0	0
```

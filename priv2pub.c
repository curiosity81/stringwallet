// https://stackoverflow.com/questions/12480776/how-do-i-obtain-the-public-key-from-an-ecdsa-private-key-in-openssl
// using figures on: https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses
// gcc -Wall <file_name>.c -o <file_name> -lcrypto -std=c99
#include <stdio.h>
#include <stdlib.h>
#include <openssl/ec.h>
#include <openssl/obj_mac.h>
#include <openssl/bn.h>

int main(int argc, char *argv[]){
   // argv[1] is the private key as hexadecimal string

   EC_KEY *eckey = NULL;
   EC_POINT *pub_key = NULL;
   BIGNUM start;
   BIGNUM *res;
   BN_CTX *ctx;
   const EC_GROUP *group = NULL;

   BN_init(&start);
   ctx = BN_CTX_new(); // ctx is an optional buffer to save time from allocating and deallocating memory whenever required

   res = &start;
   BN_hex2bn(&res,argv[1]); // string to private key
   eckey = EC_KEY_new_by_curve_name(NID_secp256k1);
   group = EC_KEY_get0_group(eckey);
   pub_key = EC_POINT_new(group);

   EC_KEY_set_private_key(eckey, res);

   // pub_key is a new uninitialized 'EC_POINT*'.
   // priv_key res is a 'BIGNUM*'.
   if (!EC_POINT_mul(group, pub_key, res, NULL, NULL, ctx))
      printf("Error at EC_POINT_mul.\n");

   EC_KEY_set_public_key(eckey, pub_key);

   char *ec_point_hex = EC_POINT_point2hex(group, pub_key, 4, ctx);
   for (int i=0; i<130; i++) // 1 byte 0x42, 32 bytes for x coordinate, 32 bytes for y coordinate
      printf("%c", ec_point_hex[i]);
   printf("\n");

   BN_CTX_free(ctx);
   free(ec_point_hex);

   return 0;
}

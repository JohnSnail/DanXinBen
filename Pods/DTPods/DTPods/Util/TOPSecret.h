
//
//  TOPSecret.h
//  snstaoban
//
//  Created by Yuliang.Wu on 12/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#ifndef TOP_SECRET_H
#define TOP_SECRET_H

#define kChosenCipherBlockSize	16
#define	kChosenCipherKeySize	16

// 加密的key 是 tb4iphone-item 的 md5 摘要
#define TOP_ENCRYPT_KEY     [NSData dataWithBytes:(uint8_t[]){0x46, 0x37, 0x45, 0x42, 0x38, 0x44, 0x42, 0x35, 0x34, 0x46, 0x36, 0x38, 0x36, 0x41, 0x45, 0x35, 0x36, 0x33, 0x43, 0x34, 0x36, 0x37, 0x44, 0x39, 0x41, 0x31, 0x42, 0x31, 0x41, 0x32, 0x36, 0x33} length:32]

// APP Secret 为 XU + 32位App Secret + XU，分成 两部分各 18 位，然后使用 上面的 TOP_ENCRYPT_KEY 进行 AES 加密
#define TOP_APP_SECRET1     [NSData dataWithBytes:(uint8_t[]){0x7b, 0x7a, 0x1c, 0x41, 0x93, 0xbe, 0xf5, 0x29, 0x12, 0x4e, 0xec, 0xdb, 0xe8, 0x47, 0xef, 0x96, 0xab, 0x59, 0xe7, 0x78, 0x69, 0x27, 0xeb, 0xaa, 0xea, 0xd9, 0xcf, 0x41, 0x27, 0x1c, 0xff, 0xfb} length:32]
#define TOP_APP_SECRET2     [NSData dataWithBytes:(uint8_t[]){0x50, 0xb3, 0x05, 0x87, 0xe3, 0x36, 0xe0, 0x51, 0x53, 0x10, 0xb0, 0xf3, 0x18, 0x76, 0xbd, 0x01, 0x0d, 0x9c, 0x58, 0xf7, 0x77, 0xbd, 0xba, 0x94, 0x14, 0x30, 0xd2, 0xf0, 0x36, 0xd2, 0xc7, 0x08} length:32]

// 物流为直接对 wuliu 的 sign 进行 AES 加密 
#define WULIU_SECRET        [NSData dataWithBytes:(uint8_t[]){0x8b, 0xfb, 0xe5, 0x3b, 0xca, 0xac, 0xd1, 0x9d, 0xfb, 0x22, 0x72, 0xbd, 0x53, 0xd4, 0x62, 0xbc} length:16]

// 登录的magic string @"18nnad7f1njdy7f23nadifu23djfdu"
#define MTOP_LOGIN_SECRET   [NSData dataWithBytes:(uint8_t[]){0x75, 0x3d, 0x1d, 0x47, 0xff, 0x06, 0xe0, 0x0e, 0xbc, 0xee, 0xaf, 0x94, 0x8b, 0xb7, 0x06, 0x9d, 0xd1, 0xd3, 0xf3, 0x5b, 0x2c, 0x62, 0x55, 0x79, 0xfe, 0x36, 0x4f, 0xbc, 0x9e, 0x41, 0x50, 0xd0} length:32]

// MD5(NSData) => NSData
#define MD5_DATA_TO_DATA(input_data, var) {\
const void *_var_ptrData = [input_data bytes];\
unsigned char _var_result[CC_MD5_DIGEST_LENGTH];\
CC_MD5( _var_ptrData, [input_data length], _var_result );\
var = [NSData dataWithBytes:_var_result length:16];\
}

// MD5(NSData) => NSString
#define MD5_DATA_TO_STRING(input_data, var) {\
NSData *_var_md5data = nil;\
MD5_DATA_TO_DATA(input_data, _var_md5data);\
const unsigned char *_var_md5_result = (const unsigned char *)[_var_md5data bytes];\
var = [NSString stringWithFormat:\
@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",\
_var_md5_result[0],  _var_md5_result[1],  _var_md5_result[2],  _var_md5_result[3],\
_var_md5_result[4],  _var_md5_result[5],  _var_md5_result[6],  _var_md5_result[7],\
_var_md5_result[8],  _var_md5_result[9],  _var_md5_result[10], _var_md5_result[11],\
_var_md5_result[12], _var_md5_result[13], _var_md5_result[14], _var_md5_result[15]\
];\
}

// AES 加密
#define AES_ENCRYPT(input_data, return_var) {\
NSData *plainText = input_data;\
NSData *aSymmetricKey = TOP_ENCRYPT_KEY;\
CCOperation encryptOrDecrypt = kCCEncrypt;\
CCOptions padding = kCCOptionPKCS7Padding;\
CCOptions *pkcs7 = &padding;\
CCCryptorStatus ccStatus = kCCSuccess;\
CCCryptorRef thisEncipher = NULL;\
NSData *cipherOrPlainText = nil;\
uint8_t * bufferPtr = NULL;\
size_t bufferPtrSize = 0;\
size_t remainingBytes = 0;\
size_t movedBytes = 0;\
size_t plainTextBufferSize = 0;\
size_t totalBytesWritten = 0;\
uint8_t * ptr;\
uint8_t iv[kChosenCipherBlockSize];\
memset((void *) iv, 0x0, (size_t) sizeof(iv));\
plainTextBufferSize = [plainText length];\
if(encryptOrDecrypt == kCCEncrypt) {\
if(*pkcs7 != kCCOptionECBMode) {\
if((plainTextBufferSize % kChosenCipherBlockSize) == 0) {\
*pkcs7 = 0x0000;\
} else {\
*pkcs7 = kCCOptionPKCS7Padding;\
}\
}\
} else if(encryptOrDecrypt != kCCDecrypt) {\
}\
ccStatus = CCCryptorCreate(encryptOrDecrypt, kCCAlgorithmAES128, *pkcs7, (const void *)[aSymmetricKey bytes], kChosenCipherKeySize,\
(const void *)iv, &thisEncipher);\
bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);\
bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );\
if(bufferPtr == NULL) abort(0);\
memset((void *)bufferPtr, 0x0, bufferPtrSize);\
ptr = bufferPtr;\
remainingBytes = bufferPtrSize;\
ccStatus = CCCryptorUpdate(thisEncipher, (const void *) [plainText bytes], plainTextBufferSize, ptr, remainingBytes, &movedBytes);\
ptr += movedBytes;\
remainingBytes -= movedBytes;\
totalBytesWritten += movedBytes;\
ccStatus = CCCryptorFinal(thisEncipher, ptr, remainingBytes, &movedBytes);\
totalBytesWritten += movedBytes;\
if(thisEncipher) {\
(void) CCCryptorRelease(thisEncipher);\
thisEncipher = NULL;\
}\
if (ccStatus == kCCSuccess)\
cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];\
else\
cipherOrPlainText = nil;\
if(bufferPtr) free(bufferPtr);\
bufferPtr=NULL;\
return_var = cipherOrPlainText;\
}

// AES 解密
#define AES_DECRYPT(input_data, return_var) {\
NSData *plainText = input_data;\
NSData *aSymmetricKey = TOP_ENCRYPT_KEY;\
CCOperation encryptOrDecrypt = kCCDecrypt;\
CCOptions padding = kCCOptionPKCS7Padding;\
CCOptions *pkcs7 = &padding;\
CCCryptorStatus ccStatus = kCCSuccess;\
CCCryptorRef thisEncipher = NULL;\
NSData * cipherOrPlainText = nil;\
uint8_t * bufferPtr = NULL;\
size_t bufferPtrSize = 0;\
size_t remainingBytes = 0;\
size_t movedBytes = 0;\
size_t plainTextBufferSize = 0;\
size_t totalBytesWritten = 0;\
uint8_t * ptr;\
uint8_t iv[kChosenCipherBlockSize];\
memset((void *) iv, 0x0, (size_t) sizeof(iv));\
plainTextBufferSize = [plainText length];\
if(encryptOrDecrypt == kCCEncrypt) {\
if(*pkcs7 != kCCOptionECBMode) {\
if((plainTextBufferSize % kChosenCipherBlockSize) == 0) {\
*pkcs7 = 0x0000;\
} else {\
*pkcs7 = kCCOptionPKCS7Padding;\
}\
}\
} else if(encryptOrDecrypt != kCCDecrypt) {\
}\
ccStatus = CCCryptorCreate(encryptOrDecrypt, kCCAlgorithmAES128, *pkcs7, (const void *)[aSymmetricKey bytes], kChosenCipherKeySize,\
(const void *)iv, &thisEncipher);\
bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);\
bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );\
if(bufferPtr == NULL) abort(0);\
memset((void *)bufferPtr, 0x0, bufferPtrSize);\
ptr = bufferPtr;\
remainingBytes = bufferPtrSize;\
ccStatus = CCCryptorUpdate(thisEncipher, (const void *) [plainText bytes], plainTextBufferSize, ptr, remainingBytes, &movedBytes);\
ptr += movedBytes;\
remainingBytes -= movedBytes;\
totalBytesWritten += movedBytes;\
ccStatus = CCCryptorFinal(thisEncipher, ptr, remainingBytes, &movedBytes);\
totalBytesWritten += movedBytes;\
if(thisEncipher) {\
(void) CCCryptorRelease(thisEncipher);\
thisEncipher = NULL;\
}\
if (ccStatus == kCCSuccess){\
cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];}\
else{\
cipherOrPlainText = nil;}\
if(bufferPtr) free(bufferPtr);\
bufferPtr=NULL;\
return_var = cipherOrPlainText;\
}

// 获取 TOP 的 App Secret
#define GET_APP_SECRET(var) {\
NSData *_var_p1;\
NSData *_var_p2;\
/*AES_DECRYPT(TOP_APP_SECRET1, _var_p1);\
AES_DECRYPT(TOP_APP_SECRET2, _var_p2);\*/\
AES_DECRYPT(topAppSecretPart1, _var_p1);\
AES_DECRYPT(topAppSecretPart2, _var_p2);\
var = [NSMutableData dataWithData:[_var_p1 subdataWithRange:NSMakeRange(2, 16)]];\
[(NSMutableData *)var appendData:[_var_p2 subdataWithRange:NSMakeRange(0, 16)]];\
}

// 获取物流的 Secret
#define GET_WULIU_SECRET(var) {\
AES_DECRYPT(WULIU_SECRET, var);\
}

// 对 TOP 请求数据签名
#define TOP_SIGN(input_data, var) {\
NSData *_var_secret;\
GET_APP_SECRET(_var_secret);\
NSMutableData *_var_data = [NSMutableData dataWithData:_var_secret];\
[_var_data appendData:input_data];\
[_var_data appendData:_var_secret];\
MD5_DATA_TO_STRING(_var_data, var);\
}

// 对Wap登录请求签名
#define MTOP_LOGIN_SIGN(input_data1, input_data2, var) {\
NSData *_var_secret;\
GET_APP_SECRET(_var_secret);\
NSMutableData *_var_data = [NSMutableData dataWithData:input_data1];\
[_var_data appendData:_var_secret];\
[_var_data appendData:input_data2];\
NSData *_var_tmpret;\
MD5_DATA_TO_DATA(_var_data, _var_tmpret);\
var = [_var_tmpret base64EncodedString];\
}

// 对Wap登录的app secret进行md5
#define MTOP_LOGIN_SECRET_MD5(var) {\
NSData *_var_secret;\
GET_APP_SECRET(_var_secret);\
NSMutableData *_var_data = [NSMutableData dataWithData:_var_secret];\
MD5_DATA_TO_STRING(_var_data, var);\
}

// 对物流跟踪请求签名
#define WULIU_SIGN(input_data, var) {\
NSData *_var_secret;\
GET_WULIU_SECRET(_var_secret);\
NSMutableData *_var_data = [NSMutableData dataWithData:input_data];\
[_var_data appendData:_var_secret];\
NSData *_var_tmpret;\
MD5_DATA_TO_DATA(_var_data, _var_tmpret);\
var = [_var_tmpret base64EncodedString];\
}

// 对Wap登录时的密码进行MD5加密
#define MTOP_ENCRYPT_PASSWD(input_data, return_var) {\
NSData *login_sec;\
AES_DECRYPT(MTOP_LOGIN_SECRET, login_sec);\
NSMutableData *tmp_ret = [NSMutableData dataWithData:login_sec];\
[tmp_ret appendData:input_data];\
MD5_DATA_TO_STRING(tmp_ret, return_var);\
}

#endif

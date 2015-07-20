//
//  TBUtil.h
//  snstaoban
//
//  Created by chenyang on 12/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface TBUtil : NSObject

+ (NSString *)urlEncode:(NSString *)url;
+ (NSString *)gbkEncode:(NSString *)string;
+ (float)countLengthOfString:(NSString *)string Font:(UIFont *)font;
+(float) countTheLengthOfString:(NSString *)string Font:(UIFont *)font;
+(float) countTheHeightOfString:(NSString *)string Font:(UIFont *)font withWidth:(float) width height:(float) height;

+ (float)countHeightOfString:(NSString *)string WithWidth:(float)width Font:(UIFont *)font;
+ (NSString *)dateWithTime:(NSTimeInterval)time;
+ (NSString *)dateWithTimeWithoutYear:(NSTimeInterval)time;
+ (NSString *)formatDate:(NSTimeInterval)time;
+ (NSString *)formatListDate:(NSTimeInterval)time;
+ (NSString *)formatDetailDate:(NSTimeInterval)time;
+ (NSString *)encodeTaobaoNick:(NSString *)nick;
+ (UIImage *)getSellerLevelImage:(NSInteger )level;
+ (UIImage *)getBuyerLevelImage:(NSInteger )level;

//RSA计算加密后的密码
+(NSString *) rsaEncrypt:(NSString *)data pubKey:(NSString *) pubkey;

//已登录状态下数字签名
+(NSString *) md5:(NSData *) data;
+(NSData *) md5Data:(NSData *) data;

///////////////////////////////////////////////////
//
//     ecode    ------- 登录成功后，返回的加签参数
//     APPSecret------- 客户端申请的token申请字段
//     API ------------ 调用的服务端接口的名称
//     Version -------- 调用后台接口版本号
//     IMEI ----------- 手机序列号
//     IMSI ----------- 手机卡序列号
//     DATA ----------- 对应调用业务接口的业务参数，以json字串形式输入
//     TIME ----------- 当前的时间戳
//
//     

+(NSString *) loginedStatusMD5WithEcode:(NSString *) ecode APPSecret:(NSString *) appSecret APPKey:(NSString *) appkey API:(NSString *) api Version:(NSString *) version IMEI:(NSString *) imei IMSI:(NSString *) imsi DATA:(NSString *) data TIME:(NSString *) time;

+(NSString *) handleSpecialCharactorsInPhoneNumber:(NSString *) phoneNumber;
+(NSString *) isMobileNumber:(NSString *) phoneNumber;
+(BOOL) isAllChinese:(NSString *) character;

+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
+(NSDate *)dateFromString:(NSString *)dateString;
+(NSString *)stringFromDate:(NSDate *)date;

@end

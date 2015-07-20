//
//  Util.h
//  duotin2.0
//
//  Created by Vienta on 5/9/14.
//  Copyright (c) 2014 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceHardware.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, iPhoneInch) {
    iPhoneInch_Unkown,
    iPhoneInch_3_5,
    iPhoneInch_4_0,
    iPhoneInch_4_7,
    iPhoneInch_5_5
};

@interface Util : NSObject



+ (NSString *)getBundleFilePath:(NSString*)filename type:(NSString* )ext;
+ (NSString *)getBundleFilePathWithFull:(NSString *)fullName;
+ (NSString *)getDocumentFilePath:(NSString *)fileName;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (NSString *)macAddress;
+ (iPhoneInch)phoneInch;
+ (BOOL)validateMobile:(NSString *)mobile;
+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validateIdentityCard:(NSString *)ID;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/**
 * 用来画圆
 *
 *  @param view
 *  @param rd
 *  @param color
 *  @param width
 */
+ (void)drawRoundView:(UIView *)view radius:(float)rd borderColor:(UIColor *)color width:(float)width;

/**
 *  将view变圆
 *
 *  @param view 
 */
+ (void)circleView:(UIView *)view;

/**
 *  获得当前时间 格式为YYYY-MM-dd hh:mm:ss
 *
 *  @return 字符串
 */
+ (NSString *)getCurrentTime;


/**
 *  获得disk大小
 */
+ (void)getDiskspace:(void (^)(NSString*, NSString *))spaceBlk;

/**
 *  获得文件夹大小
 *
 *  @param folderPath 文件夹路径
 *
 *  @return 大小 bytes
 */
+ (unsigned long long int)sizeOfFolder:(NSString *)folderPath;

/**
 *  获得文件大小
 *
 *  @param filePath 文件路径
 *
 *  @return 大小 bytes
 */
+ (unsigned long long int)sizeOfFile:(NSString *)filePath;

/**
 *  获得纯色图片
 *
 *  @param color
 *  @param size
 *
 *  @return image
 */
+ (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size;


+ (NSString *)formatFromNumber:(NSNumber*)num;

//将秒格式化成hhiiss
+ (NSString *)formatIntoDateWithSecond:(NSNumber *)sec;

//将str转化为nsnumber 如果不成功返回nil
+ (NSNumber *)convertToNumberWithString:(NSString *)str;

@end

//
//  Util.m
//  duotin2.0
//
//  Created by Vienta on 5/9/14.
//  Copyright (c) 2014 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import "Util.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation Util

+ (NSString *)getDocumentFilePath:(NSString *)fileName
{
    NSString *result = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    return result;
}

+ (NSString *)getBundleFilePathWithFull:(NSString *)fullName
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fullName];
}

+ (NSString *)getBundleFilePath:(NSString*)filename type:(NSString* )ext
{
    return [[NSBundle mainBundle] pathForResource:filename ofType:ext];
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    // For iOS >= 5.1
    NSError *error = nil;
    [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}

+ (NSString *)macAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

+ (iPhoneInch)phoneInch
{
    IPhoneInchType inchType = [DeviceHardware inchType];
    if (inchType == IPhoneInchType_3_5)
        return iPhoneInch_3_5;
    if (inchType == IPhoneInchType_4_0)
        return iPhoneInch_4_0;
    if (inchType == IPhoneInchType_4_7)
        return iPhoneInch_4_7;
    if (inchType == IPhoneInchType_5_5)
        return iPhoneInch_5_5;
    if (inchType == IPhoneInchType_Unkown)
        return iPhoneInch_Unkown;
    if (inchType == IPhoneInchType_Simulator) {
        BOOL isIphone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
        if (isIphone && [[UIScreen mainScreen] bounds].size.height == 480.0)
            return iPhoneInch_3_5;
        if (isIphone && [[UIScreen mainScreen] bounds].size.height == 568.0)
            return iPhoneInch_4_0;
        if (isIphone && [[UIScreen mainScreen] bounds].size.height == 667.0)
            return iPhoneInch_4_7;
        if (isIphone && [[UIScreen mainScreen] bounds].size.height == 736.0)
            return iPhoneInch_5_5;
    }
    return iPhoneInch_Unkown;
}

+ (BOOL)validateMobile:(NSString *)mobile
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188 ,1705 170号为新增加的号码
     * 联通：130,131,132,152,155,156,185,186 ,1709
     * 电信：133,1349,153,180,189 ,1700
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[0])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        || ([regextestcm evaluateWithObject:mobile] == YES)
        || ([regextestct evaluateWithObject:mobile] == YES)
        || ([regextestcu evaluateWithObject:mobile] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPre evaluateWithObject:email];
}

+ (BOOL)validateIdentityCard:(NSString *)ID
{
    BOOL flag;
    if (ID.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:ID];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)drawRoundView:(UIView *)view radius:(float)rd borderColor:(UIColor *)color width:(float)width
{
    view.layer.cornerRadius = rd;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = width;
}

+ (void)circleView:(UIView *)view
{
    view.layer.cornerRadius = CGRectGetMidX(view.bounds);
    view.layer.masksToBounds = YES;
}

+ (NSString *)getCurrentTime
{
    NSString *dateStr = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];//http://stackoverflow.com/questions/5283539/hours-in-nsdate-everytime-in-24-hour-style 强制转化为24小时制
    [formatter setLocale:formatterLocale];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//hh:12小时 HH:24小时
    dateStr = [formatter stringFromDate:[NSDate date]];

    return dateStr;
}

+ (void)getDiskspace:(void (^)(NSString*, NSString *))spaceBlk
{
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];
    
    if (dic) {
        NSNumber *fileSystemSizeInBytes = dic[NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = dic[NSFileSystemFreeSize];
        
        float freeSpace = [freeFileSystemSizeInBytes floatValue];
        float totalSpace = [fileSystemSizeInBytes floatValue];
        
        NSString *freeSpaceString = [NSString stringWithFormat:@"%0.2fG",(freeSpace) /1024/1024/1024];
        NSString *totalSpaceString = [NSString stringWithFormat:@"%0.2fG", totalSpace/1024/1024/1024];
        spaceBlk(freeSpaceString,totalSpaceString);
    }
}

+ (unsigned long long int)sizeOfFolder:(NSString *)folderPath
{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long int folderSize = 0;
    
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }
    return folderSize;
    
//    //This line will give you formatted size from bytes ....
//    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:folderSize countStyle:NSByteCountFormatterCountStyleFile];
//    return folderSizeStr;
}

+ (unsigned long long int)sizeOfFile:(NSString *)filePath
{
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] integerValue];
    return fileSize;
//    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
//    return fileSizeStr;
}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSString *)formatFromNumber:(NSNumber *)num
{
//    100000  10.0万
//    10000     10000
    //999999  99.9
    //9999999  999.9万
    NSString *formatStr = nil;
    long long longNum = [num longLongValue];
    if (longNum > 100000) {
        long long decade = longNum / 10000;
        long long decimal = (longNum - decade * 10000) / 1000;
        formatStr = [NSString stringWithFormat:@"%@.%@万",@(decade), @(decimal)];
    } else {
        formatStr = [NSString stringWithFormat:@"%@", num];
    }
    return formatStr;
}

+ (NSString *)formatIntoDateWithSecond:(NSNumber *)sec
{
    NSUInteger h = [sec unsignedIntegerValue] / 3600;
    NSUInteger m = ([sec unsignedIntegerValue] / 60) % 60;
    NSUInteger s = [sec unsignedIntegerValue] % 60;
    
    NSString *formatteTime = nil;
    if (h == 0) {
        formatteTime = [NSString stringWithFormat:@"%02u:%02u",m,s];
    } else {
        formatteTime = [NSString stringWithFormat:@"%u:%02u:%02u",h,m,s];
    }
    return formatteTime;
}

+ (NSNumber *)convertToNumberWithString:(NSString *)str
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *convertNumber = [numberFormatter numberFromString:str];
    return convertNumber;
}

@end

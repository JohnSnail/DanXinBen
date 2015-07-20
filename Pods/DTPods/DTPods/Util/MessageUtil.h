//
//  MessageUtil.h
//  snstaoban
//
//  Created by junzhan on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(forNSNull)
- (id)objectForKeySafely:(id)aKey;
@end

@interface NSNull(forNSDictionary)
- (id)objectForKeySafely:(id)aKey;
@end

@interface NSString(forEmpty)

-(BOOL)isEmpty;

@end

@interface MessageUtil : NSObject
+ (BOOL) isEmpty:(NSString *)string;
+ (NSString *)stringFromHtml:(NSString *)htmlStr;

+(NSString*)fromCentToYuan:(NSInteger)cent;

//日期转换成字符串
+(NSString*)dateFormat:(NSDate*)date format:(NSString*)format;
//字符串转换成日期
+(NSDate*)dateFromString:(NSString*)dateStr;

+(NSString*)dateInterStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end



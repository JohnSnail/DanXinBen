//
//  MessageUtil.m
//  snstaoban
//
//  Created by junzhan on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageUtil.h"

@implementation NSDictionary(forNSNull)
//处理json含有null的情况
- (id)objectForKeySafely:(id)aKey{
    if(self == nil || self == (id)[NSNull null]){
        NSLog(@"NSDictionary warning:nsdictionary为nil");
        return nil;
    }
    id value = [self objectForKey:aKey];
    if (value == nil || value == (id)[NSNull null]) {
        if(value == (id)[NSNull null]) NSLog(@"NSDictionary warning:(key=%@,value=NSNull)", aKey);
        return nil;
    }else
        return value;
}
@end

@implementation NSNull(forNSDictionary)
- (id)objectForKeySafely:(id)aKey{
    NSLog(@"NSDictionary warning:nsdictionary为NSNull key=%@", aKey);
    return nil;
}
@end

@implementation NSString(forEmpty)

-(BOOL)isEmpty
{
    return self == nil || [@"" isEqualToString:self] || [@"(null)" isEqualToString:self];
}

@end


@implementation MessageUtil

+ (BOOL) isEmpty:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return string == nil || [@"" isEqualToString:string] || [@"(null)" isEqualToString:string];
}

//将包含html关键字的字符&lt;&gt;还原回来
+ (NSString *)stringFromHtml:(NSString *)htmlStr{
    if(htmlStr == nil) return htmlStr;
    NSDictionary *htmlDict = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"&ensp;",  @"", @"&emsp;",  @" ", @"&nbsp;",
                              @"<", @"&lt;", @">", @"&gt;",
                              @"&", @"&amp;", @"\\\"", @"&quot;", //quot不能要直接换成\"否则可能会破坏json
                              @"©", @"&copy;", @"®", @"&reg;",
                              @"×", @"&times;", @"÷", @"&divide;",
                              @"–", @"&ndash;", @"—", @"&mdash;",
                              @"ˆ", @"&circ;", @"˜", @"&tilde;",
                              @"‘", @"&lsquo;", @"’", @"&rsquo;",
                              @"‚", @"&sbquo;", @"“", @"&ldquo;",
                              @"”", @"&rdquo;", @"", @"&bdquo;",
                              @"‹", @"&lsaquo;", @"›", @"&rsaquo;",
                              @"·", @"&middot;", @"", @"&#039;", 
                              @"…", @"&hellip;", @"∩", @"&cap;", nil];
    NSString *newStr = htmlStr;
    for (NSString *key in [htmlDict allKeys]) {
        newStr = [newStr stringByReplacingOccurrencesOfString:key withString:[htmlDict objectForKey:key]];
    }
    return newStr;
}

+(NSString*)fromCentToYuan:(NSInteger)cent
{
    NSDecimalNumber *centDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",@(cent)]];
    NSDecimalNumber *hundred = [NSDecimalNumber decimalNumberWithString:@"100"];
    return [[centDecimal decimalNumberByDividingBy:hundred] stringValue];
}

+(NSString*)dateFormat:(NSDate*)date format:(NSString *)format
{
    if(date == nil){
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+(NSDate*)dateFromString:(NSString*)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"MMM dd, yyyy hh:mm:ss aa"];
    return [formatter dateFromString:dateStr];
}

+(NSString*)dateInterStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    double inter = [endDate timeIntervalSinceDate:startDate];
    if(inter<0){
        return  @"已过期";
    }
    int days = inter / (24*3600);
    double left = inter - days*(24*60*60);
    int hours = left /(60*60);
    left = left -  hours*(60*60);
    int minuts = left/(60);
    return [NSString stringWithFormat:@"%d天%d小时%d分钟",days,hours,minuts];
}

@end











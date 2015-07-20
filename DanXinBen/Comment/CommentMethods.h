//
//  CommentMethods.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/15.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutoRunLabel;
@interface CommentMethods : NSObject

+(UIView *)navigationTitleView:(NSString *)title;
+(UIBarButtonItem *)commendBackItem;
+ (UIImageView *)cuttingLineWithOriginx:(CGFloat)x andOriginY:(CGFloat)y;
+(NSString *)getCachesDirectory;
+(void)pushCurrentPlayVC:(UIViewController *)viewController;
+ (void)navigationPlayButtonItem:(UIButton *)btn;
+(NSString *)transformateToNSString:(NSDate *)date;
+(NSDate *)transformateToNSDate:(NSString *)string;
+(NSString *)getTargetFloderPath;
+(void)clearDocu:(NSString *)filePath;
+ (NSDate *)dateFromString:(NSString *)dateString;

+ (BOOL)needUpdateCache:(NSString *)key timeInterval:(NSTimeInterval)timeInterval;
+ (id)getLocalData:(NSString *)key;
+ (void)setLocalData:(id)value key:(NSString *)key;
+ (void)setCacheTime:(NSString *)key;
//获取搜索历史记录
+ (NSArray *)getSearchHistroy;
//存储搜索历史记录
+ (void)saveSearchHistory:(NSString *)searchStr;
+(void)deleteSearchHistory:(NSString *)searchStr;

@end

//
//  TBYCalendarUtil.h
//  tbabyiphone
//
//  Created by 周 华平 on 12-12-10.
//  Copyright (c) 2012年 taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarUtil : NSObject

+(NSString*)stringWithDate:(NSDate*)date formate:(NSString*)formate;

+(NSDate*)dateFromString:(NSString*)date formate:(NSString*)formate;

+(NSDate*)addDate:(NSDate*)date day:(NSInteger)day;

//添加month
+(NSDate*)addMonth:(NSDate*)date month:(NSInteger)month;
//把时间置为0分0秒
+(NSDate*)zerolizeDate:(NSDate*)date;

//获得月初和月末的时间
+(NSDictionary*)monthStartAndEnd:(NSDate*)date;

//计算两个时间的时间差
+(NSString*)intervalBetweenDate:(NSDate*)date compareToDate:(NSDate*)compareToDate;

@end

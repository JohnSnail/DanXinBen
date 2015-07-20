//
//  TBYCalendarUtil.m
//  tbabyiphone
//
//  Created by 周 华平 on 12-12-10.
//  Copyright (c) 2012年 taobao.com. All rights reserved.
//

#import "CalendarUtil.h"

@implementation CalendarUtil

+(NSString*)stringWithDate:(NSDate*)date formate:(NSString*)formate
{
    NSDateFormatter *dateformatter   =  [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formate];
    return [dateformatter stringFromDate:date];
}

+(NSDate*)dateFromString:(NSString*)date formate:(NSString*)formate
{
    NSDateFormatter *dateformatter   =  [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formate];
    return [dateformatter dateFromString:date];
}

+(NSDate*)addDate:(NSDate*)date day:(NSInteger)day{
    NSCalendar *calendar  =  [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    return [calendar dateByAddingComponents:comps toDate:date options:0];
}

+(NSDate*)addMonth:(NSDate*)date month:(NSInteger)month
{
    NSCalendar *calendar   = [NSCalendar currentCalendar];
    NSDateComponents *comps  = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    return [calendar dateByAddingComponents:comps toDate:date options:0];
}


+(NSDictionary*)monthStartAndEnd:(NSDate*)date
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSCalendar *calendar  =  [NSCalendar currentCalendar];
    NSDateComponents *comps  = [ calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    NSDate *startDate  =  [calendar dateFromComponents:comps];
    
    NSDateComponents *endComps = [comps copy];
    [endComps setMonth:comps.month+1];
    NSDate *endDate  = [calendar dateFromComponents:endComps];
    
    [dictionary setObject:startDate forKey:@"startDate"];
    [dictionary setObject:endDate  forKey:@"endDate"];
    
    return dictionary;
}


+(NSDate*)zerolizeDate:(NSDate*)date
{
    NSCalendar *calendar  = [NSCalendar currentCalendar];
    NSDateComponents *comps  = [calendar components:	NSYearCalendarUnit|NSMonthCalendarUnit| NSDayCalendarUnit
                                           fromDate:date];
    NSDate *newDate  =  [calendar dateFromComponents:comps];
    return newDate;
}

+(NSString*)intervalBetweenDate:(NSDate *)date compareToDate:(NSDate *)compareToDate
{
    NSCalendar *calendar  = [NSCalendar currentCalendar];
    NSDateComponents *datecomps  = [calendar components:	NSYearCalendarUnit|NSMonthCalendarUnit| NSDayCalendarUnit
                                           fromDate:date];
    
    NSDateComponents *comparedDateComp  = [calendar components:	NSYearCalendarUnit|NSMonthCalendarUnit| NSDayCalendarUnit
                                                      fromDate:compareToDate];
    
    
    NSInteger year = 0;
    NSInteger month  = 0;
    NSInteger day = 0;
    if(comparedDateComp.year < datecomps.year ){ //要超过一年的
            year  = datecomps.year - comparedDateComp.year;
    }
    
    if(comparedDateComp.month < datecomps.month ){
        month = datecomps.month - comparedDateComp.month;
    }else if(comparedDateComp.month > datecomps.month){
        month  = 12 - comparedDateComp.month + datecomps.month;
        year = year -1;
    }
    
    if(comparedDateComp.day < datecomps.day){
        day  = datecomps.day - comparedDateComp.day;
    }else if(comparedDateComp.day > datecomps.day){
        if(comparedDateComp.month==1 || comparedDateComp.month ==3 || comparedDateComp.month == 5 || comparedDateComp.month ==7 || comparedDateComp.month ==8 ||comparedDateComp.month ==10 || comparedDateComp.month ==12){
            day  = 31 - comparedDateComp.day + datecomps.day;
        }
        if(comparedDateComp.month == 2  && year %4 ==0 ){
            day  = 29 - comparedDateComp.day + datecomps.day;
        }
        if(comparedDateComp.month == 2 && year %4 !=0) {
            day =  28  - comparedDateComp.day + datecomps.day;
        }
        if(comparedDateComp.month == 4||comparedDateComp.month == 6||comparedDateComp.month ==9||comparedDateComp.month == 11){
            day =  30  - comparedDateComp.day + datecomps.day;
        }
        month = month - 1;
    }
    

    if(month < 0 && year >0){
        year = year -1;
        month = month + 12;
    }

    NSMutableString *mutableString  =  [[NSMutableString alloc] init];
    
    if(year != 0 && month ==0 && day ==0){
        [mutableString appendFormat:@"这天宝宝%@岁生日",@(year)];
        return mutableString;
    }
    if(year == 0 && month ==1 && day ==0){
        [mutableString appendFormat:@"这天宝宝满月了"];
        return mutableString;
    }
    if(year == 0 && month ==0&& day ==0 ){
        [mutableString appendFormat:@"宝宝今天出生"];
        return mutableString;
    }

    [mutableString appendFormat:@"宝宝出生"];
    if(year > 0 ){
        [mutableString appendFormat:@"%@年",@(year)];
    }
    if(month >0 ){
        [mutableString appendFormat:@"%@个月",@(month)];
    }
    if((year > 0 && month ==0) && day > 0){
        [mutableString appendFormat:@"零%@天",@(day)];
    }else if(day > 0){
        [mutableString appendFormat:@"%@天",@(day)];
    }
   

    
    return mutableString;
}

@end

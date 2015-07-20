//
//  DownList.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/22.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "DownList.h"
#import "SDBManager.h"

@implementation DownList
+ (DownList *)sharedManager
{
    static DownList *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)createDataBase
{
    FMResultSet *set=[_db executeQuery:@"select count(*) from sqlite_master where type ='table' and name = 'downList'"];
    [set next];
    
    NSInteger count=[set intForColumn:0];
    
    BOOL existTable=!!count;
    
    if (existTable) {
        // TODO:是否更新数据库
        //[AppDelegate showStatusWithText:@"数据库已经存在" duration:2];
    } else {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE DownList (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,track_id VARCHAR(50),title VARCHAR(50),play_mp3_url_32 VARCHAR(100),duration VARCHAR(100),play_count VARCHAR(50),data_order VARCHAR(50))";
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            //[AppDelegate showStatusWithText:@"数据库创建失败" duration:2];
        } else {
            //[AppDelegate showStatusWithText:@"数据库创建成功" duration:2];
        }
    }
}

@end

//
//  HistoryList.h
//  DanXinBen
//
//  Created by Jiangwei on 14/11/3.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "TrackItem.h"

@interface HistoryList : NSObject
{
    FMDatabase *_db;
}

//创建单例
+ (HistoryList *)sharedManager;

//创建数据库
-(void)createDataBase;

//保存一条记录
-(void)saveContent:(TrackItem *)trackModel;

//删除一条记录
-(void)deleteContent:(TrackItem *)trackModel;

//删除所有记录
-(void)deleteAllContent;

//修改节目信息
-(void)mergeWithContent:(TrackItem *)trackModel;

//获取收听历史列表数据
-(NSArray *)getHistoryListData;

//更新播放model
-(TrackItem *)updateModel:(TrackItem *)model;

@end

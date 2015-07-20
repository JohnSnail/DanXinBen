//
//  DownList.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/22.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackItem.h"

@interface DownList : NSObject
+ (DownList *)sharedManager;

//创建数据库
-(void)createDataBase;

//保存一条记录
-(void)saveContent:(TrackItem *)trackModel;

//删除一条记录
-(void)deleteContent:(TrackItem *)trackModel;

//修改节目信息
-(void)mergeWithContent:(TrackItem *)trackModel;

//获取下载节目数据
-(NSArray *)findDownListData:(NSString *)downStatus;

//获取下载完成内页数据
-(NSArray *)getAlbumContentData:(NSInteger)album_id andRank:(NSString *)rank;

//判断是否已下载
-(BOOL)exist:(NSInteger)track_id;

@end

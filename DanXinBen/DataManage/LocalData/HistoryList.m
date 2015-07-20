//
//  HistoryList.m
//  DanXinBen
//
//  Created by Jiangwei on 14/11/3.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "HistoryList.h"
#import "SDBManager.h"
#import <util.h>
#import "CommentMethods.h"

@implementation HistoryList

+ (HistoryList *)sharedManager
{
    static HistoryList *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(id)init{
    self=[super init];
    
    if (self) {
        //========== 首先查看有没有建立下载模块的数据库，如果未建立，则建立数据库=========
        _db=[SDBManager defaultDBManager].dataBase;
        [self createDataBase];
    }
    return self;
}

-(void)createDataBase
{
    FMResultSet *set=[_db executeQuery:@"select count(*) from sqlite_master where type ='table' and name = 'HistoryList'"];
    [set next];
    
    NSInteger count=[set intForColumn:0];
    
    BOOL existTable=!!count;
    
    if (existTable) {
        // TODO:是否更新数据库
        //[AppDelegate showStatusWithText:@"数据库已经存在" duration:2];
    } else {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE HistoryList (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,track_id VARCHAR(50),title VARCHAR(50), play_mp3_url_32 VARCHAR(100),duration VARCHAR(50),play_count VARCHAR(50),data_order VARCHAR(50),hisProgress VARCHAR(50),album_id VARCHAR(50),album_title VARCHAR(50),album_imageUrl VARCHAR(50),update_data VARCHAR(50))";
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            //[AppDelegate showStatusWithText:@"数据库创建失败" duration:2];
        } else {
            //[AppDelegate showStatusWithText:@"数据库创建成功" duration:2];
        }
    }
}

-(void)saveContent:(TrackItem *)trackModel
{
    if ([self exist:trackModel.track_id.integerValue])
    {
        [self mergeWithContent:trackModel];
        return;
    }
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO HistoryList"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:100];
    if (trackModel.track_id) {
        [keys appendString:@"track_id,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.track_id];
    }
    if (trackModel.title) {
        [keys appendString:@"title,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.title];
    }
    if (trackModel.play_mp3_url_32) {
        [keys appendString:@"play_mp3_url_32,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.play_mp3_url_32];
    }
    if (trackModel.duration) {
        [keys appendString:@"duration,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.duration];
    }
    if (trackModel.play_count) {
        [keys appendString:@"play_count,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.play_count];
    }
    if (trackModel.data_order) {
        [keys appendString:@"data_order,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.data_order];
    }
    if (trackModel.hisProgress.doubleValue) {
        [keys appendString:@"hisProgress,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.hisProgress];
    }
    if (trackModel.album.album_id) {
        [keys appendString:@"album_id,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.album.album_id];
    }
    if (trackModel.album.title) {
        [keys appendString:@"album_title,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.album.title];
    }
    if (trackModel.album.image_url) {
        [keys appendString:@"album_imageUrl,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.album.image_url];
    }
    if (trackModel.update_data) {
        [keys appendString:@"update_data,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.update_data];
    }
    
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    //    NSLog(@"%@",query);
    //[AppDelegate showStatusWithText:@"插入一条数据" duration:2.0];
    [_db executeUpdate:query withArgumentsInArray:arguments];
}

-(BOOL)exist:(NSInteger)track_id
{
    BOOL extst=NO;
    NSString * query = @"SELECT track_id FROM HistoryList";
    FMResultSet * rs = [_db executeQuery:query];
    while ([rs next])
    {
        if ( track_id == [rs intForColumn:@"track_id"]) {
            extst=YES;
            break;
        }
    }
    [rs close];
    return extst;
}

-(void)deleteContent:(TrackItem *)trackModel
{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM HistoryList WHERE track_id = '%@'",trackModel.track_id];
    //[AppDelegate showStatusWithText:@"删除一条数据" duration:2.0];
    [_db executeUpdate:query];
}

-(void)deleteAllContent
{
    NSString *query = @"DELETE FROM HistoryList";
    //[AppDelegate showStatusWithText:@"删除一条数据" duration:2.0];
    [_db executeUpdate:query];
}

-(void)mergeWithContent:(TrackItem *)trackModel
{
    if (!trackModel.track_id) {
        return;
    }
    
    NSString * query = @"UPDATE HistoryList SET";
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    
//    if (trackModel.hisProgress.doubleValue > 0) {
        [temp appendFormat:@" hisProgress = '%@',",trackModel.hisProgress];
//    }
    if (trackModel.update_data) {
        [temp appendFormat:@" update_data = '%@',",trackModel.update_data];
    }
    
    [temp appendString:@")"];
    query = [query stringByAppendingFormat:@"%@ WHERE track_id = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],trackModel.track_id];
    //    NSLog(@"%@",query);
    
    //[AppDelegate showStatusWithText:@"修改一条数据" duration:2.0];
    [_db executeUpdate:query];
}

-(NSArray *)getHistoryListData
{
    NSString * query = @"SELECT track_id,title,play_mp3_url_32,duration,play_count,data_order,hisProgress,album_id,album_title,album_imageUrl,update_data FROM HistoryList ORDER BY uid DESC";
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        TrackItem * model = [TrackItem new];
        model.track_id = @([rs intForColumn:@"track_id"]);
        model.title = [rs stringForColumn:@"title"];
        model.play_mp3_url_32 = [rs stringForColumn:@"play_mp3_url_32"];
        model.duration = [rs stringForColumn:@"duration"];
        model.hisProgress = @([rs intForColumn:@"hisProgress"]);
        model.update_data = [rs stringForColumn:@"update_data"];
        
        AlbumItem *albumModel = [[AlbumItem alloc]init];
        albumModel.album_id = @([rs intForColumn:@"album_id"]);
        albumModel.title = [rs stringForColumn:@"album_title"];
        albumModel.image_url = [rs stringForColumn:@"album_imageUrl"];
        
        model.album = albumModel;
        
        [array addObject:model];
    }
    [rs close];
    
    //数组排序
    NSArray *sortedArray = [array sortedArrayUsingComparator:^(TrackItem *obj1, TrackItem *obj2){
        NSDate *date1 = [CommentMethods dateFromString:obj1.update_data];
        NSDate *date2 = [CommentMethods dateFromString:obj2.update_data];
        return [date2 compare:date1];
    }];
    
    return sortedArray;
}

-(TrackItem *)updateModel:(TrackItem *)model
{
    NSString * query = [NSString stringWithFormat:@"SELECT hisProgress FROM HistoryList WHERE track_id = '%@'",model.track_id];
    
    FMResultSet * rs = [_db executeQuery:query];
    while ([rs next]) {
        TrackItem * model = [TrackItem new];
        model.hisProgress = @([rs intForColumn:@"hisProgress"]);
        return model;
    }
    [rs close];
    return nil;
}

@end

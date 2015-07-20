//
//  DownList.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/22.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "DownList.h"
#import "SDBManager.h"
#import <Util.h>

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
    FMResultSet *set=[_db executeQuery:@"select count(*) from sqlite_master where type ='table' and name = 'DownList'"];
    [set next];
    
    NSInteger count=[set intForColumn:0];
    
    BOOL existTable=!!count;
    
    if (existTable) {
        // TODO:是否更新数据库
        //[AppDelegate showStatusWithText:@"数据库已经存在" duration:2];
    } else {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE DownList (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,track_id VARCHAR(50),title VARCHAR(50),play_mp3_url_32 VARCHAR(100),duration VARCHAR(100),play_count VARCHAR(50),data_order VARCHAR(50),downStatus VARCHAR(50),album_id VARCHAR(50),album_title VARCHAR(50),album_imageUrl VARCHAR(50),downed_date VARCHAR(50),play_times VARCHAR(50))";
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
        //        [self mergeWithContent:trackModel];
        return;
    }
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO DownList"];
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
    if (trackModel.downStatus) {
        [keys appendString:@"downStatus,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.downStatus];
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
    if (trackModel.album.downed_date) {
        [keys appendString:@"downed_date,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.album.downed_date];
    }
    if (trackModel.album.play_times) {
        [keys appendString:@"play_times,"];
        [values appendString:@"?,"];
        [arguments addObject:trackModel.album.play_times];
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

-(void)deleteContent:(TrackItem *)trackModel
{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM DownList WHERE track_id = '%@'",trackModel.track_id];
    //[AppDelegate showStatusWithText:@"删除一条数据" duration:2.0];
    [_db executeUpdate:query];
}

-(void)mergeWithContent:(TrackItem *)trackModel
{
    if (!trackModel.track_id) {
        return;
    }
    NSString * query = @"UPDATE DownList SET";
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    // xxx = xxx;
    if (trackModel.track_id) {
        [temp appendFormat:@" track_id = '%@',",trackModel.track_id];
    }
    if (trackModel.title) {
        [temp appendFormat:@" title = '%@',",trackModel.title];
    }
    if (trackModel.play_mp3_url_32) {
        [temp appendFormat:@" play_mp3_url_32 = '%@',",trackModel.play_mp3_url_32];
    }
    if (trackModel.duration) {
        [temp appendFormat:@" duration = '%@',",trackModel.duration];
    }
    if (trackModel.play_count) {
        [temp appendFormat:@" play_count = '%@',",trackModel.play_count];
    }
    if (trackModel.data_order) {
        [temp appendFormat:@" data_order = '%@',",trackModel.data_order];
    }
    if (trackModel.downStatus) {
        [temp appendFormat:@" downStatus = '%@',",trackModel.downStatus];
    }

    [temp appendString:@")"];
    query = [query stringByAppendingFormat:@"%@ WHERE track_id = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],trackModel.track_id];
    
    //[AppDelegate showStatusWithText:@"修改一条数据" duration:2.0];
    [_db executeUpdate:query];
}

-(NSArray *)getDowningData
{
    NSString * query = @"SELECT track_id,title,play_mp3_url_32,duration,play_count,data_order,downStatus FROM DownList WHERE downStatus = 'doing' ORDER BY uid ASC";
        
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        TrackItem * model = [TrackItem new];
        model.track_id = @([rs intForColumn:@"track_id"]);
        model.title = [rs stringForColumn:@"title"];
        model.play_mp3_url_32 = [rs stringForColumn:@"play_mp3_url_32"];
        model.duration = [rs stringForColumn:@"duration"];
        model.play_count = @([rs intForColumn:@"play_count"]);
        model.data_order = @([rs intForColumn:@"data_order"]);
        model.downStatus = [rs stringForColumn:@"downStatus"];

        [array addObject:model];
        
    }
    [rs close];
    return array;
}

-(NSArray *)getDownedData:(NSNumber *)album_id
{
    NSString * query = [NSString stringWithFormat:@"SELECT track_id,title,play_mp3_url_32,duration,play_count,data_order,downStatus,album_id FROM DownList  WHERE downStatus = 'done' and album_id = '%@' ORDER BY uid ASC",album_id];
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        TrackItem * model = [TrackItem new];
        model.track_id = @([rs intForColumn:@"track_id"]);
        model.title = [rs stringForColumn:@"title"];
        model.play_mp3_url_32 = [rs stringForColumn:@"play_mp3_url_32"];
        model.duration = [rs stringForColumn:@"duration"];
        model.play_count = @([rs intForColumn:@"play_count"]);
        model.data_order = @([rs intForColumn:@"data_order"]);
        model.downStatus = [rs stringForColumn:@"downStatus"];
        
        [array addObject:model];
    }
    [rs close];
    
    NSArray *sortedArray = [array sortedArrayUsingComparator:^(TrackItem *obj1, TrackItem *obj2){
        NSNumber *date1 = obj1.data_order;
        NSNumber *date2 = obj2.data_order;
        return [date1 compare:date2];
    }];
    
    return sortedArray;
}

-(BOOL)exist:(NSInteger)track_id
{
    BOOL extst = NO;
    NSString * query = @"SELECT track_id FROM DownList";
    FMResultSet * rs = [_db executeQuery:query];
    while ([rs next])
    {
        if ( track_id == [rs intForColumn:@"track_id"]) {
            extst = YES;
            break;
        }
    }
    [rs close];
    return extst;
}

-(NSArray *)getAlbumData
{
    NSString * query = @"SELECT  album_id,downStatus,album_title,album_imageUrl,count(album_id),downed_date,play_times FROM DownList WHERE downStatus = 'done' group by album_id";
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        AlbumItem * model = [AlbumItem new];
        model.album_id = @([rs intForColumn:@"album_id"]);
        model.title = [rs stringForColumn:@"album_title"];
        model.image_url = [rs stringForColumn:@"album_imageUrl"];
        model.track_nums = @([rs intForColumn:@"count(album_id)"]);
        model.play_times = @([rs intForColumn:@"play_times"]);
        model.downed_date = [CommentMethods transformateToNSDate:[rs stringForColumn:@"downed_date"]];
        
        if (model.album_id.integerValue != 0)
        {
            [array addObject:model];
        }
    }
    [rs close];
    
    //数组排序
    NSArray *sortedArray = [array sortedArrayUsingComparator:^(AlbumItem *obj1, AlbumItem *obj2){
        NSDate *date1 = obj1.downed_date;
        NSDate *date2 = obj2.downed_date;
        return [date2 compare:date1];
    }];
    
    return sortedArray;
}


@end

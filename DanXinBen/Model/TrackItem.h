//
//  TrackItem.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/15.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumItem.h"

@interface TrackItem : NSObject

@property (nonatomic, strong) NSNumber *track_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *play_mp3_url_32;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, strong) NSNumber *play_count;
@property (nonatomic, strong) NSNumber *data_order;
@property (nonatomic, strong) NSNumber *file_size;
@property (nonatomic, strong) AlbumItem *album;

@property (nonatomic, copy) NSString *downStatus;

//收听历史专用
@property (nonatomic, strong)NSNumber *hisProgress;
@property (nonatomic, strong) NSString *update_data;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

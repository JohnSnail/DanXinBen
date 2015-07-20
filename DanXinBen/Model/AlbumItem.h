//
//  AlbumItem.h
//  buddhism
//
//  Created by Jiangwei on 14/10/9.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumItem : NSObject

@property (nonatomic, strong) NSNumber *album_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, strong) NSNumber *play_times;
@property (nonatomic, strong) NSNumber *data_order;
@property (nonatomic, strong) NSNumber *track_nums;
@property (nonatomic, copy) NSString *sub_category_title;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSNumber *index;

@property (nonatomic, strong) NSDate  *downed_date;//下载节目时当前时间

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

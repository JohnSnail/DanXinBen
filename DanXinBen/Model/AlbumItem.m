//
//  AlbumItem.m
//  buddhism
//
//  Created by Jiangwei on 14/10/9.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "AlbumItem.h"

@implementation AlbumItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if (![obj isKindOfClass:[NSNull class]]) {
                if ([key isEqualToString:@"id"]) {
                    [self setValue:obj forKey:@"album_id"];
                }else if ([key isEqualToString:@"track_count"]) {
                    [self setValue:obj forKey:@"track_nums"];
                }else if ([key isEqualToString:@"description"]) {
                    [self setValue:obj forKey:@"desc"];
                }else if ([key isEqualToString:@"data_id"]) {
                    [self setValue:obj forKey:@"data_order"];
                }else if ([key isEqualToString:@"album_title"]) {
                    [self setValue:obj forKey:@"title"];
                }else{
                    SEL se = NSSelectorFromString(key);
                    if ([self respondsToSelector:se]) {
                        [self setValue:obj forKey:key];
                    }
                }
            }
        }];
    }
    return self;
}

@end

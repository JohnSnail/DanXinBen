//
//  TrackItem.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/15.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "TrackItem.h"

@implementation TrackItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if (![obj isKindOfClass:[NSNull class]]) {
                if ([key isEqualToString:@"id"]) {
                    [self setValue:obj forKey:@"track_id"];
                }else if ([key isEqualToString:@"track_title"]) {
                    [self setValue:obj forKey:@"title"];
                }else if ([key isEqualToString:@"play_mp3_url"]) {
                    [self setValue:obj forKey:@"play_mp3_url_32"];
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

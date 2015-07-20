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
                SEL se = NSSelectorFromString(key);
                if ([self respondsToSelector:se]) {
                    [self setValue:obj forKey:key];
                }
            }
        }];
    }
    return self;
}

@end

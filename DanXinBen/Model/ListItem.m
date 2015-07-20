//
//  ListItem.m
//  buddhism
//
//  Created by xiaohou on 14/9/24.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

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

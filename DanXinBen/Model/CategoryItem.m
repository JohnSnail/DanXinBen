//
//  CategoryItem.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/25.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "CategoryItem.h"

@implementation CategoryItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if (![obj isKindOfClass:[NSNull class]]) {
                if ([key isEqualToString:@"id"]) {
                    [self setValue:obj forKeyPath:@"categoryId"];
                } else {
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

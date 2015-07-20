//
//  NSObject+PerformBlock.m
//  duotin2.0
//
//  Created by vienta on 14-3-19.
//  Copyright (c) 2014年 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import "NSObject+PerformBlock.h"

@implementation NSObject (PerformBlock)


- (void)performBlock:(void (^)(void))block afterdelay:(NSTimeInterval)time
{
    NSAssert(block != nil, @"block can not be nil");
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:time];
}

- (void)fireBlockAfterDelay:(void (^)(void))blk
{
    if (blk) {
        blk();
    }
}

@end

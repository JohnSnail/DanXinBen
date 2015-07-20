//
//  NSObject+PerformBlock.h
//  duotin2.0
//
//  Created by vienta on 14-3-19.
//  Copyright (c) 2014年 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlock)

- (void)performBlock:(void (^) (void))block afterdelay:(NSTimeInterval)time;

@end

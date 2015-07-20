//
//  ListItem.h
//  buddhism
//
//  Created by xiaohou on 14/9/24.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItem : NSObject

@property (nonatomic, copy) NSString    *itemId;
@property (nonatomic, copy) NSString    *uname;
@property (nonatomic, copy) NSString    *uPic;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *pic;
@property (nonatomic, assign) float     pic_h;
@property (nonatomic, assign) float     pic_w;
@property (nonatomic, copy) NSString    *timeStr;
@property (nonatomic, assign) float     cTime;


- (instancetype)initWithDict:(NSDictionary *)dict;
@end

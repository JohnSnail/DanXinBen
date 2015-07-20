//
//  CategoryItem.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/25.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryItem : NSObject

@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

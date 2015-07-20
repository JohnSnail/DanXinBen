//
//  MoreAppCell.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/16.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "MoreAppCell.h"
#import "MoreAppItem.h"
#import "Header.h"

@implementation MoreAppCell

-(void)setMoreCell:(MoreAppItem *)moreItem
{
    self.moreAppDesc.lineBreakMode = kTextLineBreakByCharWrapping;
    self.moreAppDesc.numberOfLines = 0;
    
    self.moreAppTitle.textColor = UIColorFromRGB(134, 166, 201);
    self.moreAppDesc.textColor = UIColorFromRGB(83, 110, 139);
    
    self.moreAppDesc.text = moreItem.appDesc;
    self.moreAppTitle.text = moreItem.appTitle;
    [self.moreAppImageView setImageWithURL:[NSURL URLWithString:moreItem.appImageUrl] placeholderImage:[UIImage imageNamed:@"MoreInfoRecomendedApp"]];
}

@end

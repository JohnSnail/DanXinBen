//
//  MoreAppCell.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/16.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoreAppItem;

@interface MoreAppCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *moreAppImageView;
@property (strong, nonatomic) IBOutlet UILabel *moreAppTitle;
@property (strong, nonatomic) IBOutlet UILabel *moreAppDesc;

-(void)setMoreCell:(MoreAppItem *)moreItem;
@end

//
//  MainListViewCell.h
//  buddhism
//
//  Created by Jiangwei on 14/10/10.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumItem.h"

@interface MainListViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *albumImageView;
@property (strong, nonatomic) IBOutlet UILabel *sumLabel;
@property (strong, nonatomic) IBOutlet UILabel *hotLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

-(void)setParam:(AlbumItem *)item;

@end

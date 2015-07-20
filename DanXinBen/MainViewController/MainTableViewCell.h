//
//  MainTableViewCell.h
//  buddhism
//
//  Created by Jiangwei on 14/10/9.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumItem;

@interface MainTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *firstImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstListenLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondListenLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdListenLabel;
@property (strong, nonatomic) IBOutlet UIImageView *firstListenIcon;
@property (strong, nonatomic) IBOutlet UIImageView *secondListenIcon;
@property (strong, nonatomic) IBOutlet UIImageView *thirdListenIcon;
@property (strong, nonatomic) IBOutlet UILabel *firstBg;
@property (strong, nonatomic) IBOutlet UILabel *secondBg;
@property (strong, nonatomic) IBOutlet UILabel *thirdBg;

- (void)setParam:(AlbumItem *)item;
-(void)setCellHidden:(BOOL)isShow;

@end

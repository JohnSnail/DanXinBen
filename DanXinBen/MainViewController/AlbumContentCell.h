//
//  AlbumContentCell.h
//  buddhism
//
//  Created by Jiangwei on 14/10/15.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackItem.h"

typedef void(^SelectStatusBlock)(BOOL);

@interface AlbumContentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *playCount;
@property (strong, nonatomic) IBOutlet UILabel *playTime;
@property (strong, nonatomic) IBOutlet UIButton *downBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (copy, nonatomic) SelectStatusBlock statusBlock;
@property (strong, nonatomic) IBOutlet UIImageView *pushImageView;
@property (strong, nonatomic) IBOutlet UILabel *pushLabel;
@property (strong, nonatomic) IBOutlet UILabel *pushInfoLabel;

-(void)setDetailModel:(TrackItem *)item;

-(void)editStatus:(BOOL)editStatus;

- (IBAction)btnTapped:(UIButton *)sender ;

-(void)morePushAppCell;

@end


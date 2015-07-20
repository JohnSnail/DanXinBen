//
//  HistoryCell.h
//  DanXinBen
//
//  Created by Jiangwei on 14/11/3.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackItem.h"

@interface HistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *albumImageView;
@property (strong, nonatomic) IBOutlet UILabel *track_title;
@property (strong, nonatomic) IBOutlet UILabel *album_title;
@property (strong, nonatomic) IBOutlet UILabel *historyLabel;

-(void)setHistoryModel:(TrackItem *)track;

@end

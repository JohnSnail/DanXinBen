//
//  DowningCell.h
//  DanXinBen
//
//  Created by Jiangwei on 14/11/10.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProgressBarView.h"
@class TrackItem;
typedef void(^SelectStatusBlock)(BOOL);

@interface DowningCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *trackTitle;
@property (strong, nonatomic) IBOutlet UILabel *perLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) MCProgressBarView *downProgressView;
@property (copy, nonatomic) SelectStatusBlock statusBlock;

- (void)updateUIWithBytesRead:(long long)totalBytesReadForFile totalRead:(long long)totalBytesExpectedToReadForFile;

-(void)setEditeStatus:(BOOL)editeStatus;
-(void)setDowningCell:(TrackItem *)track;

- (IBAction)selectAction:(UIButton *)sender;

@end

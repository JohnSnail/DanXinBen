//
//  DownCell.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/23.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumItem.h"

typedef void(^SelectStatusBlock)(BOOL);

@interface DownCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *albumImageView;
@property (strong, nonatomic) IBOutlet UILabel *albumTitle;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UIButton *chooseBtn;
@property (copy, nonatomic) SelectStatusBlock statusBlock;

- (IBAction)selecAction:(UIButton *)sender;

-(void)setDowningCell:(NSInteger)count;
-(void)setDetailCell:(AlbumItem *)item;
-(void)setEditStatus:(BOOL)editeStatus;

@end

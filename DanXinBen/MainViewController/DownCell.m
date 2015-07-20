//
//  DownCell.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/23.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "DownCell.h"
#import <UIImageView+AFNetworking.h>
#import "Header.h"

@implementation DownCell

-(void)setDetailCell:(AlbumItem *)item
{
    [self.albumImageView setImageWithURL:[NSURL URLWithString:item.image_url] placeholderImage:[UIImage imageNamed:@"down_album"]];
    self.albumTitle.text = item.title;
    
    if (item.play_times.integerValue > 10000) {
        NSInteger wan = item.play_times.integerValue/10000;
        NSInteger qian = item.play_times.integerValue%10000/1000;
        self.sizeLabel.text = [NSString stringWithFormat:@"热度:%ld.%ld万",(long)wan,(long)qian];
    }else{
        self.sizeLabel.text = [NSString stringWithFormat:@"热度:%@",item.play_times];
    }
    self.numLabel.text = [NSString stringWithFormat:@"下载数量:%@",item.track_nums];
    
    [self setViewColor];

}

- (IBAction)selecAction:(UIButton *)sender {
    self.chooseBtn.selected = !self.chooseBtn.selected;
    if (self.statusBlock) {
        self.statusBlock(self.chooseBtn.selected);
    }
}

-(void)setDowningCell:(NSInteger)count
{
    self.albumImageView.image = [UIImage imageNamed:@"downloading"];
    self.albumTitle.text = @"正在下载";
    self.sizeLabel.text = [NSString stringWithFormat:@"剩余%ld个节目",(long)count];
    self.numLabel.text = @"";
    
    [self setViewColor];
}

-(void)setViewColor
{
    self.albumTitle.textColor = UIColorFromRGB(134, 166, 201);
    self.numLabel.textColor = UIColorFromRGB(83, 110, 139);
    self.sizeLabel.textColor = UIColorFromRGB(83, 110, 139);
}


-(void)setEditStatus:(BOOL)editeStatus
{
    if (editeStatus) {
        [self updateSize:30];
    }else{
        [self updateSize:0];
    }
}

-(void)updateSize:(NSInteger)size
{
    CGRect newRect1 = self.chooseBtn.frame;
    CGRect newRect2 = self.albumImageView.frame;
    CGRect newRect3 = self.sizeLabel.frame;
    CGRect newRect4 = self.numLabel.frame;
    CGRect newRect5 = self.albumTitle.frame;
    
    newRect1.origin.x = -22 + size;
    newRect2.origin.x = 8 + size;
    newRect3.origin.x = 112 + size;
    newRect4.origin.x = 216 + size;
    newRect5.origin.x = 112 + size;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.chooseBtn.frame = newRect1;
        self.albumImageView.frame = newRect2;
        self.sizeLabel.frame = newRect3;
        self.numLabel.frame = newRect4;
        self.albumTitle.frame = newRect5;
    }];
}

@end

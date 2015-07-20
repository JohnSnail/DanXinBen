//
//  AlbumContentCell.m
//  buddhism
//
//  Created by ; on 14/10/15.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "AlbumContentCell.h"
#import "Header.h"

@implementation AlbumContentCell

-(void)editStatus:(BOOL)editStatus
{
    if (editStatus) {
        [self updateOrigin:30];
    }else{
        [self updateOrigin:0];
    }
}

-(void)updateOrigin:(NSInteger)originX
{
    CGRect newRect1 = self.titleLabel.frame;
    CGRect newRect2 = self.playCount.frame;
    CGRect newRect3 = self.playTime.frame;
    CGRect newRect4 = self.selectBtn.frame;

    newRect1.origin.x = 13 + originX;
    newRect2.origin.x = 13 + originX;
    newRect3.origin.x = 146 + originX;
    newRect4.origin.x = -22 + originX;

    [UIView animateWithDuration:0.3 animations:^{
        self.titleLabel.frame = newRect1;
        self.playCount.frame = newRect2;
        self.playTime.frame = newRect3;
        self.selectBtn.frame = newRect4;
    }];
    
}

-(void)moreStatus:(BOOL)status
{
    self.downBtn.hidden = status;
    self.titleLabel.hidden = status;
    self.playCount.hidden = status;
    self.playTime.hidden = status;
    self.selectBtn.hidden = status;
    self.pushImageView.hidden = !status;
    self.pushLabel.hidden = !status;
    self.pushInfoLabel.hidden = !status;
}

-(void)morePushAppCell
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Update_button_off"]];
    [self moreStatus:YES];
    
    self.pushLabel.textColor = UIColorFromRGB(134, 166, 201);
    self.pushLabel.text = @"多听电台-评书、电台、有声书";
    self.pushLabel.textAlignment = kTextAlignmentLeft;
    self.pushLabel.font = [UIFont systemFontOfSize:16];
    
    self.pushInfoLabel.textColor = UIColorFromRGB(83, 110, 139);
    self.pushInfoLabel.text = @"最全有声内容，免费下载，让你听到爽";
    self.pushInfoLabel.textAlignment = kTextAlignmentLeft;
    self.pushInfoLabel.font = [UIFont systemFontOfSize:12];
    
    self.pushImageView.image = [UIImage imageNamed:@"Update_list_LOGO"];
}


-(void)setDetailModel:(TrackItem *)item
{
    [self moreStatus:NO];
    
    [self.downBtn setImage:[UIImage imageNamed:@"down_icon"] forState:UIControlStateNormal];
    self.titleLabel.text = item.title;

    if (item.file_size) {
        CGFloat file_size = [item.file_size integerValue] /1024.0/1024.0;
        self.playCount.text = [NSString stringWithFormat:@"大小:%.2fM",file_size];//@"大小:3.5M";
    }else{
        if (item.play_count.integerValue >= 10000) {
            NSInteger wan = item.play_count.integerValue/10000;
            NSInteger qian = item.play_count.integerValue%10000/1000;
            self.playCount.text = [NSString stringWithFormat:@"播放次数：%ld.%ld万",(long)wan,(long)qian];
        }else{
            self.playCount.text = [NSString stringWithFormat:@"播放次数：%@",item.play_count];
        }
    }
    self.playTime.text = [NSString stringWithFormat:@"收听时长：%@",item.duration];
    
    [self setViewColor];
}

-(void)setViewColor
{
    self.titleLabel.textColor = UIColorFromRGB(134, 166, 201);
    self.playCount.textColor = UIColorFromRGB(83, 110, 139);
    self.playTime.textColor = UIColorFromRGB(83, 110, 139);
}

- (IBAction)btnTapped:(UIButton *)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.statusBlock) {
        self.statusBlock(self.selectBtn.selected);
    }
}

@end

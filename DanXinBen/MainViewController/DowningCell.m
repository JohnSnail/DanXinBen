//
//  DowningCell.m
//  DanXinBen
//
//  Created by Jiangwei on 14/11/10.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "DowningCell.h"
#import "TrackItem.h"

@implementation DowningCell

-(void)setDowningCell:(TrackItem *)track
{
    self.trackTitle.text = track.title;
    self.perLabel.text = @"等待下载";
    self.progressLabel.text = @"";
    self.downProgressView.hidden = YES;
    self.downProgressView.progress = 0;
}

- (IBAction)selectAction:(UIButton *)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.statusBlock) {
        self.statusBlock(self.selectBtn.selected);
    }
}

- (void)updateUIWithBytesRead:(long long)totalBytesReadForFile totalRead:(long long)totalBytesExpectedToReadForFile
{
    float progress = totalBytesReadForFile / (float)totalBytesExpectedToReadForFile;
    float bytesMB = (float)totalBytesReadForFile/1024/1024;
    float totoalMB = (float)totalBytesExpectedToReadForFile/1024/1024;
    self.downProgressView.hidden = NO;
    self.downProgressView.progress = progress;
    self.perLabel.text = [NSString stringWithFormat:@"%.2fM/%.2fM",bytesMB, totoalMB];
    self.progressLabel.text=[NSString stringWithFormat:@"%.0f%@",progress*100,@"%"];
}

-(void)updateOrigin:(NSInteger)originX
{
    CGRect newDowningRect1 = self.trackTitle.frame;
    CGRect newDowningRect2 = self.downProgressView.frame;
    CGRect newDowningRect3 = self.perLabel.frame;
    CGRect newDowningRect4 = self.progressLabel.frame;
    CGRect newDowningRect5 = self.selectBtn.frame;
    
    newDowningRect1.origin.x = 8 + originX;
    newDowningRect2.origin.x = 10 + originX;
    newDowningRect3.origin.x = 8 + originX;
    newDowningRect4.origin.x = 255 + originX;
    newDowningRect5.origin.x = -22 + originX;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.trackTitle.frame = newDowningRect1;
        self.downProgressView.frame = newDowningRect2;
        self.perLabel.frame = newDowningRect3;
        self.progressLabel.frame = newDowningRect4;
        self.selectBtn.frame = newDowningRect5;
    }];
}

-(void)setEditeStatus:(BOOL)editeStatus
{
    if (editeStatus) {
        [self updateOrigin:30];
    }else{
        [self updateOrigin:0];
    }
}

@end

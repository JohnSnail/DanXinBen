//
//  HistoryCell.m
//  DanXinBen
//
//  Created by Jiangwei on 14/11/3.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "HistoryCell.h"
#import <UIImageView+AFNetworking.h>
#import <util.h>
#import "Header.h"

@implementation HistoryCell

-(void)setHistoryModel:(TrackItem *)track
{
    [self.albumImageView setImageWithURL:[NSURL URLWithString:track.album.image_url] placeholderImage:[UIImage imageNamed:@"albumDefault"]];
    self.track_title.text = track.title;
    self.album_title.text = track.album.title;
    self.historyLabel.text = [NSString stringWithFormat:@"已收听%@秒",[Util formatIntoDateWithSecond:track.hisProgress]];
    
    [self setViewColor];
}

-(void)setViewColor
{
    self.track_title.textColor = UIColorFromRGB(134, 166, 201);
    self.album_title.textColor = UIColorFromRGB(83, 110, 139);
    self.historyLabel.textColor = UIColorFromRGB(83, 110, 139);
}
@end

//
//  MainTableViewCell.m
//  buddhism
//
//  Created by Jiangwei on 14/10/9.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "MainTableViewCell.h"
#import "AlbumItem.h"
#import "UIImageView+AFNetworking.h"

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:nil options:nil];
    self = nib[0];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setParam:(AlbumItem *)item
{
    if (item.index.integerValue%3 == 0) {
        [self.firstImageView setImageWithURL:[NSURL URLWithString:item.image_url] placeholderImage:[UIImage imageNamed:@"recoAlbum"]];
        self.firstLabel.text = item.title;
        if (item.play_times.integerValue > 10000) {
            NSInteger wan = item.play_times.integerValue/10000;
            NSInteger qian = item.play_times.integerValue%10000/1000;
            self.firstListenLabel.text = [NSString stringWithFormat:@"%ld.%ld万",(long)wan,(long)qian];
        }else{
            self.firstListenLabel.text = [NSString stringWithFormat:@"%@",item.play_times];
        }
        
    }else if(item.index.integerValue%3 == 1){
        [self.secondImageView setImageWithURL:[NSURL URLWithString:item.image_url] placeholderImage:[UIImage imageNamed:@"recoAlbum"]];
        self.secondLabel.text = item.title;
        if (item.play_times.integerValue > 10000) {
            NSInteger wan = item.play_times.integerValue/10000;
            NSInteger qian = item.play_times.integerValue%10000/1000;
            self.secondListenLabel.text = [NSString stringWithFormat:@"%ld.%ld万",(long)wan,(long)qian];
        }else{
            self.secondListenLabel.text = [NSString stringWithFormat:@"%@",item.play_times];
        }
        
    }else if(item.index.integerValue%3 == 2){
        [self.thirdImageView setImageWithURL:[NSURL URLWithString:item.image_url] placeholderImage:[UIImage imageNamed:@"recoAlbum"]];
        self.thirdLabel.text = item.title;
        if (item.play_times.integerValue > 10000) {
            NSInteger wan = item.play_times.integerValue/10000;
            NSInteger qian = item.play_times.integerValue%10000/1000;
            self.thirdListenLabel.text = [NSString stringWithFormat:@"%ld.%ld万",(long)wan,(long)qian];
        }else{
            self.thirdListenLabel.text = [NSString stringWithFormat:@"%@",item.play_times];
        }
    }
}


-(void)setCellHidden:(BOOL)isShow
{
    self.firstImageView.hidden = isShow;
    self.secondImageView.hidden = isShow;
    self.thirdImageView.hidden = isShow;
    self.firstLabel.hidden = isShow;
    self.secondLabel.hidden = isShow;
    self.thirdLabel.hidden = isShow;
    self.firstListenLabel.hidden = isShow;
    self.secondListenLabel.hidden = isShow;
    self.thirdListenLabel.hidden = isShow;
    self.firstListenIcon.hidden = isShow;
    self.secondListenIcon.hidden = isShow;
    self.thirdListenIcon.hidden = isShow;
    self.firstBg.hidden = isShow;
    self.secondBg.hidden = isShow;
    self.thirdBg.hidden = isShow;
}

@end

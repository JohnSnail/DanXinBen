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
#import "Header.h"

@implementation MainTableViewCell

-(void)addImageViewTap
{
    self.backgroundColor = CustomBgColor;

    UITapGestureRecognizer *tapRecognizer1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PassToDelegate:)];
    self.firstImageView.tag = 101;
    self.firstImageView.userInteractionEnabled=YES;
    [self.firstImageView addGestureRecognizer:tapRecognizer1];
    
    UITapGestureRecognizer *tapRecognizer2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PassToDelegate:)];
    self.secondImageView.tag = 102;
    self.secondImageView.userInteractionEnabled=YES;
    [self.secondImageView addGestureRecognizer:tapRecognizer2];
    
    UITapGestureRecognizer *tapRecognizer3=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PassToDelegate:)];
    self.thirdImageView.tag = 103;
    self.thirdImageView.userInteractionEnabled=YES;
    [self.thirdImageView addGestureRecognizer:tapRecognizer3];
}

-(void)PassToDelegate:(UITapGestureRecognizer*) singleTap
{
    if (_callBack) {
        _callBack(singleTap.view.tag);
    }
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

@end

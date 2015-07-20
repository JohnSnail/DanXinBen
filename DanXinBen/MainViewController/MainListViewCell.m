//
//  MainListViewCell.m
//  buddhism
//
//  Created by Jiangwei on 14/10/10.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "MainListViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MainListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainListViewCell" owner:nil options:nil];
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


-(void)setParam:(AlbumItem *)item{
    
    self.titleLabel.text = item.title;
    [self.albumImageView setImageWithURL:[NSURL URLWithString:item.image_url] placeholderImage:nil];
    if (item.play_times.integerValue > 10000) {
        NSInteger wan = item.play_times.integerValue/10000;
        NSInteger qian = item.play_times.integerValue%10000/1000;
        self.hotLabel.text = [NSString stringWithFormat:@"热度：%ld.%ld万",(long)wan,(long)qian];
    }else{
        self.hotLabel.text = [NSString stringWithFormat:@"热度：%@",item.play_times];
    }
    self.sumLabel.text = [NSString stringWithFormat:@"节目数：%@",item.track_nums];
    
}
@end

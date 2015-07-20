//
//  MRStackViewCell.m
//  MRStackView
//
//  Created by sheldon on 14-8-11.
//  Copyright (c) 2014年 wheelab. All rights reserved.
//

#import "MRStackViewCell.h"

@implementation MRStackViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(-1, 0.5);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.contentView];
}

@end

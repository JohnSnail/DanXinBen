//
//  UMFeedbackTableViewCellRight.m
//  UMeng Analysis
//
//  Created by liuyu on 9/18/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "UMFeedbackTableViewCellRight.h"
#import "Header.h"

#define TOP_MARGIN 40.0f

@implementation UMFeedbackTableViewCellRight

@synthesize timestampLabel = _timestampLabel;
@synthesize timeImagView=_timeImagView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            self.textLabel.backgroundColor = [UIColor clearColor];
        }

        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = kTextAlignmentLeft;
        self.textLabel.textColor = [UIColor blackColor];

        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _timestampLabel.textAlignment = kTextAlignmentCenter;
        _timestampLabel.font = [UIFont systemFontOfSize:14];
        _timestampLabel.backgroundColor=[UIColor clearColor];
//        _timestampLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        _timestampLabel.textColor=[UIColor whiteColor];
//        _timestampLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"timeBackGround"]];
//        _timestampLabel.frame = CGRectMake(0.0f, 12, self.bounds.size.width, 18);


        _timeImagView=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"timeBackGround"] stretchableImageWithLeftCapWidth:10 topCapHeight:20]];
            //        _timeImagView.frame=_timestampLabel.frame;
        _timeImagView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_timeImagView];
        
        [self.contentView addSubview:_timestampLabel];


        CGRect textLabelFrame = self.textLabel.frame;
        textLabelFrame.origin.y = 20;
        textLabelFrame.size.width = self.bounds.size.width - 50;
        self.textLabel.frame = textLabelFrame;

        messageBackgroundView = [[UIImageView alloc] initWithFrame:self.textLabel.frame];
        messageBackgroundView.image = [[UIImage imageNamed:@"messages_right_bubble.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:32];
        [self.contentView insertSubview:messageBackgroundView belowSubview:self.textLabel];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.width = 226;
    self.textLabel.frame = textLabelFrame;

    CGSize labelSize = [self.textLabel.text sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                       constrainedToSize:CGSizeMake(226, MAXFLOAT)
                                           lineBreakMode:kTextLineBreakByWordWrapping];

    textLabelFrame.size.height = labelSize.height + 6;
    textLabelFrame.origin.y = 20.0f + TOP_MARGIN;
    textLabelFrame.origin.x = self.bounds.size.width - labelSize.width - 20-5;
    self.textLabel.frame = textLabelFrame;

    messageBackgroundView.frame = CGRectMake(textLabelFrame.origin.x - 8, textLabelFrame.origin.y - 2, labelSize.width + 16+5, labelSize.height + 18);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor);
//
//    CGContextSetLineWidth(context, 1.0);
//    CGContextMoveToPoint(context, 0, 21); //start at this point
//    CGContextAddLineToPoint(context, (self.bounds.size.width - 120) / 2, 21); //draw to this point
//
//    CGContextMoveToPoint(context, self.bounds.size.width, 21); //start at this point
//    CGContextAddLineToPoint(context, self.bounds.size.width - (self.bounds.size.width - 120) / 2, 21); //draw to this point
//
//    CGContextStrokePath(context);

}

@end

//
//  PlayViewController.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/24.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackItem.h"

@interface PlayViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) TrackItem *playTrack;

+ (PlayViewController *)sharedManager;
-(void)requestPlayData:(TrackItem *)track;
-(void)getDownedPlayData:(NSMutableArray *)playArray andIndex:(NSInteger)index andAlbum:(AlbumItem *)album;
- (IBAction)lastAction:(id)sender;
- (IBAction)playPauseAction:(id)sender;
- (IBAction)nextAction:(id)sender;

@end

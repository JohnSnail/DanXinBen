//
//  DTTimingViewController.m
//  duotin2.0
//
//  Created by Vienta on 14-10-17.
//  Copyright (c) 2014年 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import "DTTimingViewController.h"
#import "DTTimingManager.h"
#import "UIAlertView+Blocks.h"

@interface DTTimingViewController ()

@end

@implementation DTTimingViewController
{
    NSMutableArray *_timingData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self layoutUI];
    _timingData = [NSMutableArray arrayWithCapacity:0];
    [_timingData addObject:@{@"content": @"不开启",
                             @"state":@(TimingStateNone)}];
    [_timingData addObject:@{@"content": @"10分钟后",
                             @"state":@(TimingStateTenMins)}];
    [_timingData addObject:@{@"content": @"20分钟后",
                             @"state":@(TimingStateTwentyMins)}];
    [_timingData addObject:@{@"content": @"30分钟后",
                             @"state":@(TimingStateThirtyMins)}];
    [_timingData addObject:@{@"content": @"60分钟后",
                             @"state":@(TimingStateOneHour)}];
    [_timingData addObject:@{@"content": @"90分钟后",
                             @"state":@(TimingStateNinetyMins)}];
    [_timingData addObject:@{@"content": @"当前单曲播放完毕后",
                             @"state":@(TimingStateAfterCurrentFinish)}];
    
    [self.tbvTiming performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)layoutUI
{
    self.dtTitle = @"播放定时关闭";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = CGRectMake(0, 0, 12, 20);
    [backBtn setImage:[UIImage imageNamed:@"back_general"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setEnlargeEdge:28];
    self.dtLeftCustomView = backBtn;
}

- (void)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_timingData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"timingCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UIImageView * lineImg = [CommentMethods cuttingLineWithOriginx:10 andOriginY:43.5];
    [cell.contentView addSubview:lineImg];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    int idx = indexPath.row;
    NSDictionary *dict = [_timingData objectAtIndex:idx];
    cell.textLabel.text = [dict objectForKey:@"content"];
    if ([[dict objectForKey:@"state"] integerValue] == [DTTimingManager sharedDTTimingManager].timingState){
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectCell"]];
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int selectIdx = indexPath.row;
    NSDictionary *selectDict = [_timingData objectAtIndex:selectIdx];
    NSNumber *timingState = [selectDict objectForKey:@"state"];
    if ([timingState integerValue] == TimingStateAfterCurrentFinish) {
        if([[PlayController sharedManager].trackModel.track_id integerValue] != 0) {
            [[DTTimingManager sharedDTTimingManager] startTiming:TimingStateAfterCurrentFinish];
        } else {
            [UIAlertView showWithTitle:@"温馨提示" message:@"当前没有播放节目" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }
        
    } else {
        [[DTTimingManager sharedDTTimingManager] startTiming:[timingState integerValue]];
    }


    [self.tbvTiming performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

@end

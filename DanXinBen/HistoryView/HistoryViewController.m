//
//  HistoryViewController.m
//  buddhism
//
//  Created by Jiangwei on 14/10/8.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "HistoryViewController.h"
#import "Header.h"
#import "HistoryList.h"
#import "HistoryCell.h"
#import "PlayViewController.h"
#import <DTPodsHeader.h>

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *historyTbView;
@property (strong, nonatomic) NSMutableArray *historyMuArray;
@property (strong, nonatomic) IBOutlet UIButton *clearBtn;
@property (strong, nonatomic) IBOutlet UIImageView *emptyImageView;


@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.view.backgroundColor = CustomBgColor;
    self.historyTbView.backgroundColor = [UIColor clearColor];
    self.historyTbView.separatorStyle = NO;
    self.navigationItem.backBarButtonItem = [CommentMethods commendBackItem
                                             ];
    [self.editBtn setTitleColor:NavTitleColor forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.clearBtn addTarget:self action:@selector(deleHistoryAction) forControlEvents:UIControlEventTouchUpInside];
    self.clearBtn.backgroundColor = CustomBgColor;
    
    self.emptyImageView.image = [UIImage imageNamed:@"watermark_bg_his"];
    
    self.historyMuArray = [NSMutableArray arrayWithCapacity:0];
}

-(void)editBtnAction
{
    self.editBtn.selected = !self.editBtn.selected;
    if (self.editBtn.selected) {
        [self.tabBarController.tabBar addSubview:self.clearBtn];
        [self.historyTbView setEditing:YES animated:YES];
    }else{
        if ([self.clearBtn superview]) {
            [self.clearBtn removeFromSuperview];
        }
        [self.historyTbView setEditing:NO animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.historyMuArray removeAllObjects];
    [self getHistoryData];
}

-(void)getHistoryData
{
    NSArray *hisArray = [[HistoryList sharedManager] getHistoryListData];
    
    for (int i=0; i<hisArray.count; i++)
    {
        TrackItem *hisModel = [hisArray objectAtIndex:i];
        BOOL exist=NO;//专辑还不存在，加入列表
        for (int J=0; J<self.historyMuArray.count; J++) {
            TrackItem *newHisTrackModel = [self.historyMuArray objectAtIndex:J];
            if (hisModel.album.album_id == newHisTrackModel.album.album_id)
            {
                exist = YES;
            }
        }
        if (!exist)
        {
            [self.historyMuArray addObject:hisModel];
        }
    }
    [self.historyTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    if (self.historyMuArray.count == 0) {
        self.editBtn.hidden = YES;
        self.emptyImageView.hidden = NO;
    }else{
        self.editBtn.hidden = NO;
        self.emptyImageView.hidden = YES;
    }
}

#pragma mark - 
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyMuArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell1Identifier = @"HistoryCell";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1Identifier];
    if (!cell) {
        cell = (HistoryCell *)CREAT_XIB(@"HistoryCell");
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TrackItem *item = [self.historyMuArray objectAtIndex:indexPath.row];
    [cell setHistoryModel:item];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayViewController *playVC = [PlayViewController sharedManager];
    
    TrackItem *track = [self.historyMuArray objectAtIndex:indexPath.row];
    [playVC requestPlayData:track];
    
    playVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playVC animated:YES];
}

#pragma mark -
#pragma mark - 删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TrackItem *track = [self.historyMuArray objectAtIndex:indexPath.row];
        [[HistoryList sharedManager] deleteContent:track];
        
        [self.historyMuArray removeObjectAtIndex:indexPath.row];
        [self.historyTbView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)deleHistoryAction
{
    [self.historyMuArray removeAllObjects];
    [[HistoryList sharedManager] deleteAllContent];
    [self.historyTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    [self editBtnAction];
    [self getHistoryData];
}



@end

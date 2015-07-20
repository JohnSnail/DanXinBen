//
//  DownedViewController.m
//  DanXinBen
//
//  Created by Jiangwei on 14/11/4.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "DownedViewController.h"
#import "AlbumContentCell.h"
#import "Header.h"
#import "DownList.h"
#import "PlayViewController.h"
#import "UIAlertView+Blocks.h"

@interface DownedViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL editeStatus;
    NSMutableArray *deleMuArray;
}

@property (strong, nonatomic) IBOutlet UITableView *downedTbView;
@property (strong, nonatomic) NSMutableArray *downedMuArray;
@property (strong, nonatomic) AlbumItem *album;
@property (strong, nonatomic) IBOutlet UIView *chooseView;
@property (strong, nonatomic) IBOutlet UIButton *chooseBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleBtn;

@end

@implementation DownedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.downedTbView.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = CustomBgColor;
    self.downedTbView.separatorStyle = NO;
    self.navigationItem.backBarButtonItem = [CommentMethods commendBackItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editeAction)];
    deleMuArray = [NSMutableArray arrayWithCapacity:0];
    
    self.chooseView.hidden = YES;
}

-(void)editeAction
{
    editeStatus = !editeStatus;
    [self updateTbViewFrame];
}

-(void)updateTbViewFrame
{    
    if (editeStatus) {
        self.chooseView.hidden = NO;
        self.downedTbView.frame = CGRectMake(0, 0, mainScreenWidth, self.view.bounds.size.height - self.chooseView.frame.size.height);
    }else{
        self.chooseView.hidden = YES;
        self.downedTbView.frame = CGRectMake(0, 0, mainScreenWidth, self.view.bounds.size.height);
    }
    [self.downedTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

-(void)getDownedData:(AlbumItem *)album
{
    self.navigationItem.titleView = [CommentMethods navigationTitleView:album.title];
    self.album = album;
    self.downedMuArray = [NSMutableArray arrayWithArray:[[DownList sharedManager] getDownedData:album.album_id]];
    
    [self.downedTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downedMuArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DownCellIndentifier = @"AlbumContentCell";
    
    AlbumContentCell *cell = [tableView dequeueReusableCellWithIdentifier:DownCellIndentifier];
    if (!cell) {
        cell = (AlbumContentCell *)CREAT_XIB(@"AlbumContentCell");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.downBtn.hidden = YES;
    }
    TrackItem *track = [self.downedMuArray objectAtIndex:indexPath.row];
    [cell setDetailModel:track];
    [cell editStatus:editeStatus];
    
    cell.statusBlock = ^(BOOL isSelect) {
        if (isSelect) {
            //选中了 添加到删除数组里面
            NSArray *hasAlbArr = [deleMuArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"track_id==%@",track.track_id]];
            if (hasAlbArr && [hasAlbArr count]) {
                //说明数组中有了
            } else {
                //说明没有 添加
                [deleMuArray addObject:track];
            }
            
            if (deleMuArray && [deleMuArray count] && [self.downedMuArray count]) {
                if ([deleMuArray count] == [self.downedMuArray count]) {
                    //说明是全选了
                    self.chooseBtn.selected = YES;
                } else {
                    self.chooseBtn.selected = NO;
                }
            }
        } else {
            //取消了  从删除数据里面删除
            NSArray *hasDelAlbArr = [deleMuArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"track_id==%@",track.track_id]];
            if (hasDelAlbArr && [hasDelAlbArr count]) {
                //如果在删除数组里面 删除
                [deleMuArray removeObject:track];
                self.chooseBtn.selected = NO;
            }
        }
        [self deleteNumAction];
    };
    
    NSArray *contantAlbArr = [deleMuArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"track_id==%@",track.track_id]];
    if (contantAlbArr && [contantAlbArr count]) {
        //选中状态
        cell.selectBtn.selected = YES;
    } else {
        cell.selectBtn.selected = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editeStatus) {
        AlbumContentCell *cell = (AlbumContentCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell btnTapped:cell.selectBtn];
        [self.downedTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }else{
        PlayViewController *playVC = [PlayViewController sharedManager];
        
        [playVC getDownedPlayData:self.downedMuArray andIndex:indexPath.row andAlbum:self.album];
        
        playVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playVC animated:YES];
    }
}

-(void)deleteNumAction
{
    if (deleMuArray.count != 0) {
        NSString *title = [NSString stringWithFormat:@"删除(%lu)",(unsigned long)deleMuArray.count];
        [self.deleBtn setTitle:title forState:UIControlStateNormal];
    }else{
        [self.deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark - 删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TrackItem *track = [self.downedMuArray objectAtIndex:indexPath.row];
        [[DownList sharedManager] deleteContent:track];
        
        [self.downedMuArray removeObjectAtIndex:indexPath.row];
        [self.downedTbView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self afterDeleEmptyView];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (IBAction)chooseAction:(UIButton *)sender {
    
    self.chooseBtn.selected = !self.chooseBtn.selected;
    
    if (self.chooseBtn.selected) {
        deleMuArray = [NSMutableArray arrayWithArray:self.downedMuArray];
    }else{
        [deleMuArray removeAllObjects];
    }
    
    [self deleteNumAction];
    [self.downedTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (IBAction)deleteAction:(UIButton *)sender {
    if (deleMuArray.count == 0) {
        [UIAlertView showWithTitle:@"温馨提示" message:@"请选择需要删除的节目" cancelButtonTitle:@"取消" otherButtonTitles:nil tapBlock:nil];
        return;
    }
    [SVProgressHUD show];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(deleteTrack) userInfo:nil repeats:NO];
}

-(void)deleteTrack
{
    for (int i=0 ; i < deleMuArray.count; i++) {
        TrackItem *track = [deleMuArray objectAtIndex:i];
        [[DownList sharedManager] deleteContent:track];
        
        NSString *trackPath = [NSString stringWithFormat:@"%@.mp3",track.track_id];
        NSString *paths = [CommentMethods getTargetFloderPath];
        NSString *documentFileName = [paths stringByAppendingPathComponent:trackPath];
        [CommentMethods clearDocu:documentFileName];
        
        [self.downedMuArray removeObject:track];
    }
    [self.downedTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [SVProgressHUD dismiss];
    [deleMuArray removeAllObjects];
    
    [self deleteNumAction];
    [self editeAction];
    
    [self afterDeleEmptyView];
}


-(void)afterDeleEmptyView
{
    if (self.downedMuArray.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

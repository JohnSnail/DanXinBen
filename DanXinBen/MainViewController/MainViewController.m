//
//  MainViewController.m
//  buddhism
//
//  Created by Jiangwei on 14/10/8.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "AlbumItem.h"
#import "MainListViewController.h"
#import "NetService.h"
#import "Header.h"
#import "AlbumContentViewController.h"
#import "DownCell.h"
#import "DownList.h"
#import "DowningViewController.h"
#import "DownedViewController.h"
#import "DownloadService.h"
#import "UIAlertView+Blocks.h"
#import <AppMacro.h>

//添加bannar广告
#import <DMAdView.h>

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,DMAdViewDelegate>
{
    UIButton *editeBtn;
    NSMutableArray *deleMuArray;
    BOOL _isAutoResumeDownload;
    DMAdView *_dmAdView;
}

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray       *mainItems;
@property (nonatomic, strong) NSMutableArray       *downingMuArray;
@property (nonatomic, strong) NSMutableArray       *downedMuArray;
@property (strong, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (strong, nonatomic) IBOutlet UIButton *chooseAllBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIView *editView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = CustomBgColor;
    self.editView.backgroundColor = CustomBgColor;
    
    self.mainTableView.separatorStyle = NO;
    self.mainItems = [NSMutableArray arrayWithCapacity:0];
    deleMuArray = [NSMutableArray arrayWithCapacity:0];
    
    self.navigationItem.backBarButtonItem = [CommentMethods commendBackItem];
    
    self.emptyImageView.hidden = YES;
    self.emptyImageView.image = [UIImage imageNamed:@"watermark_bg_ico2"];
    
    
    [self addObserver];
    
    [self addEditView];
    
    [self addDMAdViewBannar];
}


-(void)addDMAdViewBannar
{
    _dmAdView = [[DMAdView alloc] initWithPublisherId:@"56OJ20kYuN27+Dea1h" placementId:@"16TLPJzaApq52NUvX-bOsQ3s" autorefresh:YES];
    _dmAdView.frame = CGRectMake(0, 0,
                                 DOMOB_AD_SIZE_320x50.width,
                                 DOMOB_AD_SIZE_320x50.height);
    
    _dmAdView.delegate = self;
    _dmAdView.rootViewController = self;
    [self.view addSubview:_dmAdView];
    [_dmAdView loadAd];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_dmAdView removeFromSuperview]; // 将广告试图从父视图中移除
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.mainItems.count == 0) {
        [self getNetSeviceData];
    }
    
    [self reloadMainView];
    
    if (editeBtn.selected) {
        [self buttonPressedAction];
    }
}

-(void)reloadMainView
{
    self.downingMuArray = [NSMutableArray arrayWithArray:[[DownList sharedManager] getDowningData]];
    
    self.downedMuArray = [NSMutableArray arrayWithArray:[[DownList sharedManager] getAlbumData]];
    
    [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    if (self.downedMuArray.count == 0 && self.downingMuArray.count == 0) {
        self.emptyImageView.hidden = NO;
        editeBtn.hidden = YES;
        self.mainTableView.scrollEnabled = NO;
    }else{
        self.emptyImageView.hidden = YES;
        editeBtn.hidden = NO;
        self.mainTableView.scrollEnabled = YES;
    }
}

-(void)getNetSeviceData
{
    [[NetManager sharedNetManager] getMainData:@(0) andSub_category_id:@(subCategoryId) Success:^(NSDictionary* sucRes) {
        [self.mainItems removeAllObjects];
        NSArray *albumList = sucRes[@"album_list"];
        for(NSDictionary *dic in albumList)
        {
            AlbumItem *albumItem = [[AlbumItem alloc]initWithDict:dic];
            [self.mainItems addObject:albumItem];
        }
        [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    } failure:^(NSDictionary* failRes) {
        ;
    }];
}

#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger countNum;
    if (self.downingMuArray.count ==0) {
        countNum = 3 + self.downedMuArray.count;
    }else{
        countNum = 3 + 1 + self.downedMuArray.count;
    }
    return countNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 60;
    }else if(indexPath.row == 1){
        return 110;
    }else if(indexPath.row == 2){
        return 60;
    }else{
        return 93;
    }
}

-(void)pushAlbumContentVC:(NSInteger)tag
{
    AlbumItem *item = nil;
    
    AlbumContentViewController *albumVC = [[AlbumContentViewController alloc]init];
    albumVC.hidesBottomBarWhenPushed = YES;
    if (self.mainItems.count != 0) {
        if (tag == 101) {
            item = self.mainItems[0];
        }else if(tag == 102){
            item = self.mainItems[1];
        }else if(tag == 103){
            item = self.mainItems[2];
        }
    }
    albumVC.albumId = item.album_id;
    albumVC.playtimes = item.play_times;
    [self.navigationController pushViewController:albumVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 22, 4, 16)];
            iconImageView.image = [UIImage imageNamed:@"main_icon"];
            [cell.contentView addSubview:iconImageView];
            
            if (indexPath.row == 2) {
                if (editeBtn == nil) {
                    UIImage *image= [ UIImage imageNamed:@"home_icon_edit"];
                    editeBtn = [ UIButton buttonWithType:UIButtonTypeCustom];
                    CGRect frame = CGRectMake( 0, 0, 40, 40);
                    editeBtn. frame = frame;
                    [editeBtn setImage:image forState:UIControlStateNormal];
                    [editeBtn setImage:[UIImage imageNamed:@"home_icon_finish"] forState:UIControlStateSelected];
                    editeBtn. backgroundColor = [UIColor clearColor ];
                    [editeBtn addTarget:self action:@selector(buttonPressedAction) forControlEvents:UIControlEventTouchUpInside];
                    cell.accessoryView = editeBtn;
                }
            }
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"精品推荐";
            cell.textLabel.textColor = NavTitleColor;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"我的节目";
            cell.textLabel.textColor = NavTitleColor;
        }
        return cell;
        
    }else if (indexPath.row == 1){
        
        static NSString *MainCellIdentifier = @"MainViewCell";
        
        MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellIdentifier];
        if (!cell) {
            cell = (MainTableViewCell *)CREAT_XIB(@"MainTableViewCell");
            [cell addImageViewTap];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        [cell setCallBack:^(NSInteger index){
            [self pushAlbumContentVC:index];
        }];
        if (0 < self.mainItems.count) {
            AlbumItem *item = self.mainItems[0];
            item.index = @(0);
            [cell setParam:item];
        }
        if (1 < self.mainItems.count) {
            AlbumItem *item = self.mainItems[1];
            item.index = @(1);
            [cell setParam:item];
        }
        if (2 < self.mainItems.count) {
            AlbumItem *item = self.mainItems[2];
            item.index = @(2);
            [cell setParam:item];
        }
        return cell;
    }else{
        static NSString *DownCellIndentifier = @"DownCell";
        
        DownCell *cell = [tableView dequeueReusableCellWithIdentifier:DownCellIndentifier];
        if (!cell) {
            cell = (DownCell *)CREAT_XIB(@"DownCell");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        if (self.downingMuArray.count == 0) {
            AlbumItem *album = [self.downedMuArray objectAtIndex:indexPath.row - 3];
            [cell setDetailCell:album];
            
            [self markDownCell:cell andAlbum:album];
        }else{
            if (indexPath.row == 3) {
                [cell setDowningCell:self.downingMuArray.count];
            }else{
                AlbumItem *album = [self.downedMuArray objectAtIndex:indexPath.row - 4];
                [cell setDetailCell:album];
            }
        }
        [cell setEditStatus:editeBtn.selected];
        
        return cell;
    }
    return nil;
}

-(void)markDownCell:(DownCell *)downAlbumCell andAlbum:(AlbumItem *)album
{
    downAlbumCell.statusBlock = ^(BOOL isSelect) {
        if (isSelect) {
            //选中了 添加到删除数组里面
            NSArray *hasAlbArr = [deleMuArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"album_id==%@",album.album_id]];
            if (hasAlbArr && [hasAlbArr count]) {
                //说明数组中有了
            } else {
                //说明没有 添加
                [deleMuArray addObject:album];
            }
            
            if (deleMuArray && [deleMuArray count] && [self.downedMuArray count]) {
                if ([deleMuArray count] == [self.downedMuArray count]) {
                    //说明是全选了
                    self.chooseAllBtn.selected = YES;
                } else {
                    self.chooseAllBtn.selected = NO;
                }
            }
            
        } else {
            //取消了  从删除数据里面删除
            NSArray *hasDelAlbArr = [deleMuArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"album_id==%@",album.album_id]];
            if (hasDelAlbArr && [hasDelAlbArr count]) {
                //如果在删除数组里面 删除
                AlbumItem *delAlb = [hasDelAlbArr firstObject];
                [deleMuArray removeObject:delAlb];
                self.chooseAllBtn.selected = NO;
            }
        }
        [self deleteNumAction];
    };
    
    NSArray *contantAlbArr = [deleMuArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"album_id==%@",album.album_id]];
    if (contantAlbArr && [contantAlbArr count]) {
        //选中状态
        downAlbumCell.chooseBtn.selected = YES;
    } else {
        downAlbumCell.chooseBtn.selected = NO;
    }
}

-(void)deleteNumAction
{
    if (deleMuArray.count != 0) {
        NSString *title = [NSString stringWithFormat:@"删除(%lu)",(unsigned long)deleMuArray.count];
        [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    }else{
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
}

-(void)buttonPressedAction
{
    editeBtn.selected = !editeBtn.selected;
    if (editeBtn.selected) {
        self.tabBarController.tabBar.hidden = YES;
        self.editView.hidden = NO;
        [self.downingMuArray removeAllObjects];
        
        if ([DownloadService sharedDownloadService].downState == DownloadStateNormal) {
            _isAutoResumeDownload = YES;
            [[DownloadService sharedDownloadService] pauseAll];
        }
    }else{
        self.tabBarController.tabBar.hidden = NO;
        self.editView.hidden = YES;
        [self reloadMainView];
        
        if (_isAutoResumeDownload) {
            if ([DownloadService sharedDownloadService].downState == DownloadStatePause) {
                [[DownloadService sharedDownloadService] resumeAllForce:YES];
            }
            _isAutoResumeDownload = NO;
        }
    }
    
    [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

-(void)addEditView
{
    self.editView.hidden = YES;
    [self.tabBarController.view addSubview:self.editView];
    self.editView.center = ccp(self.editView.center.x, CGRectGetHeight(self.tabBarController.view.bounds) - CGRectGetMidY(self.editView.bounds));
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        [self pushMainListViewController];
    }else if(indexPath.row >=3){
        if (editeBtn.selected) {
            DownCell *albCell = (DownCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            [albCell selecAction:albCell.chooseBtn];
            [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
        }else{
            if (self.downingMuArray.count != 0) {
                if (indexPath.row == 3) {
                    [self pushDowningViewController];
                }else{
                    [self pushDownedViewController:indexPath.row - 4];
                }
            }else{
                [self pushDownedViewController:indexPath.row - 3];
            }
        }
    }
}

-(void)pushDownedViewController:(NSInteger)index
{
    AlbumItem *album = [self.downedMuArray objectAtIndex:index];
    
    DownedViewController *downedVC = [[DownedViewController alloc]init];
    [downedVC getDownedData:album];
    downedVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:downedVC animated:YES];
}

-(void)pushDowningViewController
{
    DowningViewController *downingVC = [[DowningViewController alloc]init];
    downingVC.hidesBottomBarWhenPushed = YES;
    downingVC.navigationItem.titleView = [CommentMethods navigationTitleView:@"正在缓存"];
    [self.navigationController pushViewController:downingVC animated:YES];
}

-(void)pushMainListViewController
{
    MainListViewController *mainListController = [[MainListViewController alloc]init];
    mainListController.hidesBottomBarWhenPushed = YES;
    mainListController.navigationItem.titleView = [CommentMethods navigationTitleView:@"默认推荐"];
    [self.navigationController pushViewController:mainListController animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDownloadFinish object:nil];
    _dmAdView.delegate = nil;
    _dmAdView.rootViewController = nil;
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackDownloaded:) name:kNotificationDownloadFinish object:nil];
}

-(void)trackDownloaded:(NSNotification *)noti
{
    [self reloadMainView];
}

- (IBAction)chooseAction:(UIButton *)sender {
    
    self.chooseAllBtn.selected = !self.chooseAllBtn.selected;
    
    if (self.chooseAllBtn.selected) {
        deleMuArray = [NSMutableArray arrayWithArray:self.downedMuArray];
    }else{
        [deleMuArray removeAllObjects];
    }
    
    [self deleteNumAction];
    [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (IBAction)deleteAction:(UIButton *)sender {
    if (deleMuArray.count == 0) {
        [UIAlertView showWithTitle:@"温馨提示" message:@"请选择需要删除的节目" cancelButtonTitle:@"取消" otherButtonTitles:nil tapBlock:nil];
        return;
    }
    [SVProgressHUD show];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(deleteALbum) userInfo:nil repeats:NO];
}

-(void)deleteALbum
{
    [deleMuArray enumerateObjectsUsingBlock:^(AlbumItem *subAlb, NSUInteger idx, BOOL *stop) {
        NSArray *trackArr = [[DownList sharedManager] getDownedData:subAlb.album_id];
        for (int idx = 0; idx < [trackArr count]; idx++) {
            TrackItem *track = [trackArr objectAtIndex:idx];
            [[DownList sharedManager] deleteContent:track];
            
            NSString *trackPath = [NSString stringWithFormat:@"%@.mp3",track.track_id];
            NSString *paths = [CommentMethods getTargetFloderPath];
            NSString *documentFileName = [paths stringByAppendingPathComponent:trackPath];
            [CommentMethods clearDocu:documentFileName];
            
        }
    }];
    
    [self.downedMuArray removeObjectsInArray:deleMuArray];
    [deleMuArray removeAllObjects];
    [SVProgressHUD dismiss];
    
    [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self buttonPressedAction];
}


@end

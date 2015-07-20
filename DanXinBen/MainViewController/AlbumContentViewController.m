//
//  AlbumContentViewController.m
//  buddhism
//
//  Created by Jiangwei on 14/10/10.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "AlbumContentViewController.h"
#import "AlbumContentCell.h"
#import "NetService.h"
#import "AlbumItem.h"
#import "Header.h"
#import "MoreAppItem.h"
#import "MoreAppCell.h"
#import "DownList.h"
#import "PlayViewController.h"
#import <Util.h>
#import "DownloadService.h"

@interface AlbumContentViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray       *albumContentItems;
@property (strong, nonatomic) IBOutlet UITableView *albumContentTbView;
@property (strong, nonatomic) IBOutlet UIImageView *albumImageView;
@property (strong, nonatomic) IBOutlet UILabel *albumTitle;
@property (strong, nonatomic) IBOutlet UILabel *trackCount;
@property (strong, nonatomic) IBOutlet UILabel *hotNum;
@property (strong, nonatomic) IBOutlet UIScrollView *albumScroller;
@property (strong, nonatomic) IBOutlet UIImageView *selectImageView;
@property (nonatomic, strong) AlbumItem *albumItem;
@property (strong, nonatomic) IBOutlet UITextView *descView;
@property (strong, nonatomic) IBOutlet UITableView *recTbview;
@property (nonatomic, strong) NSMutableArray *recArray;

@property (strong, nonatomic) IBOutlet UIButton *descBtn;
@property (strong, nonatomic) IBOutlet UIButton *listBtn;
@property (strong, nonatomic) IBOutlet UIButton *recBtn;
//@property (strong, nonatomic) MJRefreshFooterView *footer;

@property NSInteger has_next;

@property (assign, nonatomic) TapStyle tapStyle;


@end

@implementation AlbumContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.albumContentTbView.separatorStyle = NO;
    
    self.albumContentItems = [NSMutableArray arrayWithCapacity:0];
    self.recArray = [NSMutableArray arrayWithCapacity:0];
    self.descView.userInteractionEnabled = NO;
    self.descView.textColor = UIColorFromRGB(134, 166, 201);

    [self getAlbumContentData:@(0)];
    [self getMoreAppData];
    [self customScroller];
    
    self.view.backgroundColor = CustomBgColor;
    self.albumContentTbView.backgroundColor = [UIColor clearColor];
    self.descView.backgroundColor = [UIColor clearColor];
    self.recTbview.backgroundColor = [UIColor clearColor];
    self.albumContentTbView.separatorStyle = NO;
    self.recTbview.separatorStyle = NO;
    
    self.navigationItem.backBarButtonItem = [CommentMethods commendBackItem];

}

-(void)customScroller
{
    if (IS_IOS_7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.albumScroller.contentSize = CGSizeMake(mainScreenWidth*3, CGRectGetHeight(self.albumScroller.bounds));
    self.albumScroller.pagingEnabled = YES;
    
    [self btnListAction];
}

#pragma mark UIScorllViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.albumScroller]){
        CGFloat selectWidth = self.recBtn.center.x - self.descBtn.center.x;
        CGFloat contentWith = scrollView.contentSize.width *2.0/3;
        CGFloat lengthFac = scrollView.contentOffset.x / contentWith;
        CGFloat selectX = selectWidth * lengthFac;
        self.selectImageView.center = ccp(self.descBtn.center.x + selectX, self.selectImageView.center.y);
    }
}
- (IBAction)btnAction:(UIButton *)sender
{
    if (sender == self.descBtn) {
        [self btnDescAction];
    }else if(sender == self.listBtn){
        [self btnListAction];
    }else if(sender == self.recBtn){
        [self btnRecAction];
    }
}

-(void)btnDescAction
{
    [self.albumScroller scrollRectToVisible:self.descView.frame animated:YES];
    self.tapStyle = TapStyleDesc;
    self.descView.text = self.albumItem.desc;
    self.selectImageView.center = ccp(self.descBtn.center.x, self.selectImageView.center.y);
}

-(void)btnListAction
{
    CGRect newRect = self.albumContentTbView.frame;
    [self.albumScroller scrollRectToVisible:newRect animated:YES];
    self.tapStyle = TapStyleList;
    self.selectImageView.center = ccp(self.listBtn.center.x, self.selectImageView.center.y);
    [self.albumContentTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

-(void)btnRecAction
{
    [self.albumScroller scrollRectToVisible:self.recTbview.frame animated:YES];
    self.tapStyle = TapStyleRec;
    self.selectImageView.center = ccp(self.recBtn.center.x, self.selectImageView.center.y);
    [self.recTbview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.albumScroller isEqual:scrollView]) {
        CGFloat pageWith = CGRectGetWidth(self.albumScroller.bounds);
        int page = floor((self.albumScroller.contentOffset.x - pageWith/2)/pageWith) + 1;
        switch (page) {
            case 0:{
                [self btnDescAction];
            }
                break;
            case 1:{
                [self btnListAction];
            }
                break;
            case 2:{
                [self btnRecAction];
            }
                break;
            default:
                break;
        }
    }
}

-(void)getAlbumContentData:(NSNumber *)last_dataId
{
    [[NetManager sharedNetManager] getAlbumAllContentDataAlbumId:self.albumId Success:^(NSDictionary *sucRes) {
        
        if (last_dataId.integerValue == 0) {
            [self.albumContentItems removeAllObjects];
        }
        
        self.has_next = [sucRes[@"has_next"] integerValue];
        
        NSDictionary *albumDic = sucRes[@"album"];
        self.albumItem = [[AlbumItem alloc]initWithDict:albumDic];
        self.albumItem.play_times = self.playtimes;
        
        [self setAlbumMes];
        
        NSArray *trackArray = sucRes[@"list"];
        for(NSDictionary *dic in trackArray)
        {
            TrackItem *trackItem = [[TrackItem alloc]initWithDict:dic];
            trackItem.album = self.albumItem;
            
            [self.albumContentItems addObject:trackItem];
        }
        
//        if (self.albumContentItems.count > 10) {
//            TrackItem *track = [[TrackItem alloc]init];
//            track.title = @"推广";
//            [self.albumContentItems insertObject:track atIndex:9];
//        }
        
        [self.albumContentTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        [self.albumContentTbView footerEndRefreshing];
    } failure:^(NSDictionary *failRes){
        ;
    }];
}

-(void)getMoreAppData
{
    [[NetManager sharedNetManager] getMoreAppDataSuccess:^(NSDictionary *sucRes) {
        
        [self.recArray removeAllObjects];
        
        NSString *image_root = sucRes[@"image_root"];
        NSArray *array = sucRes[@"list"];
        
        for (NSArray *moreArray in array) {
            MoreAppItem *moreItem = [[MoreAppItem alloc]init];
            moreItem.appTitle = moreArray[0];
            moreItem.appDesc = moreArray[1];
            moreItem.appStoreUrl = moreArray[2];
            moreItem.appImageUrl = [NSString stringWithFormat:@"%@%@",image_root,moreArray[4]];
            [self.recArray addObject:moreItem];
        }
        [self.recTbview  performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    } failure:^(NSDictionary *failRes) {
        ;
    }];
}


-(void)setAlbumMes
{
    self.descView.text = self.albumItem.desc;
    self.descView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.albumImageView setImageWithURL:[NSURL URLWithString:self.albumItem.image_url] placeholderImage:[UIImage imageNamed:@"albumDefault"]];
    self.albumTitle.text = self.albumItem.sub_category_title;
    
    if (self.albumItem.play_times.integerValue == 0) {
        self.hotNum.hidden = YES;
    }else{
        self.hotNum.hidden = NO;
        if (self.albumItem.play_times.integerValue >= 10000) {
            NSInteger wan = self.albumItem.play_times.integerValue/10000;
            NSInteger qian = self.albumItem.play_times.integerValue%10000/1000;
            self.hotNum.text = [NSString stringWithFormat:@"热度：%ld.%ld万",(long)wan,(long)qian];
        }else{
            self.hotNum.text = [NSString stringWithFormat:@"热度：%@",self.albumItem.play_times];
        }
    }
   
    self.trackCount.text = [NSString stringWithFormat:@"节目数：%@",self.albumItem.track_nums];
    
    self.navigationItem.titleView = [CommentMethods navigationTitleView:self.albumItem.title];
    
}

#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.albumContentTbView]) {
        return self.albumContentItems.count;
    }else if([tableView isEqual:self.recTbview]){
        return self.recArray.count;
    }else{
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.albumContentTbView]) {
        return 60;
    }else if ([tableView isEqual:self.recTbview]){
        return 65;
    }
    return 0;
}

-(void)downAction:(UIButton *)sender
{
    TrackItem *track = [self.albumContentItems objectAtIndex:sender.tag - 100];
    track.album = self.albumItem;
    track.album.downed_date = [CommentMethods transformateToNSDate:[Util getCurrentTime]];
    track.downStatus = @"doing";
    [[DownList sharedManager] saveContent:track];
    [SVProgressHUD showSuccessWithStatus:@"已加入下载列表"];
    [[DownloadService sharedDownloadService] addDownloadQueueWithTrack:track autoStart:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.albumContentTbView]) {
        static NSString *cell1Identifier = @"AlbumContentCell";
        AlbumContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1Identifier];
        if (!cell) {
            cell = (AlbumContentCell*)CREAT_XIB(@"AlbumContentCell");
        }
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TrackItem *item = [self.albumContentItems objectAtIndex:indexPath.row];
//        if ([item.title isEqualToString:@"推广"]) {
//            [cell morePushAppCell];
//        }else{
            [cell setDetailModel:item];
            cell.downBtn.tag = 100 + indexPath.row;
            [cell.downBtn addTarget:self action:@selector(downAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
        return cell;
    }else if([tableView isEqual:self.recTbview]){
        static NSString *cell1Identifier = @"MoreAppCell";
        MoreAppCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1Identifier];
        if (!cell) {
            cell = (MoreAppCell*)CREAT_XIB(@"MoreAppCell");
        }
        cell.backgroundColor = [UIColor clearColor];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MoreAppItem *item = [self.recArray objectAtIndex:indexPath.row];
        [cell setMoreCell:item];
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.albumContentTbView]) {
        PlayViewController *playVC = [PlayViewController sharedManager];
        
        TrackItem *track = [self.albumContentItems objectAtIndex:indexPath.row];
//        if ([track.title isEqualToString:@"推广"]) {
//            [MobClick event:@"albumcontent_appStore" label:@"专辑内页升级入口"];
//            [self pushAppStore];
//        }else{
            [playVC requestPlayData:track];
            
            playVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:playVC animated:YES];
//        }
        
    }else if([tableView isEqual:self.recTbview]){
        MoreAppItem *moreItem = [self.recArray objectAtIndex:indexPath.row];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:moreItem.appStoreUrl]];
    }
}

#pragma mark - 
#pragma mark - 跳转至多听FM Appstore
-(void)pushAppStore
{
//    NSString * url;
//    if (IS_IOS_7) {
//        url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", 594109494];
//    }
//    else{
//        url=[NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",594109494];
//    }
//    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)downAllTracks:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"正在加入下载列表"];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(downAction) userInfo:nil repeats:NO];
}

-(void)downAction
{
    for (int i=0; i<self.albumContentItems.count; i++) {
        TrackItem *track = self.albumContentItems[i];
        if (![track.title isEqualToString:@"推广"]) {
            track.downStatus = @"doing";
            [[DownList sharedManager] saveContent:track];
            [[DownloadService sharedDownloadService] addDownloadQueueWithTrack:track autoStart:YES];
        }
    }
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"已加入下载列表"];
}
@end

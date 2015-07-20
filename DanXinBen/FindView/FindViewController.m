//
//  FindViewController.m
//  buddhism
//
//  Created by Jiangwei on 14/10/8.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "FindViewController.h"
#import "NetManager.h"
#import "CategoryItem.h"
#import "Header.h"
#import "AlbumContentViewController.h"
#import "MainListViewCell.h"
#import "AlbumContentCell.h"
#import "PlayViewController.h"

#define MENUHEIHT 40

@interface FindViewController ()<MenuHrizontalDelegate,ScrollPageViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>
{
    MenuHrizontal *mMenuHriZontal;
    ScrollPageView *mScrollPageView;
    NSInteger albumCount;
    NSInteger trackCount;
}

@property (nonatomic, strong) NSMutableArray *categoryMuArray;
@property (strong, nonatomic) IBOutlet UITableView *historyTbView;
@property (strong, nonatomic) NSMutableArray *historyMuArray;
@property (strong, nonatomic) UISearchBar *historySearchBar;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIScrollView *searchScroller;
@property (strong, nonatomic) IBOutlet UITableView *albumTbView;
@property (strong, nonatomic) NSMutableArray *albumMuArray;
@property (strong, nonatomic) IBOutlet UITableView *trackTbView;
@property (strong, nonatomic) NSMutableArray *trackMuArray;
@property (strong, nonatomic) IBOutlet UIButton *albumBtn;
@property (strong, nonatomic) IBOutlet UIButton *trackBtn;
@property  NSInteger album_has_next;
@property  NSInteger track_has_next;
@property (strong, nonatomic) IBOutlet UIImageView *albumImageView;
@property (strong, nonatomic) IBOutlet UIButton *empty_btn;
@property (strong, nonatomic) IBOutlet UIImageView *trackImageView;
@property (strong, nonatomic) IBOutlet UIButton *empty_trackBtn;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = CustomBgColor;
    self.navigationItem.backBarButtonItem = [CommentMethods commendBackItem];
    [self getNetData];
    [self customSearchView];
    
    self.titleView.hidden = YES;
    self.searchScroller.hidden = YES;
    
    self.albumImageView.userInteractionEnabled = YES;
    self.trackImageView.userInteractionEnabled = YES;
    
    if (IS_IOS_7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.searchScroller.contentSize = CGSizeMake(mainScreenWidth*2, CGRectGetHeight(self.searchScroller.bounds));
    self.searchScroller.pagingEnabled = YES;
    self.searchScroller.delegate = self;
    
    _albumMuArray = [NSMutableArray arrayWithCapacity:0];
    _trackMuArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.albumBtn setTitleColor:CustomColor forState:UIControlStateNormal];
    [self.trackBtn setTitleColor:NavTitleColor forState:UIControlStateNormal];
    self.albumBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.trackBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.titleView.backgroundColor = [UIColor clearColor];
    self.albumTbView.separatorStyle = NO;
    self.albumTbView.backgroundColor = [UIColor clearColor];
    self.trackTbView.separatorStyle = NO;
    self.trackTbView.backgroundColor = [UIColor clearColor];
    
    self.historyTbView.separatorStyle = NO;
    self.historyTbView.backgroundColor = [UIColor clearColor];
}

-(void)customSearchView
{
    _historySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 27)];
    self.historySearchBar.delegate = self;
    self.historySearchBar.placeholder=[NSString stringWithCString:"搜索您喜欢的节目"  encoding: NSUTF8StringEncoding];
    [self.historySearchBar sizeToFit];

    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:NavTitleColor];
    
    [self.historySearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"find_searchBar"] forState:UIControlStateNormal];

    self.navigationItem.titleView = self.historySearchBar;
    
    _historyMuArray = [NSMutableArray arrayWithCapacity:0];
    self.historyTbView.hidden = YES;
}

-(void)getNetData
{
    [[NetManager sharedNetManager] getSubcategoryTitleSuccess:^(NSDictionary *sucRes) {
        NSArray *categoryArray = sucRes[@"category_list"];
        
        self.categoryMuArray = [NSMutableArray arrayWithCapacity:categoryArray.count];
        
        for(NSDictionary *dic in categoryArray)
        {
            CategoryItem *categoryItem = [[CategoryItem alloc]initWithDict:dic];
            [self.categoryMuArray addObject:categoryItem];
        }
        
        [self commInit];
    } failure:^(NSDictionary *failRes) {
        ;
    }];
}

-(void)commInit
{
    NSMutableArray *vBtnItemArray = [NSMutableArray arrayWithCapacity:self.categoryMuArray.count];
    for(CategoryItem *item in self.categoryMuArray){
        if([item.title isEqualToString:@"全部"]){
            item.title = @"排行榜";
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setSafeObject:item.title forKey:TITLEKEY];
        [vBtnItemArray addObject:dic];
    }
    
    if(mMenuHriZontal == nil){
        mMenuHriZontal = [[MenuHrizontal alloc]initWithFrame:CGRectMake(0, 64, mainScreenWidth, MENUHEIHT) ButtonItems:[NSArray arrayWithArray:vBtnItemArray]];
        mMenuHriZontal.delegate = self;
        mMenuHriZontal.backgroundColor = [UIColor clearColor];
    }
    
    __weak FindViewController *bSelf = self;
    
    if (mScrollPageView == nil) {
        if (IS_IOS_7) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        mScrollPageView = [[ScrollPageView alloc]initWithFrame:CGRectMake(0, 64+MENUHEIHT, mainScreenWidth, mainScreenHeight - 64 - MENUHEIHT - 49)];
        mScrollPageView.delegate = self;
        mScrollPageView.backgroundColor = [UIColor clearColor];
        [mScrollPageView setAlbumCallBack:^(NSInteger indexRow, AlbumItem *item) {
            [bSelf didSelectRow:indexRow andItem:item];
        }];
        [mScrollPageView setContentOfTables:vBtnItemArray.count];
        
        [mMenuHriZontal clickButtonAtIndex:0];
        
        [self.view addSubview:mScrollPageView];
        [self.view addSubview:mMenuHriZontal];
    }
}

-(void)didSelectRow:(NSInteger)index andItem:(AlbumItem *)item
{
    AlbumContentViewController *albumVC = [[AlbumContentViewController alloc]init];
    albumVC.hidesBottomBarWhenPushed = YES;
    albumVC.albumId = item.album_id;
    albumVC.playtimes = item.play_times;
    [self.navigationController pushViewController:albumVC animated:YES];
}

#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    CategoryItem *item = [self.categoryMuArray objectAtIndex:aIndex];
    [mScrollPageView setCategoryItem:item];
    
    [mScrollPageView moveScrollowViewAthIndex:aIndex];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    CategoryItem *item = [self.categoryMuArray objectAtIndex:aPage];
    [mScrollPageView setCategoryItem:item];
    
    [mMenuHriZontal changeButtonStateAtIndex:aPage];
    //刷新当页数据
    [mScrollPageView freshContentTableAtIndex:aPage];
}

#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.historyTbView]) {
        return self.historyMuArray.count;
    }else if([tableView isEqual:self.albumTbView]){
        if (self.albumMuArray.count > 5) {
            albumCount = 5;
        }else if (self.albumMuArray.count > 0){
            albumCount = self.albumMuArray.count;
        }else{
            albumCount = 0;
        }
        return albumCount;
    }else if([tableView isEqual:self.trackTbView]){
        
        if (self.trackMuArray.count > 6) {
            trackCount = 6;
        }else if (self.trackMuArray.count > 0){
            trackCount = self.trackMuArray.count;
        }else{
            trackCount = 0;
        }
        return trackCount;
    }
    return 0;
}

-(void)trackFooterView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 60)];
    footView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trackAppStore)];
    
    UIImage *footImage = [UIImage imageNamed:@"Update_button_off"];
    UIImageView *footImageView = [[UIImageView alloc]initWithImage:footImage];
    footImageView.frame = CGRectMake(mainScreenWidth/2 - 304/2, 10, 304, 40);
    footImageView.userInteractionEnabled = YES;
    
    UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, footImageView.frame.size.width, footImageView.frame.size.height)];
    footLabel.backgroundColor = [UIColor clearColor];
    footLabel.textColor = UIColorFromRGB(134, 166, 201);
    footLabel.textAlignment = kTextAlignmentCenter;
    footLabel.text = @"升级高级版可获取更多搜索专辑";
    [footImageView addSubview:footLabel];
    
    [footImageView addGestureRecognizer:tapRecognizer];
    
    [footView addSubview:footImageView];
    
    if (self.trackMuArray.count != 0) {
        self.trackTbView.tableFooterView = footView;
    }else{
        self.trackTbView.tableFooterView = nil;
    }
}

-(void)albumFooterView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 60)];
    footView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumAppStore)];
    
    UIImage *footImage = [UIImage imageNamed:@"Update_button_off"];
    UIImageView *footImageView = [[UIImageView alloc]initWithImage:footImage];
    footImageView.frame = CGRectMake(mainScreenWidth/2 - 304/2, 10, 304, 40);
    footImageView.userInteractionEnabled = YES;
    
    UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, footImageView.frame.size.width, footImageView.frame.size.height)];
    footLabel.backgroundColor = [UIColor clearColor];
    footLabel.textColor = UIColorFromRGB(134, 166, 201);
    footLabel.textAlignment = kTextAlignmentCenter;
    footLabel.text = @"升级高级版可获取更多搜索节目";
    [footImageView addSubview:footLabel];
    
    [footImageView addGestureRecognizer:tapRecognizer];
    
    [footView addSubview:footImageView];
    
    if (self.albumMuArray.count != 0) {
        self.albumTbView.tableFooterView = footView;
    }else{
        self.albumTbView.tableFooterView = nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.albumTbView]) {
        return 93;
    }else if ([tableView isEqual:self.trackTbView]){
        return 60;
    }else if([tableView isEqual:self.historyTbView]){
        return 40;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.historyTbView]) {
        static NSString *cellIdentifier = @"historySearch";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historySearch"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = NavTitleColor;
            
            UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setting_list_line"]];
            view.frame = CGRectMake(0, 39, mainScreenWidth, 1);
            [cell.contentView addSubview:view];
        }
        NSString *str = [self.historyMuArray objectAtIndex:indexPath.row];
        cell.textLabel.text = str;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        btn.tag = indexPath.row;
        [btn setImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleHistory:) forControlEvents:UIControlEventTouchUpInside];
        NSArray *hisArray = [CommentMethods getSearchHistroy];
        if ([hisArray containsObject:str])  {
            cell.accessoryView = btn;
        }else{
            cell.accessoryView = nil;
        }
        
        return cell;
    }else if([tableView isEqual:self.albumTbView]){
        static NSString *cellIdentifier = @"MainListViewCell";
        MainListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (!cell) {
            cell = (MainListViewCell*)CREAT_XIB(@"MainListViewCell");
        }
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        AlbumItem *item = [self.albumMuArray objectAtIndex:indexPath.row];
        [cell setParam:item];
        return cell;
        
    }else if([tableView isEqual:self.trackTbView]){
        static NSString *cell1Identifier = @"AlbumContentCell";
        AlbumContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1Identifier];
        if (!cell) {
            cell = (AlbumContentCell*)CREAT_XIB(@"AlbumContentCell");
            cell.backgroundColor = [UIColor clearColor];
            cell.downBtn.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        TrackItem *item = [self.trackMuArray objectAtIndex:indexPath.row];
        [cell setDetailModel:item];
    
        return cell;
    }
    return nil;
}

-(void)deleHistory:(UIButton *)hisBtn
{
    NSInteger index = hisBtn.tag;
    
    NSString *str = [self.historyMuArray objectAtIndex:index];
    [CommentMethods deleteSearchHistory:str];
    
    [self.historyMuArray removeObjectAtIndex:index];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.historyTbView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.historyTbView]) {
        NSString *str = [self.historyMuArray objectAtIndex:indexPath.row];
        [self searchForAlbumAndTrackData:str];
        self.historySearchBar.text = str;
        
    }else if([tableView isEqual:self.albumTbView]){
        
        AlbumItem *item = [self.albumMuArray objectAtIndex:indexPath.row];
        
        AlbumContentViewController *albumVC = [[AlbumContentViewController alloc]init];
        albumVC.hidesBottomBarWhenPushed = YES;
        albumVC.albumId = item.album_id;
        albumVC.playtimes = item.play_times;
        [self.navigationController pushViewController:albumVC animated:YES];

    }else if([tableView isEqual:self.trackTbView]){
        PlayViewController *playVC = [PlayViewController sharedManager];
        
        TrackItem *track = [self.trackMuArray objectAtIndex:indexPath.row];
        [playVC requestPlayData:track];
        
        playVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playVC animated:YES];
    }
}


#pragma mark - 
#pragma mark - UISearchBar Delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"开始点击");
    
    self.historyMuArray = [NSMutableArray arrayWithArray:[CommentMethods getSearchHistroy]];
    
    [self.historyTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    searchBar.showsCancelButton = YES;

    UIView *view = [searchBar.subviews objectAtIndex:0];
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)subView;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:CustomColor forState:UIControlStateNormal];
        }
    }
    [self hiddenView:YES];
    self.titleView.hidden = YES;
    self.searchScroller.hidden = YES;
}

-(void)hiddenView:(BOOL)status
{
    mMenuHriZontal.hidden = status;
    mScrollPageView.hidden = status;
    self.historyTbView.hidden = !status;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击取消按钮");
    [searchBar resignFirstResponder];
    self.historySearchBar.showsCancelButton = NO;

    [self hiddenView:NO];
    self.titleView.hidden = YES;
    self.searchScroller.hidden = YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchForAlbumAndTrackData:searchBar.text];
}

-(void)searchForAlbumAndTrackData:(NSString *)title
{
    NSLog(@"点击搜索按钮");
    [self.historySearchBar resignFirstResponder];
    [self.albumMuArray removeAllObjects];
    [self.trackMuArray removeAllObjects];
    
    mMenuHriZontal.hidden = YES;
    mScrollPageView.hidden = YES;
    self.historyTbView.hidden = YES;
    self.titleView.hidden = NO;
    self.searchScroller.hidden = NO;
    
    NSLog(@"输入完成");
    
    [CommentMethods saveSearchHistory:title];
    
    [[NetManager sharedNetManager] requestSeachAllWithLastId:0 title:title success:^(NSDictionary *sucRes) {
        
        NSArray *albumArray = sucRes[@"album_list"];
        self.album_has_next = [sucRes[@"album_has_next"] integerValue];
        
        for (NSDictionary *albDict in albumArray) {
            AlbumItem *album = [[AlbumItem alloc]initWithDict:albDict];
            [self.albumMuArray addObject:album];
        }
        [self.albumTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
        NSArray *trackArray = sucRes[@"track_list"];
        self.track_has_next = [sucRes[@"track_has_next"] integerValue];

        for (NSDictionary *albDict in trackArray) {
            TrackItem *track = [[TrackItem alloc]initWithDict:albDict];
            AlbumItem *album = [[AlbumItem alloc]init];
            album.album_id = albDict[@"album_id"];
            track.album = album;
            [self.trackMuArray addObject:track];
        }
        
        [self.trackTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
        [self searchViewEmpty];

    } failure:^(NSDictionary *failRes) {
        NSLog(@"failRes = %@",failRes);
        
    }];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"联想搜索");
    [self.historyMuArray removeAllObjects];

    if (![searchBar.text isEqualToString:@""]) {
        [[NetManager sharedNetManager] requestSearchWords:searchText Success:^(NSDictionary *sucRes) {
            [self.trackMuArray removeAllObjects];
            [self.albumMuArray removeAllObjects];
            
            NSArray *seachAlbums = sucRes[@"album_list"];
            for (NSDictionary *albDict in seachAlbums) {
                NSString *alb = albDict[@"title"];
                [self.historyMuArray addObject:alb];
            }
            NSArray *seachTracks = [sucRes objectForKeySafely:@"track_list"];
            for (NSDictionary *trackDic in seachTracks) {
                NSString *tk = trackDic[@"title"];
                [self.historyMuArray addObject:tk];
            }
            [self.historyTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
        } failure:^(NSDictionary *failRes) {
            NSLog(@"failRes = %@",failRes);
            NSLog(@"error_msg = %@",failRes[@"error_msg"]);
        }];
    }else{
        self.historyMuArray = [NSMutableArray arrayWithArray:[CommentMethods getSearchHistroy]];
        [self.historyTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.historyTbView]) {
        [self.historySearchBar resignFirstResponder];
    }else if([scrollView isEqual:self.searchScroller]){
        if (scrollView.contentOffset.x == 0) {
            [self.albumBtn setTitleColor:CustomColor forState:UIControlStateNormal];
            [self.trackBtn setTitleColor:NavTitleColor forState:UIControlStateNormal];
            self.albumBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            self.trackBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            
        }else if (scrollView.contentOffset.x == mainScreenWidth){
            [self.albumBtn setTitleColor:NavTitleColor forState:UIControlStateNormal];
            [self.trackBtn setTitleColor:CustomColor forState:UIControlStateNormal];
            self.albumBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            self.trackBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        }
    }
}

- (IBAction)albumAction:(id)sender {
    [self.searchScroller scrollRectToVisible:self.albumTbView.frame animated:YES];
}
- (IBAction)trackAction:(id)sender {
    [self.searchScroller scrollRectToVisible:self.trackTbView.frame animated:YES];
}

-(void)albumAppStore
{
    [MobClick event:@"sourch_album_appStore" label:@"搜索页专辑升级入口"];
    [self emptyAction:nil];
}

-(void)trackAppStore
{
    [MobClick event:@"sourch_track_appStore" label:@"搜索页节目升级入口"];
    [self emptyAction:nil];
}

- (IBAction)emptyAction:(UIButton *)sender {
    NSString * url;
    if (IS_IOS_7) {
        url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", 594109494];
    }
    else{
        url=[NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",594109494];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)searchViewEmpty
{
    if (self.albumMuArray.count == 0 || self.trackMuArray.count ==0) {
        self.empty_btn.hidden = NO;
        self.albumImageView.hidden = NO;
    }else{
        self.empty_btn.hidden = YES;
        self.albumImageView.hidden = YES;
    }
    
    if (self.trackMuArray.count ==0) {
        self.empty_trackBtn.hidden = NO;
        self.trackImageView.hidden = NO;
    }else{
        self.empty_trackBtn.hidden = YES;
        self.trackImageView.hidden = YES;
    }
    
    [self albumFooterView];
    [self trackFooterView];
}

@end

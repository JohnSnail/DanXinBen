//
//  MainListViewController.m
//  buddhism
//
//  Created by Jiangwei on 14/10/10.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "MainListViewController.h"
#import "MainListViewCell.h"
#import "AlbumContentViewController.h"
#import "Header.h"

static NSString* const MainListCellIdentifier = @"MainListViewCell";

@interface MainListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainListTbView;
@property (nonatomic, strong) NSMutableArray       *mainListItems;

@end

@implementation MainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainListTbView.separatorStyle = NO;
    self.mainListTbView.backgroundColor = [UIColor clearColor];
    self.mainListTbView.backgroundView = nil;
    self.view.backgroundColor = CustomBgColor;

    self.navigationItem.backBarButtonItem = [CommentMethods commendBackItem];
    [self.mainListTbView registerClass:[MainListViewCell class] forCellReuseIdentifier:MainListCellIdentifier];
    
    [self getNetSeviceData];
}

-(void)getNetSeviceData
{
    self.mainListItems = [NSMutableArray arrayWithCapacity:0];
    
    [[NetManager sharedNetManager] getMainData:@(0) andSub_category_id:@(subCategoryId) Success:^(NSDictionary* sucRes) {
        [self.mainListItems removeAllObjects];
        NSArray *albumList = sucRes[@"album_list"];
        for(NSDictionary *dic in albumList)
        {
            AlbumItem *albumItem = [[AlbumItem alloc]initWithDict:dic];
            [self.mainListItems addObject:albumItem];
        }
        [self.mainListTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    } failure:^(NSDictionary* failRes) {
        
    }];
}

#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainListItems.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainListCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AlbumItem *item = [self.mainListItems objectAtIndex:indexPath.row];
    [cell setParam:item];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumItem *item = [self.mainListItems objectAtIndex:indexPath.row];
    
    AlbumContentViewController *albumVC = [[AlbumContentViewController alloc]init];
    albumVC.hidesBottomBarWhenPushed = YES;
    albumVC.albumId = item.album_id;
    albumVC.playtimes = item.play_times;
    [self.navigationController pushViewController:albumVC animated:YES];
}

@end

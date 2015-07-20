//
//  CustomTableView.m
//  ShowProduct
//
//  Created by klbest1 on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "CustomTableView.h"
//#import "LoadMoreCell.h"
#import "NetManager.h"
#import "AlbumItem.h"
#import "CategoryItem.h"
#import "UIScrollView+DXRefresh.h"

@implementation CustomTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (_homeTableView == nil) {
            _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            _homeTableView.delegate = self;
            _homeTableView.dataSource = self;
            [_homeTableView setBackgroundColor:[UIColor clearColor]];
        }
        if (_tableInfoArray == nil) {
            _tableInfoArray = [[NSMutableArray alloc] init];
        }
        [self addSubview:_homeTableView];
        
        [self addFooter];
    }
    return self;
}

- (void)addFooter
{
    [self.homeTableView addFooterWithTarget:self action:@selector(refreshFooter)];
}

-(void)refreshFooter
{
    if (has_next == 1) {
        AlbumItem *item = [self.tableInfoArray lastObject];
        [self getFindData:item.data_order];
    }else{
        [self.homeTableView removeFooter];
    }
}


-(void)dealloc{
    [_tableInfoArray removeAllObjects],[_tableInfoArray release], _tableInfoArray = Nil;
//    [_refreshHeaderView release];
    [_homeTableView release];
    [super dealloc];
}

#pragma mark 其他辅助功能
#pragma mark 强制列表刷新
-(void)forceToFreshData:(CategoryItem *)item{
    categoryId = item.categoryId;
    [self getFindData:@(0)];
}

-(void)getFindData:(NSNumber *)data_order
{
    [[NetManager sharedNetManager] getMainData:data_order andSub_category_id:categoryId Success:^(NSDictionary *sucRes) {
        if (data_order.integerValue == 0) {
            [self.tableInfoArray removeAllObjects];
        }
        
        has_next = [sucRes[@"has_next"] integerValue];
        
        NSArray *albumList = sucRes[@"album_list"];
        for(NSDictionary *dic in albumList)
        {
            AlbumItem *albumItem = [[AlbumItem alloc]initWithDict:dic];
            [self.tableInfoArray addObject:albumItem];
        }
        
        [self.homeTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        [self.homeTableView footerEndRefreshing];
    } failure:^(NSDictionary *failRes) {
        ;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_delegate respondsToSelector:@selector(numberOfRowsInTableView:InSection:FromView:)]) {
       NSInteger vRows = [_dataSource numberOfRowsInTableView:tableView InSection:section FromView:self];
        mRowCount = vRows;
        return vRows;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(heightForRowAthIndexPath:IndexPath:FromView:)]) {
        float vRowHeight = [_delegate heightForRowAthIndexPath:tableView IndexPath:indexPath FromView:self];
        return vRowHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_dataSource respondsToSelector:@selector(cellForRowInTableView:IndexPath:FromView:)]) {
        UITableViewCell *vCell = [_dataSource cellForRowInTableView:tableView IndexPath:indexPath FromView:self];
        vCell.backgroundColor = [UIColor clearColor];
        return vCell;
    }
    return Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(didSelectedRowAthIndexPath:IndexPath: FromView:)]) {
        [_delegate didSelectedRowAthIndexPath:tableView IndexPath:indexPath FromView:self];
    }
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    if ([_delegate respondsToSelector:@selector(refreshData: FromView:)]) {
        [_delegate refreshData:^{
            [self doneLoadingTableViewData];
        } FromView:self];
    }else{
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    }
}

- (void)doneLoadingTableViewData{
	
	_reloading = NO;
    [self.homeTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

@end

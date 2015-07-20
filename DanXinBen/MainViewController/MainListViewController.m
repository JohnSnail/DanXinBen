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
#import "ListWireframe.h"

#define MainListCellIdentifier @"MainListViewCell"

@interface MainListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainListTbView;

@end

@implementation MainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainListTbView.separatorStyle = NO;
    [self.mainListTbView registerClass:[MainListViewCell class] forCellReuseIdentifier:MainListCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AlbumItem *item = [self.mainListItems objectAtIndex:indexPath.row];
    [cell setParam:item];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumItem *item = [self.mainListItems objectAtIndex:indexPath.row];
    
    [[ListWireframe sharedManager] pushAlbumContentController:self andAlbum:item.id];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

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
#import "ListWireframe.h"

static NSString* const MainCellIdentifier = @"MainTableViewCell";

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray       *mainItems;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainTableView.separatorStyle = NO;
    [self.mainTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:MainCellIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addItems:(NSArray *)items
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.mainItems];
    [arr addObjectsFromArray:items];
    self.mainItems = arr;
    [self.mainTableView reloadData];
}

#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 60;
    }else if(indexPath.row == 1){
        return 110;
    }else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell setCellHidden:YES];
        cell.textLabel.text = @"默认推荐";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1){
        [cell setCellHidden:NO];
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
    }else if (indexPath.row == 2){
        [cell setCellHidden:YES];
        cell.textLabel.text = @"我的下载";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        [[ListWireframe sharedManager] pushChildController:self andArray:self.mainItems];
    }
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

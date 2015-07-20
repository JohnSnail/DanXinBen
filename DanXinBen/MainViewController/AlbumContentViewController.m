//
//  AlbumContentViewController.m
//  buddhism
//
//  Created by Jiangwei on 14/10/10.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "AlbumContentViewController.h"
#import "AlbumContentCell.h"

static NSString* const AlbumContentCellIdentifier = @"AlbumContentCell";

@interface AlbumContentViewController ()

@property (nonatomic, strong) NSArray       *albumContentItems;
@property (strong, nonatomic) IBOutlet UITableView *albumContentTbView;

@end

@implementation AlbumContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.albumContentTbView.separatorStyle = NO;
    [self.albumContentTbView registerClass:[AlbumContentCell class] forCellReuseIdentifier:AlbumContentCellIdentifier];
}

- (void)addItems:(NSArray *)items
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.albumContentItems];
    [arr addObjectsFromArray:items];
    self.albumContentItems = arr;
    [self.albumContentTbView reloadData];
}

#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.albumContentItems.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumContentCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumContentCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ;
}


@end

//
//  DowningViewController.m
//  DanXinBen
//
//  Created by Jiangwei on 14/11/4.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "DowningViewController.h"
#import "DownList.h"
#import "DowningCell.h"
#import "DownloadService.h"
#import "UIAlertView+Blocks.h"

@interface DowningViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_processDownloadMArray;
    BOOL editeStatus;
    BOOL _isAutoResumeDownload;
    NSMutableArray *deleMuArray;
}

@property (strong, nonatomic) IBOutlet UITableView *downingTbView;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UIButton *chooseBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleBtn;

@end

@implementation DowningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.downingTbView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = CustomBgColor;
    self.downingTbView.separatorStyle = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editeAction)];

    deleMuArray = [NSMutableArray arrayWithCapacity:0];
    _processDownloadMArray = [NSMutableArray arrayWithCapacity:0];
    [self processDownloadData];
    
    [self addObserver];
    
    [DownloadService sharedDownloadService].progressNumBlock = ^(TrackItem *downloadingTrack, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        
        __block NSInteger delIdx = -1;
        [_processDownloadMArray enumerateObjectsUsingBlock:^(NSDictionary *downTrackDict, NSUInteger idx, BOOL *stop) {
            TrackItem *dictTk = [[downTrackDict allValues] firstObject];
            if ([downloadingTrack.track_id integerValue] == [dictTk.track_id integerValue]) {
                delIdx = idx;
                *stop = YES;
            }
        }];
        if (delIdx != -1) {
            
            DowningCell *cell = (DowningCell *)[self.downingTbView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:delIdx inSection:0]];
            if (cell) {
                [cell updateUIWithBytesRead:totalBytesReadForFile totalRead:totalBytesExpectedToReadForFile];
            }
        }
    };
    
    [self initBtnSelectStatus];
    
    [self updateStatus:YES];
}

-(void)updateStatus:(BOOL)status
{
    self.deleBtn.hidden = status;
    self.chooseBtn.hidden = status;
    self.startBtn.hidden = !status;
}

-(void)editeAction
{
    editeStatus = !editeStatus;
    if (editeStatus) {
        [self updateStatus:NO];
        if ([DownloadService sharedDownloadService].downState == DownloadStateNormal) {
            _isAutoResumeDownload = YES;
            [[DownloadService sharedDownloadService] pauseAll];
        }
        
    }else{
        [self updateStatus:YES];
        if (_isAutoResumeDownload) {
            if ([DownloadService sharedDownloadService].downState == DownloadStatePause) {
                [[DownloadService sharedDownloadService] resumeAllForce:YES];
            }
            _isAutoResumeDownload = NO;
        }
    }
    [self.downingTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}


-(void)initBtnSelectStatus
{
    switch ([DownloadService sharedDownloadService].downState) {
        case DownloadStateDefault:{
            self.startBtn.selected = NO;
        }
            break;
        case DownloadStatePause:{
            self.startBtn.selected = YES;
        }
            break;
            
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)processDownloadData
{
    _processDownloadMArray = [DownloadService sharedDownloadService].downloadQueue;
    
    [self.downingTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationDownloadFinish object:nil];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackDownloaded:) name:kNotificationDownloadFinish object:nil];
}

-(void)trackDownloaded:(NSNotification *)noti
{
    NSLog(@"一首下载完成");
    [self.downingTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _processDownloadMArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *trackCellIdentifier = @"DowningCell";
    
    DowningCell *downTrackCell = [tableView dequeueReusableCellWithIdentifier:trackCellIdentifier];
    if (!downTrackCell) {
        downTrackCell = (DowningCell *)CREAT_XIB(@"DowningCell");
        downTrackCell.selectionStyle = UITableViewCellSelectionStyleNone;
        downTrackCell.backgroundColor = [UIColor clearColor];

        downTrackCell.downProgressView = [[MCProgressBarView alloc] initWithFrame:CGRectMake(10, 28, 300, 2) backgroundImage:[UIImage imageNamed:@"play_cache"] foregroundImage:[UIImage imageNamed:@"play_slide_on"]];
        [downTrackCell.contentView addSubview:downTrackCell.downProgressView];
    }
    
    NSDictionary *tkDict = [_processDownloadMArray objectAtIndex:indexPath.row];
    
    TrackItem *tk = [[tkDict allValues] firstObject];
    [downTrackCell setDowningCell:tk];
    [downTrackCell setEditeStatus:editeStatus];
    
    downTrackCell.statusBlock = ^(BOOL isSelect){
        if (isSelect) {
            __block BOOL isExist = NO;
            [deleMuArray enumerateObjectsUsingBlock:^(NSDictionary *trackDict, NSUInteger idx, BOOL *stop) {
                TrackItem *delTrack = [[trackDict allValues] firstObject];
                if ([delTrack.track_id integerValue] == [tk.track_id intValue]) {
                    isExist = YES;
                    *stop = YES;
                }
            }];
            if (isExist) {
                //存在了
            } else {
                [deleMuArray addObject:tkDict];
            }
            
            if (deleMuArray && [deleMuArray count] && [_processDownloadMArray count]) {
                if ([deleMuArray count] == [_processDownloadMArray count]) {
                    self.chooseBtn.selected = YES;
                } else {
                    self.chooseBtn.selected = NO;
                }
            }
        } else {
            __block BOOL isExist = NO;
            __block NSDictionary *doDelTrackDict = nil;
            
            [deleMuArray enumerateObjectsUsingBlock:^(NSDictionary *trackDict, NSUInteger idx, BOOL *stop) {
                TrackItem *delTrack = [[trackDict allValues] firstObject];
                if ([delTrack.track_id integerValue] == [tk.track_id intValue]) {
                    isExist = YES;
                    doDelTrackDict = trackDict;
                    *stop = YES;
                }
            }];
            
            if (isExist && doDelTrackDict) {
                [deleMuArray removeObject:doDelTrackDict];
                self.chooseBtn.selected = NO;
            }
        }
        [self deleteNumAction];
    };
    
    __block BOOL isSelect = NO;
    [deleMuArray enumerateObjectsUsingBlock:^(NSDictionary *tkDict, NSUInteger idx, BOOL *stop) {
        TrackItem *subTk = [[tkDict allValues] firstObject];
        if ([subTk.track_id integerValue] == [tk.track_id integerValue]) {
            isSelect = YES;
            *stop = YES;
        }
    }];
    
    downTrackCell.selectBtn.selected = isSelect;
    
    return downTrackCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editeStatus) {
        DowningCell *tkCell = (DowningCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [tkCell selectAction:tkCell.selectBtn];
        
        [self.downingTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
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
        NSDictionary *tkDict = [_processDownloadMArray objectAtIndex:indexPath.row];
        TrackItem *track = [[tkDict allValues] firstObject];
        [[DownList sharedManager] deleteContent:track];
        
        [_processDownloadMArray removeObjectAtIndex:indexPath.row];
        [self.downingTbView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self afterDeleEmptyView];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (IBAction)starPauseAction:(UIButton *)sender {
    
    self.startBtn.selected = !self.startBtn.selected;
    
    [[NetService sharedNetService] reachablityStatus:^(int sucNet) {
        if (!self.startBtn.selected) {
            
            switch ([DownloadService sharedDownloadService].downState) {
                case DownloadStateDefault:{
                    [[DownloadService sharedDownloadService] start];
                }
                    break;
                case DownloadStatePause:{
                    [[DownloadService sharedDownloadService] resumeAllForce:YES];
                }
                    break;
                    
                default:
                    break;
            }
        } else {
            [[DownloadService sharedDownloadService] pauseAll];
        }
    } fail:^(int failNet) {
        [UIAlertView showWithTitle:@"温馨提示" message:@"请检查您的网络" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
    }];
}

- (IBAction)chooseAction:(UIButton *)sender {
    self.chooseBtn.selected = !self.chooseBtn.selected;
    
    if (self.chooseBtn.selected) {
        deleMuArray = [NSMutableArray arrayWithArray:_processDownloadMArray];
    }else{
        [deleMuArray removeAllObjects];
    }
    
    [self deleteNumAction];
    [self.downingTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}
- (IBAction)deleAction:(UIButton *)sender {
    
    if ([deleMuArray count] == 0) {
        [UIAlertView showWithTitle:@"温馨提示" message:@"请选择要删除的节目" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        return;
    }
    
    [SVProgressHUD show];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(deleteTrack) userInfo:nil repeats:NO];
}

-(void)deleteTrack
{
    [deleMuArray enumerateObjectsUsingBlock:^(NSDictionary *tkDict, NSUInteger idx, BOOL *stop) {
        
        TrackItem *delTk = [[tkDict allValues] firstObject];
        delTk.downStatus = @"no";
        [[DownList sharedManager] deleteContent:delTk];
        [[DownloadService sharedDownloadService] cancel:delTk];
        
    }];
    [deleMuArray removeAllObjects];
    
    [self.downingTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [SVProgressHUD dismiss];
    [self deleteNumAction];
    [self editeAction];
    
    [self afterDeleEmptyView];
}

-(void)afterDeleEmptyView
{
    if (_processDownloadMArray.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

//
//  PlayViewController.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/24.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "PlayViewController.h"
#import "Header.h"
#import <AudioService.h>
#import "StyledPageControl.h"
#import "TrackItem.h"
#import "PlayCell.h"
#import "DTTimingViewController.h"
#import "DTTimingManager.h"
#import <util.h>
#import "MCProgressBarView.h"
#import "HistoryList.h"
#import "DownList.h"
#import "DownloadService.h"
#import <WXApi.h>
#import <UIAlertView+Blocks.h>
#import <UIActionSheet+Blocks.h>
#import "AppDelegate.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVFoundation.h>
#import <SCNetworkReachability.h>

@interface PlayViewController ()
{
    NSNumber *hisProgress;
    enum WXScene _scene;
}

@property (strong, nonatomic) UISlider *playSlider;
@property (strong, nonatomic) NSMutableArray *playMuArray;
@property NSInteger playIndex;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *albumImageView;
@property (strong, nonatomic) IBOutlet UITableView *playTbView;
@property (strong, nonatomic) IBOutlet UIScrollView *playScroller;
@property (strong, nonatomic) StyledPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) MCProgressBarView *cacheProgress;

- (IBAction)timeBtnAction:(id)sender;
- (IBAction)downBtnAction:(id)sender;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = CustomBgColor;
    [self initData];
    
    [DTTimingManager sharedDTTimingManager].timingBlk = ^(NSNumber *timing) {
        if (timing.integerValue == 0) {
            self.countLabel.text = @"";
            if ([DTTimingManager sharedDTTimingManager].timingState != TimingStateNone) {
                [[AudioService sharedAudioService] pause];
            }
        }else{
            self.countLabel.text = [Util formatIntoDateWithSecond:timing];
        }
    };
    
    self.navigationItem.backBarButtonItem = [CommentMethods commendBackItem];
    
    if (self.playMuArray == nil) {
        self.playMuArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"play_share_off"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
}


#pragma mark - 
#pragma mark - 分享至微信

-(void)sendToWeixin
{
    WXMediaMessage *object=[WXMediaMessage message];
    object.title=self.playTrack.title;
    object.description=self.playTrack.album.title;
    NSData *imageData = UIImageJPEGRepresentation(self.albumImageView.image, 0.0001);
    
    UIImage * m_selectImage = [UIImage imageWithData:imageData];
    
    [object setThumbImage:m_selectImage];
    WXMusicObject *music=[WXMusicObject object];
    
//    NSString *urlString=[NSString stringWithFormat:@"http://m.duotin.com/song?songid=%@",self.playTrack.track_id];
    music.musicUrl=self.playTrack.play_mp3_url_32;
    music.musicDataUrl=self.playTrack.play_mp3_url_32;
    object.mediaObject=music;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = object;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void)shareAction
{
    [WXApi registerApp:@"wxe2e3aebe80de1a43" withDescription:nil];

    NSArray *shareArray = [NSArray arrayWithObjects:@"分享给微信好友",@"分享到朋友圈", nil];
    
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:shareArray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSLog(@"buttonIndex = %ld",(long)buttonIndex);
        if (buttonIndex ==0) {
            _scene = WXSceneSession;
            [self sendToWeixin];
        }else if(buttonIndex == 1){
            _scene = WXSceneTimeline;
            [self sendToWeixin];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGPoint newPoint = self.playScroller.contentOffset;
    newPoint.x = 0;
    [self.playScroller setContentOffset:newPoint animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO ;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES ;
}

+ (PlayViewController *)sharedManager
{
    static PlayViewController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)initData
{
    if (IS_IOS_7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.playScroller.contentSize = CGSizeMake(mainScreenWidth*2, CGRectGetHeight(self.playScroller.bounds));
    self.playScroller.pagingEnabled = YES;
    self.playScroller.delegate = self;
    self.playScroller.showsVerticalScrollIndicator = NO;
    self.playScroller.showsHorizontalScrollIndicator = YES;
    
    self.timeLabel.textColor = CustomColor;
    self.countLabel.textColor = CustomColor;
    
    self.cacheProgress = [[MCProgressBarView alloc] initWithFrame:CGRectMake(0, mainScreenHeight - 88, mainScreenWidth, 2) backgroundImage:[UIImage imageNamed:@"play_slide_off"] foregroundImage:[UIImage imageNamed:@"play_cache"]];
    
    _cacheProgress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_cacheProgress];

    self.playSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 2)];
    [self.playSlider setThumbImage:[UIImage imageNamed:@"play_selected"] forState:UIControlStateNormal];
    [self.playSlider setThumbImage:[UIImage imageNamed:@"play_selected"] forState:UIControlStateHighlighted];
    
    [self.playSlider setMinimumTrackImage:[UIImage imageNamed:@"play_slide_on"] forState:UIControlStateNormal];
    [self.playSlider setMaximumTrackImage:[UIImage imageNamed:@"play_slide_clear"] forState:UIControlStateNormal];
    
    [self.playSlider addTarget:self action:@selector(startDrag) forControlEvents:UIControlEventTouchDown];
    [self.playSlider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    [self.playSlider addTarget:self action:@selector(endDrag) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    self.playSlider.minimumValue = .0f;
    [AudioService sharedAudioService].audioMaxAndMiniPlayTimeBlk = ^ (NSNumber *miniPlayTime, NSNumber *maxPlayTime) {
        if (maxPlayTime) {
            self.playSlider.maximumValue = [maxPlayTime floatValue];
        }
    };
    
    [self.cacheProgress addSubview:self.playSlider];
    
    [AudioService sharedAudioService].curAudioPlayComplteBlk = ^ (void) {
        if ([AudioService sharedAudioService].currentPlayState == AudioPlayStatePlaying && [DTTimingManager sharedDTTimingManager].timingState == TimingStateAfterCurrentFinish) {
            [[AudioService sharedAudioService] pause];
        } else {
            [[AudioService sharedAudioService] stop];
            
            self.playTrack.hisProgress = 0;
            [[HistoryList sharedManager] saveContent:self.playTrack];
            [self nextAction:nil];
        }
    };
    
    [AudioService sharedAudioService].curAudioProgressBlk = ^ (NSString *progressStr){
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([AudioService sharedAudioService].currentPlayState == AudioPlayStatePlaying) {
                self.playBtn.selected = YES;
            }else{
                self.playBtn.selected = NO;
            }
        
            if (hisProgress.doubleValue != 0 && [[AudioService sharedAudioService] trackTime]) {
                [[AudioService sharedAudioService] seekToTime:hisProgress.doubleValue];
                hisProgress = 0;
            }
            
            self.playSlider.value = [[AudioService sharedAudioService] amoutPlayedTime];
            self.timeLabel.text = progressStr;
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            NSString* date = [formatter stringFromDate:[NSDate date]];

            self.playTrack.update_data = date;
            self.playTrack.hisProgress = @([[AudioService sharedAudioService] amoutPlayedTime]);
            [[HistoryList sharedManager] saveContent:self.playTrack];
            
            AppDelegate *appDe = appDelegate;
            [appDe.PlayingInfoCenter setSafeObject:[NSNumber numberWithDouble:[[AudioService sharedAudioService] amoutPlayedTime]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
            [appDe.PlayingInfoCenter setSafeObject:[NSNumber numberWithDouble:[[AudioService sharedAudioService] trackTime]] forKey:MPMediaItemPropertyPlaybackDuration];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:appDe.PlayingInfoCenter];
        });
    };
    
    [AudioService sharedAudioService].curAudioPlayPrebufferProgressBlk = ^ (float prebufferPgs) {
        self.cacheProgress.progress = prebufferPgs;
    };
    
    self.albumImageView.layer.masksToBounds = YES;
    self.albumImageView.layer.cornerRadius = self.albumImageView.frame.size.height/2;
    
    self.pageControl = [[StyledPageControl alloc]initWithFrame:CGRectMake(mainscreen.size.width/2 - 70/2 - 20, mainScreenHeight - 130, 70, 37)];
    [self.pageControl setPageControlStyle:PageControlStyleThumb];
    [self.pageControl setThumbImage:[UIImage imageNamed:@"play_not_select"]];
    [self.pageControl setSelectedThumbImage:[UIImage imageNamed:@"play_selected"]];
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;
    self.pageControl.enabled = YES;
    [self.view addSubview:self.pageControl];
    
    self.playTbView.backgroundColor = [UIColor clearColor];
    self.playTbView.separatorStyle = NO;
}

#pragma mark -
#pragma mark - scroller 方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.playScroller]) {
        if (scrollView.contentOffset.x == 0) {
            self.pageControl.currentPage = 0;
            
        } else if (scrollView.contentOffset.x == mainScreenWidth) {
            self.pageControl.currentPage = 1;
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.playIndex inSection:0];
            [self.playTbView scrollToRowAtIndexPath:scrollIndexPath
                                   atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

#pragma mark - 
#pragma mark - slider方法
-(void)startDrag
{
    ;
}

-(void)sliderChanged
{
    NSString *tamoutTimerStr = [Util formatIntoDateWithSecond:@(self.playSlider.value)];
    NSString *pgsStr = [NSString stringWithFormat:@"%@/%@",tamoutTimerStr, [[AudioService sharedAudioService] trackTimeStr]];
    
    self.timeLabel.text = pgsStr;
}

-(void)endDrag
{
    [[AudioService sharedAudioService] seekToTime:self.playSlider.value];
}

-(void)getDownedPlayData:(NSMutableArray *)playArray andIndex:(NSInteger)index andAlbum:(AlbumItem *)album
{
    self.playMuArray = [NSMutableArray arrayWithCapacity:playArray.count];
    [self.playMuArray addObjectsFromArray:playArray];
    self.playIndex = index;
    
    self.playTrack = [self.playMuArray objectAtIndex:self.playIndex];
    self.playTrack.album = album;
    
    
    [self playMusic];
}

-(void)requestPlayData:(TrackItem *)track
{
    if (self.playTrack.track_id.integerValue == track.track_id.integerValue) {
        return;
    }
    [[NetManager sharedNetManager] getAlbumAllContentDataAlbumId:track.album.album_id Success:^(NSDictionary *sucRes){
        [self.playMuArray removeAllObjects];

        NSDictionary *albumDic = sucRes[@"album"];
        AlbumItem *albumItem = [[AlbumItem alloc]initWithDict:albumDic];
        
        NSArray *trackArray = sucRes[@"list"];
        for(int i=0; i<trackArray.count; i++){
            NSDictionary *dic = [trackArray objectAtIndex:i];
            TrackItem *trackItem = [[TrackItem alloc]initWithDict:dic];
            trackItem.album = albumItem;
            
            if (track.track_id.integerValue == trackItem.track_id.integerValue) {
                self.playTrack = trackItem;
                [self playMusic];
                self.playIndex = i;
            }
            [self.playMuArray addObject:trackItem];
            
            [self.playTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    } failure:^(NSDictionary *failRes) {
        ;
    }];
}

- (IBAction)lastAction:(id)sender {
    self.playIndex --;
    if (self.playIndex < 0) {
        self.playIndex = 0;
    }
    self.playTrack = [self.playMuArray objectAtIndex:self.playIndex];
    [self playMusic];
}

- (IBAction)playPauseAction:(id)sender {
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected) {
        [[AudioService sharedAudioService] resume];
    }else{
        [[AudioService sharedAudioService] pause];
    }
}

-(void)albumImageAction
{
    [self.albumImageView setImageWithURL:[NSURL URLWithString:self.playTrack.album.image_url]];
}

#pragma mark - 
#pragma mark - 播放音频

#pragma mark -
#pragma mark - 获取本地数据

-(BOOL)isFileExist:(NSString * )fileName
{
    //获取文件路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

-(void)playLoacalAndNetMusic
{
    if (self.playTrack) {
        if (ISVALIDURLSTRING(self.playTrack.play_mp3_url_32)) {
            //下载完成数据
            NSString *trackPath = [NSString stringWithFormat:@"%@.mp3",self.playTrack.track_id];
            NSString *paths = [CommentMethods getTargetFloderPath];
            NSString *documentFileName = [paths stringByAppendingPathComponent:trackPath];
            
            if ([self isFileExist:documentFileName]) {
                
                NSURL *newSuffixPathURL = [NSURL fileURLWithPath:documentFileName];
                [[AudioService sharedAudioService] play:newSuffixPathURL];
                
            }else {
                [[NetService sharedNetService] reachablityStatus:^(int netStatus) {
                    if(netStatus == SCNetworkStatusReachableViaWiFi) {
                        [[AudioService sharedAudioService] play:self.playTrack.play_mp3_url_32];
                        
                    } else if (netStatus == SCNetworkStatusReachableViaCellular) {
                        BOOL alert = [[NSUserDefaults standardUserDefaults] boolForKey:@"netAlert"];
                        
                        NSArray *alertArray = [NSArray arrayWithObjects:@"取消",@"继续", nil];
                        
                        if (!alert) {
                            [UIAlertView showWithTitle:@"温馨提示" message:@"继续播放将会耗费数据流量，是否继续播放?" cancelButtonTitle:nil otherButtonTitles:alertArray tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                
                                NSLog(@"button = %ld",(long)buttonIndex);
                                
                                if (buttonIndex == 1) {
                                     [[AudioService sharedAudioService] play:self.playTrack.play_mp3_url_32];
                                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"netAlert"];
                                }
                            }];
                        }else{
                            [[AudioService sharedAudioService] play:self.playTrack.play_mp3_url_32];
                        }
                    } else {
                        [[AudioService sharedAudioService] play:self.playTrack.play_mp3_url_32];
                    }
                    
                } fail:^(int failnetStatus) {
                    [UIAlertView showWithTitle:@"播放失败" message:@"网络不给力，无法继续播放" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
                }];
            }
        }
    }
}

-(void)playMusic
{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(albumImageAction) userInfo:nil repeats:NO];
    
    self.navigationItem.titleView = [CommentMethods navigationTitleView:self.playTrack.title];
    
    [self playLoacalAndNetMusic];
    
    TrackItem *track = [[HistoryList sharedManager] updateModel:self.playTrack];
    
    if (track.hisProgress.doubleValue > 0) {
        hisProgress = track.hisProgress;
        self.playTrack.hisProgress = track.hisProgress;
    }
    
    [self.playTbView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    //延长锁屏播放界面的显示时间，确保图片已经加载完成
    [self performSelector:@selector(setLockScreenInfo) withObject:nil afterDelay:2.0];
}

/**
 * @函数名称：setLockScreenInfo
 * @修改:yinlinlin@duotin.com
 * @函数描述：当切换曲目时更新锁屏显示的图片和内容
 * @输入参数：(UIImage *) img andTitle : (NSString *) title andArtist : (NSString *) artist：专辑图片，节目名称和自定义显示
 * @输出参数：根据传进来的数据对界面进行重新调整显示
 * @返回值：void
 */
- (void)setLockScreenInfo
{
    AppDelegate * appDe = appDelegate;
    //移除之前的
    [appDe.PlayingInfoCenter removeAllObjects];
    
    NSString *lockContent;
    if (IS_IPHONE_5) {
        lockContent = [NSString stringWithFormat:@"\n\n\n\n "];
    } else{
        lockContent = [NSString stringWithFormat:@"\n\n\n\n%@ - %@", self.playTrack.album.title, self.playTrack.title];
    }
    //锁屏显示的节目名称
    [appDe.PlayingInfoCenter setSafeObject:lockContent forKey:MPMediaItemPropertyTitle];
    
    
    //锁屏专辑名称
    if (IS_IPHONE_5) {
        lockContent = [NSString stringWithFormat:@"%@ - %@", self.playTrack.album.title, self.playTrack.title];
        [appDe.PlayingInfoCenter setSafeObject:lockContent forKey:MPMediaItemPropertyAlbumTitle];
    } else {
        if (IS_IOS_7) {
            lockContent = [NSString stringWithFormat:@"%@ - %@", self.playTrack.album.title, self.playTrack.title];
            [appDe.PlayingInfoCenter setSafeObject:lockContent forKey:MPMediaItemPropertyAlbumTitle];
        } else {
            [appDe.PlayingInfoCenter setSafeObject:self.playTrack.album.title forKey:MPMediaItemPropertyAlbumTitle];
        }
    }
    
    //锁屏图片
    UIImageView *imageView = [[UIImageView alloc]init];
    
    if (self.playTrack.album.image_url) {
        [imageView setImageWithURL:[NSURL URLWithString:self.playTrack.album.image_url] placeholderImage:[UIImage imageNamed:@"main_otherplace"]];
        //锁屏显示的其他内容
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:imageView.image];
        
        [appDe.PlayingInfoCenter setSafeObject:albumArt forKey:MPMediaItemPropertyArtwork];
    }
 
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:appDe.PlayingInfoCenter];
}


- (IBAction)nextAction:(id)sender {
    self.playIndex ++;
    if (self.playIndex > self.playMuArray.count - 1) {
        self.playIndex = self.playMuArray.count - 1 ;
    }
    self.playTrack = [self.playMuArray objectAtIndex:self.playIndex];
    [self playMusic];
}

- (IBAction)timeBtnAction:(id)sender {
    DTTimingViewController *timeVC = [[DTTimingViewController alloc] initWithNibName:@"DTTimingViewController" bundle:nil];
    timeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:timeVC animated:YES];
}

- (IBAction)downBtnAction:(id)sender {
    [[DownList sharedManager] saveContent:self.playTrack];
    [SVProgressHUD showSuccessWithStatus:@"已加入下载列表"];
    [[DownloadService sharedDownloadService] addDownloadQueueWithTrack:self.playTrack autoStart:YES];
}

#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playMuArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MainCellIdentifier = @"playViewCell";
    
    PlayCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellIdentifier];
    if (!cell) {
        cell = (PlayCell *)CREAT_XIB(@"PlayCell");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    TrackItem *track = [self.playMuArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = track.title;
    if (track.track_id.integerValue == self.playTrack.track_id.integerValue) {
        cell.titleLabel.textColor = CustomColor;
    }else{
        cell.titleLabel.textColor = NavTitleColor;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackItem *track = [self.playMuArray objectAtIndex:indexPath.row];
    self.playTrack = track;
    [self playMusic];
}



@end

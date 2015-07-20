//
//  DownloadService.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/23.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "DownloadService.h"
#import "Header.h"
#import "UIAlertView+Blocks.h"
#import "DownList.h"
#import "Header.h"
#import "AFDownloadRequestOperation.h"
#import "SCNetworkReachability.h"
#import "NSMutableDictionary+SafeValue.h"

#define kUnkown     @"unkown"
#define MAX_DOWNLOAD_COUNT  500

@implementation DownloadService
{
    BOOL _3GTipsAlert;
    UIAlertView *_warningAlertView;
    NSMutableDictionary *_downloadFailQueue;
}

NSString *const kNotificationDownloadStart = @"kNotificationDownloadStart";             //下载开始
NSString *const kNotificationDownloadFinish = @"kNotificationDownloadFinish";           //下载一首结束
NSString *const kNotificationAllDownloadComplete = @"kNotificationAllDownloadComplete";     //全部下载完成
NSString *const kNotificationDownlaadUpdate = @"kNotificationDownlaadUpdate";          //下载池 数量等有变化

SINGLETON_CLASS(DownloadService);

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.downloadQueue = [NSMutableArray arrayWithCapacity:0];
        self.downloadOperation = [NSMutableDictionary dictionaryWithCapacity:0];
        _downloadFailQueue = [NSMutableDictionary dictionaryWithCapacity:0];
        
        _downloadServiceDispathQueue = dispatch_queue_create("com.duotin.downloadservicequeue", DISPATCH_QUEUE_SERIAL);
        self.curDownloading = nil;
        self.downState = DownloadStateDefault;
        self.preDownState = DownloadStateDefault;
        
        [self startGetUndownloadTrackAfterAppLaunch];
        [NetService sharedNetService].netChangedBlk = ^(PBJNetworkStatus oldStatus, PBJNetworkStatus newStatus) {
            [self networkTranstionWithOldStatus:oldStatus newStatus:newStatus];
        };
    }
    
    return self;
}

//以下用来测试
- (void)networkTranstionWithOldStatus:(PBJNetworkStatus)oldStatus newStatus:(PBJNetworkStatus)newStatus
{
    switch (oldStatus) {
        case PBJNetworkStatusNoNetwork:{
            
            switch (newStatus) {
                    
                case PBJNetworkStatusWifi:{
                    //从 无网=>Wifi
                    NSLog(@"~~~~~~~~~~~~~~~~~~~~~无网=>Wifi");
                    if (self.preDownState == DownloadStateNormal) {
                        [self resumeAllForce:YES];
                    }
                }
                    break;
                    
                case PBJNetworkStatus3G:{
                    //从 无网=>3G   这里的实现比较挫，需要解决
                    NSLog(@"~~~~~~~~~~~~~~~~~~~~~无网=>3G");
                    if (self.preDownState == DownloadStateNormal) {
                        
                        if ([self.downloadQueue count]) {
                            if (!_3GTipsAlert) {
                                if (_warningAlertView) {
                                    return;
                                }
                                _warningAlertView = [UIAlertView showWithTitle:@"温馨提示"
                                                                       message:@"在3G-GPRS环境下下载会消耗您的流量，确定要继续下载吗？"
                                                             cancelButtonTitle:@"取消"
                                                             otherButtonTitles:@[@"继续"]
                                                                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                                          if (buttonIndex == [alertView cancelButtonIndex]) {
                                                                              
                                                                              _3GTipsAlert = NO;
                                                                          } else {
                                                                              _3GTipsAlert = YES;
                                                                              [self resumeAllForce:YES];
                                                                          }
                                                                          _warningAlertView = nil;
                                                                      }];
                                
                            } else {
                                [self resumeAllForce:YES];
                            }
                        }
                    }
                }
                    break;
                    
                case PBJNetworkStatusNoNetwork:
                case PBJNetworkStatusNoNetwork3G:
                    break;
                default:
                    break;
            }
        }
            break;
            
        case PBJNetworkStatusNoNetwork3G:{
            
            switch (newStatus) {
                    
                case PBJNetworkStatus3G:{
                    //从 无网3G => 3G
                    NSLog(@"~~~~~~~~~~~~~~~~~~~~~无网3G => 3G");
                    
                    if (self.preDownState == DownloadStateNormal) {
                        
                        if ([self.downloadQueue count]) {
                            if (!_3GTipsAlert) {
                                if (_warningAlertView) {
                                    return;
                                }
                                _warningAlertView = [UIAlertView showWithTitle:@"温馨提示"
                                                                       message:@"在3G或GPRS环境下下载会消耗您的流量，确定要继续下载吗？"
                                                             cancelButtonTitle:@"取消"
                                                             otherButtonTitles:@[@"继续"]
                                                                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                                          if (buttonIndex == [alertView cancelButtonIndex]) {
                                                                              
                                                                              _3GTipsAlert = NO;
                                                                          } else {
                                                                              _3GTipsAlert = YES;
                                                                              [self resumeAllForce:YES];
                                                                          }
                                                                          _warningAlertView = nil;
                                                                      }];
                                
                            } else {
                                [self resumeAllForce:YES];
                            }
                            
                        }
                        
                    }
                }
                    break;
                    
                case PBJNetworkStatusWifi:{
                    //从 无网3G => Wifi
                    NSLog(@"~~~~~~~~~~~~~~~~~~~~~无网3G => Wifi");
                    
                    if (self.preDownState == DownloadStateNormal) {
                        [self resumeAllForce:YES];
                    }
                }
                    break;
                    
                case PBJNetworkStatusNoNetwork:
                case PBJNetworkStatusNoNetwork3G:
                default:
                    break;
            }
        }
            
            break;
            
        case PBJNetworkStatus3G:{
            switch (newStatus) {
                case PBJNetworkStatusNoNetwork:{
                    //从 3G => 无网
                    NSLog(@"~~~~~~~~~~~~~~~~~~~~~3G => 无网");
                    
                    if (self.downState == DownloadStateNormal) {
                        [self pauseAllAuto:YES];
                    }
                }
                    break;
                case PBJNetworkStatusNoNetwork3G:{
                    // 3G => 无网3G
                    NSLog(@"~~~~~~~~~~~~~~~~~~~~~3G => 无网3G");
                    if (self.downState == DownloadStateNormal) {
                        [self pauseAllAuto:YES];
                    }
                }
                    break;
                    
                case PBJNetworkStatusWifi:
                case PBJNetworkStatus3G:
                default:
                    break;
            }
        }
            
            break;
            
        case PBJNetworkStatusWifi:{
            switch (newStatus) {
                case PBJNetworkStatusNoNetwork:{
                    // Wifi => 无网
                    NSLog(@"~~~~~~~~~~~~~~~~~~~~~Wifi => 无网");
                    
                    if (self.downState == DownloadStateNormal) {
                        [self pauseAllAuto:YES];
                    }
                }
                    break;
                case PBJNetworkStatusNoNetwork3G:{
                    // Wifi => 无网3G
                    NSLog(@"~~~~~~~~~~~~~~~~~~~~~Wifi => 无网3G");
                    if (self.downState == DownloadStateNormal) {
                        [self pauseAllAuto:YES];
                    }
                }
                    break;
                    
                case PBJNetworkStatus3G:
                case PBJNetworkStatusWifi:
                default:
                    break;
            }
        }
            
            break;
            
        default:
            break;
    }
}

- (void)networkChanged:(id)noti
{
    NSLog(@"networkChanged:%@", noti);
}

- (NSString *)downloadPath
{
    return @"Downloaded";
}

/* WIFISWITCH 为自动缓存的key*/
- (void)startGetUndownloadTrackAfterAppLaunch
{
    NSMutableArray *undownloadTrackArr = [NSMutableArray arrayWithArray:[[DownList sharedManager] getDowningData]
                                          ];
    [self addDownloadQueueWithTracks:undownloadTrackArr autoStart:NO];
            //自动缓存按钮 开启 状态:  wifi直接下载  非wifi，不提醒也不下载
    [[NetService sharedNetService] reachablityStatus:^(int netStatus) {
        switch (netStatus) {
            case SCNetworkStatusReachableViaWiFi:{
                [self start];
            }
                break;
            case SCNetworkStatusReachableViaCellular:
                
                break;
                
            default:
                break;
        }
    } fail:nil];
}

- (void)addDownloadQueueWithTracks:(NSArray *)trackArr autoStart:(BOOL)isAutoStart
{
    [trackArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addDownloadQueueWithTrack:obj autoStart:isAutoStart];
    }];
}

- (void)addDownloadQueueWithTrack:(TrackItem *)track
{
    [self addDownloadQueueWithTrack:track autoStart:YES];
}

- (void)addDownloadQueueWithTrack:(TrackItem *)track autoStart:(BOOL)isAutoStart
{
    __block BOOL isExist = NO;
    [self.downloadQueue enumerateObjectsUsingBlock:^(NSDictionary *trackDict, NSUInteger idx, BOOL *stop) {
        TrackItem *tk = [[trackDict allValues] firstObject];
        if ([tk.track_id integerValue] == [track.track_id integerValue]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    
    if (!isExist) {
        NSDictionary *tkDict = @{[self fileKeyWithDetail:track]: track};
        [self.downloadQueue addObject:tkDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownlaadUpdate object:nil userInfo:nil];
        });
    }
    [self updateDownloadingNumber];
    if (isAutoStart) {
        [self start];
    }
}

- (void)updateDownloadingNumber
{
    if (self.downNumberBlock) {
        self.downNumberBlock([self.downloadQueue count]);
    }
}

- (void)addDownloadQueueNoAutoStartWithTrack:(TrackItem *)track
{
    [self addDownloadQueueWithTrack:track autoStart:NO];
}

- (NSString *)fileKeyWithDetail:(TrackItem *)track
{
    /*
     NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:track.play_mp3_url_32]];
     NSString *extensionStr = [req.URL pathExtension];
     NSString *fileTitle = [NSString stringWithFormat:@"%@%@.%@",track.title, track.track_id,extensionStr];
     */
    //为了和以前的风格兼容，所以存成下面的样子  2.1.5版本之后 下载时要加后缀
    
    NSString *extensionStr = nil;
    if ([track.play_mp3_url_32 pathExtension] && ![[track.play_mp3_url_32 pathExtension] isEqualToString:@""]) {
        extensionStr = [track.play_mp3_url_32 pathExtension];
    }
    
    NSString *fileTitle = !extensionStr ? [NSString stringWithFormat:@"%@",track.track_id] : [NSString stringWithFormat:@"%@.%@", track.track_id, extensionStr];
    
    return fileTitle;
}

- (void)checkDownload
{
    [[NetService sharedNetService] reachablityStatus:^(int sucNetStatus) {
        if (sucNetStatus == SCNetworkStatusReachableViaWiFi) {
            //wifi 直接下载
            [self startDownload];
        } else if (sucNetStatus == SCNetworkStatusReachableViaCellular) {
            //3G  需要弹一次框进行二次确认
            [self GPRSDownload];
        }
    } fail:nil];
}

- (void)GPRSDownload
{
    if ([self.downloadQueue count]) {
        if (!_3GTipsAlert) {
            NSLog(@"_warningAlertView1 = %@", _warningAlertView);
            if (_warningAlertView) {
                return ;
            }
            _warningAlertView = [UIAlertView showWithTitle:@"温馨提示"
                                                   message:@"在3G/GPRS环境下下载会消耗您的流量，确定要继续下载吗？"
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@[@"继续"]
                                                  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                      if (buttonIndex == [alertView cancelButtonIndex]) {
                                                          self.isDownloading = NO;
                                                          
                                                          self.downState = DownloadStateDefault;
                                                          self.preDownState = self.downState;
                                                          _3GTipsAlert = NO;
                                                      } else {
                                                          _3GTipsAlert = YES;
                                                          [self startDownload];
                                                      }
                                                      _warningAlertView = nil;
                                                  }];
            NSLog(@"_warningAlertView2 = %@", _warningAlertView);
            
        } else {
            [self startDownload];
        }
    } else {
        [self updateDownloadingNumber];
    }
}

- (void)start
{
    if (!self.isDownloading) {
        [self checkDownload];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadStart object:nil];
        });
    }
}

- (void)startDownload
{
    dispatch_async(_downloadServiceDispathQueue, ^{
        
        if ([self.downloadQueue count]) {
            NSDictionary *trackDict = [self.downloadQueue firstObject];
            
            if ([self.curDownloading isEqual:trackDict]) {
                return ;
            }
            
            self.isDownloading = YES;
            self.preDownState = self.downState;
            self.downState = DownloadStateNormal;
            
            if (trackDict) {
                TrackItem *track = [[trackDict allValues] firstObject];
                
                self.curDownloading = trackDict;
                
                //TODO:修改track的数据库状态  begin 目前看不需要改
                [[DownList sharedManager] mergeWithContent:track];
                
                [self startDownload:track process:^(long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
                    if (self.progressNumBlock) {
                        self.progressNumBlock(track, totalBytesReadForFile, totalBytesExpectedToReadForFile);
                    }
                } complete:^(id sucTrack) {
                    //TODO:修改track的数据库状态  done
                    //                    NSLog(@"下载成功：sucTrack = %@", sucTrack);
                    track.downStatus = @"done";
                    [[DownList sharedManager] mergeWithContent:track];
                    
                    if ([self.downloadQueue containsObject:trackDict]) {
                        [self.downloadQueue removeObject:trackDict];
                    }
                    
                    
                    NSString *tkSucKey = [NSString stringWithFormat:@"%@", track.track_id];
                    NSNumber *tkSucCount = [_downloadFailQueue objectForKeySafely:tkSucKey];
                    NSLog(@"_downloadFailQueue 成功:%@", _downloadFailQueue);
                    if (tkSucCount) {
                        [_downloadFailQueue removeObjectForKey:tkSucKey];
                    }
                    
                    self.curDownloading = nil;
                    
                    [self checkDownload];
                    
                    [self nofiSuccess:track];
                    
                } fail:^(id failTrack) {
                    
                    //TODO:修改track的数据库状态  no
                    //                    NSLog(@"下载失败：failTrack = %@", failTrack);
                    track.downStatus = @"no";
                    [[DownList sharedManager] mergeWithContent:track];
                    
                    NSString *tkFailKey = [NSString stringWithFormat:@"%@", track.track_id];
                    NSNumber *tkFailCount = [_downloadFailQueue objectForKeySafely:tkFailKey];
                    NSLog(@"_downloadFailQueue 失败:%@", _downloadFailQueue);
                    if (!tkFailCount || [tkFailCount intValue] < MAX_DOWNLOAD_COUNT) {
                        [_downloadFailQueue setSafeObject:@([tkFailCount intValue] + 1) forKey:tkFailKey];
                    } else {
                        [_downloadFailQueue removeObjectForKey:tkFailKey];
                        
                        /*下载失败之后不移除 不断重新下载  试试看看效果*/
                        if ([self.downloadQueue containsObject:trackDict]) {
                            [self.downloadQueue removeObject:trackDict];
                        }
                    }
                    
                    
                    self.curDownloading = nil;
                    
                    [self checkDownload];
                    
                    [self nofiSuccess:track];
                    
                }];
                
            }
            
        } else {
            [self resetToDefaultDownloadState];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAllDownloadComplete object:nil];
            });
        }
        
        [self updateDownloadingNumber];
    });
}

- (void)resetToDefaultDownloadState
{
    self.isDownloading = NO;
    self.preDownState = self.downState;
    self.downState = DownloadStateDefault;
    self.curDownloading = nil;
    _3GTipsAlert = NO;
}

- (void)startDownload:(TrackItem *)track
              process:(void (^)(long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile))processBlock
             complete:(void (^)(id))completeBlk
                 fail:(void (^)(id))failBlk
{
    NSString *fileName = [self fileKeyWithDetail:track];
    
    NSString *mp3URLStr = [track.play_mp3_url_32 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFDownloadRequestOperation *op = [[AFDownloadRequestOperation alloc] initWithRequestURLString:mp3URLStr file:fileName shouldResume:YES];
    
    [op setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        
        if (processBlock) {
            processBlock(totalBytesReadForFile, totalBytesExpectedToReadForFile);
        }
        
//        if ([track.file_size isKindOfClass:[NSNull class]] || ![track.file_size boolValue]) {
//            track.file_size = @(totalBytesExpectedToReadForFile);
//        }
        
    }];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.downloadOperation removeObjectForKey:fileName];
        if (completeBlk) {
            completeBlk(track);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.downloadOperation removeObjectForKey:fileName];
        if (error.code == 516) {
            if (completeBlk) {
                completeBlk(track);
            }
        } else {
            if (failBlk) {
                failBlk(track);
            }
        }
    }];
    
    op.deleteTempFileOnCancel = YES;
    [self.downloadOperation setObject:op forKey:fileName];
    
    [op start];
}

/**
 *  一个节目下载完成之后发出的通知
 *
 *  @param track
 */
- (void)nofiSuccess:(TrackItem *)track
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadFinish object:track userInfo:nil];
    });
}

- (void)pauseAll
{
    [self pauseAllAuto:NO];
}

- (void)pauseAllAuto:(BOOL)isAutoPause
{
    [self.downloadQueue enumerateObjectsUsingBlock:^(NSDictionary *trackDict, NSUInteger idx, BOOL *stop) {
        TrackItem *tk = [[trackDict allValues] firstObject];
        [self pauseTrack:tk];
    }];
    if (isAutoPause) {
        self.preDownState = self.downState;
    }
    self.downState = DownloadStatePause;
    
    if (!isAutoPause) {
        self.preDownState = self.downState;
    }
}

- (void)pauseTrack:(id)track
{
    NSString *fileName = [self fileKeyWithDetail:track];
    
    AFDownloadRequestOperation *op = [self.downloadOperation objectForKey:fileName];
    
    if (op) {
        [op pause];
    }
}

- (void)resumeAll
{
    [self resumeAllForce:NO];
}

- (void)resumeAllForce:(BOOL)isForceResume
{
    __block AFDownloadRequestOperation *targetOp = nil;
    __block NSString *opKey = nil;
    [self.downloadQueue enumerateObjectsUsingBlock:^(NSDictionary *trackDict, NSUInteger idx, BOOL *stop) {
        TrackItem *track = [[trackDict allValues] firstObject];
        
        NSString *fileName = [self fileKeyWithDetail:track];
        
        AFDownloadRequestOperation *op = [self.downloadOperation objectForKey:fileName];
        
        if (op) {
            targetOp = op;
            opKey = fileName;
            *stop = YES;
        }
    }];
    
    if (targetOp) {
        
        [[NetService sharedNetService] reachablityStatus:^(int sucNetStatus) {
            if (sucNetStatus == SCNetworkStatusReachableViaWiFi) {
                //wifi 直接下载
                [targetOp resume];
                self.downState = DownloadStateNormal;
                self.preDownState = self.downState;
            } else if (sucNetStatus == SCNetworkStatusReachableViaCellular) {
                //3G  需要弹一次框进行二次确认
                
                if (!_3GTipsAlert) {
                    if (_warningAlertView) {
                        return;
                    }
                    _warningAlertView = [UIAlertView showWithTitle:@"温馨提示"
                                                           message:@"在3G环境下下载会消耗您的流量，确定要继续下载吗？"
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@[@"继续"]
                                                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                              
                                                              if (buttonIndex == [alertView cancelButtonIndex]) {
                                                                  
                                                                  _3GTipsAlert = NO;
                                                              } else {
                                                                  _3GTipsAlert = YES;
                                                                  [targetOp resume];
                                                                  self.downState = DownloadStateNormal;
                                                              }
                                                              self.preDownState = self.downState;
                                                              _warningAlertView = nil;
                                                          }];
                    
                } else {
                    [targetOp resume];
                    self.downState = DownloadStateNormal;
                    self.preDownState = self.downState;
                }
                
            }
        } fail:nil];
        
    } else {
        if (isForceResume) {
            [self checkDownload];
        }
        
    }
    
    //    self.downState = DownloadStateNormal;
}

- (void)resumeTrack:(TrackItem *)track
{
    NSString *fileName = [self fileKeyWithDetail:track];
    
    AFDownloadRequestOperation *op = [self.downloadOperation objectForKey:fileName];
    
    if (op) {
        [op resume];
    }
}

- (void)cancelAll
{
    if (self.downloadOperation) {
        [self.downloadOperation enumerateKeysAndObjectsUsingBlock:^(id key, AFDownloadRequestOperation *op, BOOL *stop) {
            [op cancel];
        }];
        [self.downloadOperation removeAllObjects];
    }
    
    if (self.downloadQueue) {
        [self.downloadQueue removeAllObjects];
    }
    
    
    self.downState = DownloadStateDefault;
    self.preDownState = self.downState;
}

- (void)cancel:(TrackItem *)track
{
    NSString *fileName = [self fileKeyWithDetail:track];
    
    AFDownloadRequestOperation *op = [self.downloadOperation objectForKey:fileName];
    
    if (op) {
        [op cancel];
        [self.downloadOperation removeObjectForKey:fileName];
    }
    
    [self.downloadQueue enumerateObjectsUsingBlock:^(NSDictionary *tkDict, NSUInteger idx, BOOL *stop) {
        TrackItem *targetTrack = [[tkDict allValues] firstObject];
        if ([targetTrack.track_id integerValue] == [track.track_id integerValue]) {
            [self.downloadQueue removeObject:tkDict];
            *stop = YES;
        }
    }];
    if ([self.downloadQueue count] == 0) {
        [self resetToDefaultDownloadState];
    }
    
    [self updateDownloadingNumber];
}




@end

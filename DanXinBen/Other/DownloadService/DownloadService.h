//
//  DownloadService.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/23.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackItem.h"

typedef void(^DownloadCompletionBlock)(void);
typedef void(^DownloadingProgressBlock)(id downloadingTrack,long long downloadedBytes, long long totalBytesOfFile);
typedef void(^DownloadingNumberBlock)(NSInteger);

typedef NS_ENUM(NSUInteger, DownloadState) {
    DownloadStateDefault = 1,   //没有下载
    DownloadStateNormal ,       //正常下载
    DownloadStatePause,         //暂停
};

extern NSString *const kNotificationDownloadStart;
extern NSString *const kNotificationDownloadFinish;
extern NSString *const kNotificationAllDownloadComplete;
extern NSString *const kNotificationDownlaadUpdate;

@interface DownloadService : NSObject
{
    dispatch_queue_t _downloadServiceDispathQueue;
}

@property (nonatomic, strong) NSMutableArray *downloadQueue;    //下载池
@property (nonatomic, strong) NSMutableDictionary *downloadOperation; //用来存放各个下载的operation(完成移除)
@property (nonatomic, strong) id curDownloading;    //当前正在下载的
@property (nonatomic, assign) BOOL isDownloading;   //是否正在下载
@property (nonatomic, copy) DownloadCompletionBlock completionBlock;
@property (nonatomic, copy) DownloadingProgressBlock progressNumBlock;
@property (nonatomic, assign) DownloadState downState;
@property (nonatomic, assign) DownloadState preDownState;
@property (nonatomic, copy) DownloadingNumberBlock downNumberBlock;

+ (instancetype)sharedDownloadService;

/**
 *  app启动时，检测是否上次有下载没有完成的，进行相关的下载操作
 */
- (void)startGetUndownloadTrackAfterAppLaunch;

/**
 *  添加track到下载池下载
 *
 *  @param track
 */
- (void)addDownloadQueueWithTrack:(TrackItem *)track;

/**
 *  添加track数组到下载
 *
 *  @param trackArr
 */
- (void)addDownloadQueueWithTracks:(NSArray *)trackArr autoStart:(BOOL)isAutoStart;

/**
 *  添加track到下载
 *
 *  @param track       track
 *  @param isAutoStart 是否自动下载
 */
- (void)addDownloadQueueWithTrack:(TrackItem *)track autoStart:(BOOL)isAutoStart;

/**
 *  添加到下载 不自动下载
 *
 *  @param track
 */
- (void)addDownloadQueueNoAutoStartWithTrack:(TrackItem *)track;

/**
 *  开始下载， 一般是手动点击开始按钮时触发
 */
- (void)start;

/**
 *  暂停所有下载
 */
- (void)pauseAll;

/**
 *  暂停下载
 *
 *  @param isAutoPause 判断是否是自动暂停，还是手动暂停  自动暂停：YES 手动暂停：NO
 */
- (void)pauseAllAuto:(BOOL)isAutoPause;

/**
 *  恢复所有下载
 */
- (void)resumeAll;

/**
 *  恢复所有下载  这种情况是用来防范 如果暂停之后，网络又断了 再次连接时可能找不到需要resume的对象，所以需要强制resume
 *
 *  @param isForceResume 是否强制恢复
 */
- (void)resumeAllForce:(BOOL)isForceResume;

/**
 *  暂定某个节目
 *
 *  @param track
 */
- (void)pauseTrack:(id)track;

/**
 *  恢复某个节目
 *
 *  @param track
 */
- (void)resumeTrack:(TrackItem *)track;

/**
 *  清除掉所有下载内容
 */
- (void)cancelAll;

/**
 *  取消某个track的下载
 *
 *  @param track
 */
- (void)cancel:(TrackItem *)track;



@end

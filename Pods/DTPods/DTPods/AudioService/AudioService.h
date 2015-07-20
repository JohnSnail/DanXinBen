//
//  AudioManager.h
//  duotin2.0
//
//  Created by Vienta on 14-10-8.
//  Copyright (c) 2014年 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORGMEngine.h"
#import <AVFoundation/AVFoundation.h>
#import "DTPodsHeader.h"


typedef NS_ENUM(NSUInteger, AudioPlayState) {
    AudioPlayStateStopped,
    AudioPlayStatePlaying,
    AudioPlayStatePaused,
    AudioPlayStateError,
};

typedef NSURL *(^CurrentAudioPlayCompleteWillPlayNextBlk)(id);
typedef void (^CurrentAudioPlayCompleteBlk)(void);
typedef void (^CurrentAudioPlayStateBlk)(AudioPlayState playState);
typedef void (^AudioMaxAndMiniPlayTimeBlk)(NSNumber *miniPlayTime, NSNumber *maxPlayTime);
typedef void (^CurrentAudioPlayProgressBlk) (NSString *progressStr);
typedef void (^AudioPlayPrebufferProgressBlk) (float prebufferProgress);

@interface AudioService : NSObject<ORGMEngineDelegate,AVAudioSessionDelegate>

@property (strong, nonatomic) ORGMEngine *audioPlayer;
@property (copy, nonatomic) CurrentAudioPlayCompleteWillPlayNextBlk curAudioCompleteWillPlayNextBlk;//当前节目播放完毕并准备播放下一个
@property (copy, nonatomic) CurrentAudioPlayCompleteBlk curAudioPlayComplteBlk;//当前节目播放完毕
@property (copy, nonatomic) CurrentAudioPlayStateBlk curAudioStateBlk;//当前播放状态
@property (copy, nonatomic) AudioMaxAndMiniPlayTimeBlk audioMaxAndMiniPlayTimeBlk;//播放该音频的最大 最小值 指的是音频的长度
@property (copy, nonatomic) CurrentAudioPlayProgressBlk curAudioProgressBlk;//当前播放长度/总长度，不断的更新
@property (copy, nonatomic) AudioPlayPrebufferProgressBlk curAudioPlayPrebufferProgressBlk;//预加载的进度

@property (readonly, nonatomic) AudioPlayState currentPlayState;

+ (instancetype)sharedAudioService;

- (void)play:(id)trackURLStr;

- (void)pause;

- (void)resume;

- (void)stop;

/**
 *
 *  @return 是否为耳机状态
 */
- (BOOL)isHeadiPhone;

/**
 *  @return 节目总时长 （已格式化成字符串）
 */
- (NSString *)trackTimeStr;

/**
 *  @return 节目已经播放的时长 （已格式化成字符串）
 */
- (NSString *)amoutPlayedTimeStr;

/**
 *  @return 当前播放的 metadata
 */
- (NSDictionary *)metadata;

/**
 *  总时长
 */
- (double)trackTime;

/**
 *
 *  @return 播放过的地方
 */
- (double)amoutPlayedTime;

/**
 *  从指定时间开始播放
 *
 *  @param time 指定的时间
 */
- (void)seekToTime:(double)time;

/**
 *  删掉预加载的缓存
 */
- (void)clearPrebufferCache;

/**
 *  缓存路径
 *
 *  @return 路径
 */
- (NSString *)prebufferCacheFolderPath;

/**
 *  维持最上限缓存量
 *
 *  @param uplimitBytes 上限缓存
 *  @param completeBlk  完成
 */
- (void)maintainUplimitCacheWithUplimit:(NSNumber *)uplimitBytes;


@end

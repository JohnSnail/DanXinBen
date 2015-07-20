//
//  AudioManager.m
//  duotin2.0
//
//  Created by Vienta on 14-10-8.
//  Copyright (c) 2014年 Duotin Network Technology Co.,LTD. All rights reserved.
//




#import "AudioService.h"
#import "ORGMCommonProtocols.h"

@interface PathWithModDate : NSObject

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSDate *creatDate;

@end

@implementation PathWithModDate

@end

@implementation AudioService
{
    NSTimer *_refreshScheduleTimer;
}

SINGLETON_CLASS(AudioService);

- (id)init
{
    if (self = [super init]) {
        self.audioPlayer = [[ORGMEngine alloc] init];
        self.audioPlayer.volume = 1.0;
        self.audioPlayer.delegate = (id)self;
        _refreshScheduleTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(refreshSchedule:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_refreshScheduleTimer forMode:NSRunLoopCommonModes];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prebuffer:) name:kPrebufferProgress object:nil];

        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setDelegate:self];
        AudioSessionInitialize(NULL, NULL, NULL, NULL);
        AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeCallback, (__bridge void *)(self));
    }
    return self;
}

void audioRouteChangeCallback(void *inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData)
{
    SInt32 routeChangeReason;
    CFDictionaryRef routeChangeDictionary = inData;
    CFNumberRef routeChangeReasonRef = CFDictionaryGetValue(routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
    
    CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
    
    if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {  //拔掉
        [[AudioService sharedAudioService] pause];
    }
}

- (void)dealloc
{
    self.audioPlayer.delegate = nil;
    [_refreshScheduleTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPrebufferProgress object:nil];
}

- (void)prebuffer:(NSNotification *)noti
{
    float prebufferPgs = [noti.object floatValue];
    if (self.curAudioPlayPrebufferProgressBlk) {
        self.curAudioPlayPrebufferProgressBlk(prebufferPgs);
    }
}

//不断刷新
- (void)refreshSchedule:(id)sender
{
    if (self.curAudioProgressBlk) {
        NSString *trackTimerStr = nil;
        
        NSString *metadataDuration = [[self metadata] objectForKeySafely:@"approximate duration in seconds"];
        NSNumber *metadataNum = [Util convertToNumberWithString:metadataDuration];
        
        if (metadataNum) {
            trackTimerStr = [Util formatIntoDateWithSecond:metadataNum];
        } else {
            trackTimerStr = [self trackTimeStr];
        }
        
        NSString *pgsStr = [NSString stringWithFormat:@"%@/%@",[self amoutPlayedTimeStr], trackTimerStr];
        
        if (self.curAudioProgressBlk) {
            self.curAudioProgressBlk(pgsStr);
        }
    }
}

- (AudioPlayState)currentPlayState
{
    AudioPlayState curState;
    switch ([self.audioPlayer currentState]) {
        case ORGMEngineStateError:{
            curState = AudioPlayStateError;
            NSLog(@"~~~~~~~~curentErr");
        }
            break;
        case ORGMEngineStatePaused:
            curState = AudioPlayStatePaused;
            break;
        
        case ORGMEngineStatePlaying:
            curState = AudioPlayStatePlaying;
            break;
            
        case ORGMEngineStateStopped:
            curState = AudioPlayStateStopped;
            
            break;
            
        default:
            break;
    }
    return curState;
}

- (void)play:(id)trackURLStr
{
    NSURL *playURL = nil;
    if ([trackURLStr isKindOfClass:[NSString class]]) {
        playURL = [NSURL URLWithString:trackURLStr];
    } else if ([trackURLStr isKindOfClass:[NSURL class]]) {
        playURL = trackURLStr;
    }
    
    [self.audioPlayer playUrl:playURL];
}

- (void)pause
{
    [self.audioPlayer pause];
}

- (void)resume
{
    [self.audioPlayer resume];
}
- (void)stop
{
    [self.audioPlayer stop];
}

- (BOOL)isHeadiPhone
{
    UInt32 propertySize = sizeof(CFStringRef);
    CFStringRef state   = nil;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute ,&propertySize,&state);

    return ([(__bridge NSString *)state isEqualToString:@"Headphone"] || [(__bridge NSString *)state isEqualToString:@"HeadsetInOut"]);
}

- (NSString *)trackTimeStr
{
    return [Util formatIntoDateWithSecond:[NSNumber numberWithDouble:[self.audioPlayer trackTime]]];
}

- (NSString *)amoutPlayedTimeStr
{
    return [Util formatIntoDateWithSecond:[NSNumber numberWithDouble:[self.audioPlayer amountPlayed]]];
}

- (NSDictionary *)metadata
{
    return [self.audioPlayer metadata];
}

- (double)trackTime
{
    return [self.audioPlayer trackTime];
}

- (double)amoutPlayedTime
{
    return [self.audioPlayer amountPlayed];
}

- (void)seekToTime:(double)time
{
    [self.audioPlayer seekToTime:time];
}

#pragma mark -
#pragma mark ORGMEngineDelegate
//节目播放完成调用的方法
- (NSURL *)engineExpectsNextUrl:(ORGMEngine *)engine
{
    if (self.curAudioPlayComplteBlk) {
        self.curAudioPlayComplteBlk();
    }
    if (self.curAudioCompleteWillPlayNextBlk) {
        return self.curAudioCompleteWillPlayNextBlk(engine);
    } else {
        return nil;
    }
}

//播放状态的改变
- (void)engine:(ORGMEngine *)engine didChangeState:(ORGMEngineState)state
{
    AudioPlayState curState;
    switch (state) {
        case ORGMEngineStateError:
            curState = AudioPlayStateError;
            break;
            
        case ORGMEngineStatePaused:
            curState = AudioPlayStatePaused;
            break;
            
        case ORGMEngineStatePlaying:{
            curState = AudioPlayStatePlaying;
            if (self.audioMaxAndMiniPlayTimeBlk) {
                self.audioMaxAndMiniPlayTimeBlk(nil,@(self.audioPlayer.trackTime));
            }
        }
            break;
            
        case ORGMEngineStateStopped:
        default:{
            curState = AudioPlayStateStopped;
            if (self.audioMaxAndMiniPlayTimeBlk) {
                self.audioMaxAndMiniPlayTimeBlk(@0,nil);
            }
        }
            break;
    }
    if (self.curAudioStateBlk) {
        self.curAudioStateBlk(curState);
    }
}

- (void)clearPrebufferCache
{
    [[NSFileManager defaultManager] removeItemAtPath:[self prebufferCacheFolderPath] error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[self prebufferCacheFolderPath]
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}

- (NSString *)prebufferCacheFolderPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *playCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"DTPrebufferCache"];
    return playCachePath;
}

- (void)maintainUplimitCacheWithUplimit:(NSNumber *)uplimitBytes
{
    if ([Util sizeOfFolder:[self prebufferCacheFolderPath]] >= [uplimitBytes unsignedLongLongValue]) {
        
        NSArray *allPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self prebufferCacheFolderPath] error:nil];
        
        NSMutableArray *sortedAllPaths = [NSMutableArray arrayWithCapacity:0];
        for (NSString *path in allPaths) {
            NSString *fullPath = [[self prebufferCacheFolderPath] stringByAppendingPathComponent:path];
            
            NSDictionary *attrDict = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            NSDate *creatDate = [attrDict objectForKey:NSFileCreationDate];
            
            PathWithModDate *pathWithDate = [[PathWithModDate alloc] init];
            pathWithDate.path = fullPath;
            pathWithDate.creatDate = creatDate;
            [sortedAllPaths addObject:pathWithDate];
        }
        
        [sortedAllPaths sortUsingComparator:^NSComparisonResult(PathWithModDate *path1,PathWithModDate *path2) {
            return [path1.creatDate compare:path2.creatDate];
        }];
        
        [sortedAllPaths enumerateObjectsUsingBlock:^(PathWithModDate *deletePath, NSUInteger idx, BOOL *stop) {
            [[NSFileManager defaultManager] removeItemAtPath:deletePath.path error:nil];
            if ([Util sizeOfFolder:[self prebufferCacheFolderPath]] <= [uplimitBytes unsignedIntegerValue]) {
                *stop = YES;
            }
        }];
    }
}

#pragma mark -
#pragma AVAudioSessionDelegate

static bool interruptedWhilePlaying = NO;

- (void)beginInterruption
{
    NSLog(@"~~~~~~~~~~~~~~~~beginInterruption");
    if ([self currentPlayState] == AudioPlayStatePlaying) {
        interruptedWhilePlaying = YES;
        [self pause];
    }
}

- (void)endInterruption
{
    NSLog(@"~~~~~~~~~~~~~~~~endInterruption");
    if (interruptedWhilePlaying) {
        [[AVAudioSession sharedInstance] setActive:YES error:NULL];
        [self resume];
        interruptedWhilePlaying = NO;
    }
}

@end




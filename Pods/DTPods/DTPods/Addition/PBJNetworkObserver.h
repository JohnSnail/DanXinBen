//
//  PBJNetworkObserver.h
//
//  Created by Patrick Piemonte on 5/24/13.
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PBJNetworkStatus) {
    PBJNetworkStatusUnkown = 0,
    PBJNetworkStatusWifi = 1,       //有网，Wifi环境
    PBJNetworkStatus3G,             //有网，3G环境
    PBJNetworkStatusNoNetwork3G,    //无网，但是有3G  这种情况在app退到后台，切换网络，然后打开可现
    PBJNetworkStatusNoNetwork,      //无网，无wifi，无3G
};

@protocol PBJNetworkObserverProtocol;
@interface PBJNetworkObserver : NSObject
{
}

+ (PBJNetworkObserver *)sharedNetworkObserver;

@property (nonatomic, readonly, getter=isNetworkReachable) BOOL networkReachable;
@property (nonatomic, readonly, getter=isCellularConnection) BOOL cellularConnection;

@property (nonatomic, assign) PBJNetworkStatus networkStatus;

// observers will be notified on network reachability state changes, as defined by SCNetworkReachabilityFlags

- (void)addNetworkReachableObserver:(id<PBJNetworkObserverProtocol>)observer;
- (void)removeNetworkReachableObserver:(id<PBJNetworkObserverProtocol>)observer;

@end

@protocol PBJNetworkObserverProtocol <NSObject>
@required
- (void)networkObserverReachabilityDidChange:(PBJNetworkObserver *)networkObserver;
@end

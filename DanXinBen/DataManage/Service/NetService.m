//
//  NetService.m
//  duotin2.0
//
//  Created by Vienta on 4/16/14.
//  Copyright (c) 2014 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import "NetService.h"
#import "AFJSONRequestOperation.h"
#import "SCNetworkReachability.h"
#import "AppConstant.h"

@implementation NetService

+ (instancetype)sharedNetService
{
    static NetService *_sharedNetService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedNetService = [[NetService alloc] initWithBaseURL:[NSURL URLWithString:API_HOST]];
        [[PBJNetworkObserver sharedNetworkObserver] addNetworkReachableObserver:_sharedNetService];
        [[PBJNetworkObserver sharedNetworkObserver] addObserver:_sharedNetService forKeyPath:@"networkStatus" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    });
    return _sharedNetService;
}

static dispatch_queue_t duotin_network_queue() {
    static dispatch_once_t queueCreationGuard;
    static dispatch_queue_t queue;
    dispatch_once(&queueCreationGuard, ^{
        queue = dispatch_queue_create("com.duotin.networkqueue", 0);
    });
    return queue;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    PBJNetworkStatus oldNetStatus = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
    PBJNetworkStatus newNetStatus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
    
    if (self.netChangedBlk) {
        self.currentNetworkStatus = newNetStatus;
        self.netChangedBlk(oldNetStatus, newNetStatus);
    }
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Content-Type" value:@"application/json"];
    //;charset=UTF-8
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/javascript", nil]];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    if ([[url scheme] isEqualToString:@"https"] && [[url host] isEqualToString:@"alpha-api.app.net"]) {
        self.defaultSSLPinningMode = AFSSLPinningModePublicKey;
    } else {
        self.defaultSSLPinningMode = AFSSLPinningModeNone;
    }
    
    return self;
}

- (void)networkObserverReachabilityDidChange:(PBJNetworkObserver *)networkObserver
{
//    BOOL isNetworkReachable = [networkObserver isNetworkReachable];
//    BOOL isCellularConnection = [networkObserver isCellularConnection];
//    NSLog(@"network status changed reachable (%d),  cellular (%d)", isNetworkReachable, isCellularConnection);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetworkChanged object:networkObserver];
    });
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(id sucRes))success
        failure:(void (^) (id failRes))failure
{
        [self reachablityStatus:^(int netStatus) {
            [super getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {

                if ([responseObject[@"error_code"] intValue] == kRequestSuccess) {
                    if (success) {
                        if ([[responseObject allKeys] containsObject:@"success"]){
                            success(responseObject);
                        }else{
                            success(responseObject[@"data"]);
                        }
                    }
                }else {
                    if (failure) {
                        failure(responseObject);
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        } fail:^(int errStatus) {
            if (failure) {
                failure(@(errStatus));
            }
        }];
}

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(id))failure
{
    dispatch_async(duotin_network_queue(), ^{
        [self reachablityStatus:^(int netStatus) {
            
            [super postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                if ([responseObject[@"error_code"] intValue] == kRequestSuccess) {
                    if (success) {
                        success(responseObject[@"data"]);
                    }
                } else {
                    if (failure) {
                        failure(responseObject);
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failure) {
                    failure(error);
                }
                
            }];
        } fail:^(int errStatus) {
            if (failure) {
                failure(@(errStatus));
            }
        }];
    });
}

- (void)reachablityStatus:(void (^)(int))success fail:(void (^) (int))fail
{
    [SCNetworkReachability host:@"www.baidu.com" reachabilityStatus:^(SCNetworkStatus status) {
        switch (status) {
            case SCNetworkStatusReachableViaCellular:{
                if (success) {
                    success(SCNetworkStatusReachableViaCellular);
                }
            }
                break;
            
            case SCNetworkStatusReachableViaWiFi:{
                if (success) {
                    success(SCNetworkStatusReachableViaWiFi);
                }
            }
                break;
                
            case SCNetworkStatusNotReachable:
            default:{
                if (fail) {
                    fail(SCNetworkStatusNotReachable);
                }
            }
                break;
        }
    }];
}

- (void)postImagePath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(id))failure
{
    
}


@end

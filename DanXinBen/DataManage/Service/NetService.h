//
//  NetService.h
//  duotin2.0
//
//  Created by Vienta on 4/16/14.
//  Copyright (c) 2014 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"
#import "PBJNetworkObserver.h"

typedef void(^NetworkChangedBlock)(PBJNetworkStatus oldNetStatus, PBJNetworkStatus newNetStatus);

@interface NetService : AFHTTPClient<PBJNetworkObserverProtocol>



+ (instancetype)sharedNetService;


@property (nonatomic, copy) NetworkChangedBlock netChangedBlk;
@property (nonatomic, assign) PBJNetworkStatus currentNetworkStatus;


- (void)reachablityStatus:(void (^)(int))success fail:(void (^) (int))fail;
/**
 *  Get方法
 *
 *  @param path       url请求路径
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
*/
- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(id sucRes))success
        failure:(void (^)(id failRes))failure;
/**
 *  Post方法
 *
 *  @param path       url请求路径
 *  @param parameters 请求参数
 *  @param success    成功
 *  @param failure    失败
 */
- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(id sucRes))success
         failure:(void (^) (id failure))failure;

/**
 *  上传头像
 *
 *  @param path
 *  @param parameters
 *  @param success
 *  @param failure
 */
- (void)postImagePath:(NSString *)path
           parameters:(NSDictionary *)parameters
              success:(void (^) (id sucRes))success
              failure:(void (^)(id failure))failure;



@end

//
//  NetManager.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/22.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "NetManager.h"
#import "NSMutableDictionary+SafeValue.h"
#import "Header.h"
#import "CommentMethods.h"

#define TimeInterval 30*60*1

@implementation NetManager

SINGLETON_CLASS(NetManager)

-(void)getMainData:(NSNumber *)last_data_id andSub_category_id:(NSNumber *)sub_category_id Success:(successBlock)suc failure:(failureBlock)fail
{
    NSString *cacheKey = [NSString stringWithFormat:@"cacheSubCategory%@",sub_category_id];
    NSString *timeKey = [NSString stringWithFormat:@"timeKey%@",cacheKey];
    
    BOOL flag = [CommentMethods needUpdateCache:timeKey timeInterval:TimeInterval];
    if (!flag && last_data_id.integerValue == 0) { //获取本地数据
        NSDictionary *dict = [CommentMethods getLocalData:cacheKey];
        if (suc && dict) {
            suc(dict);
        }
    }
    
    __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setSafeObject:@"IOS" forKey:@"platform"];
    [params setSafeObject:MOBILE_KEY forKey:@"mobile_key"];
    [params setSafeObject:last_data_id forKey:@"last_data_id"];
    [params setSafeObject:@"2.0.8" forKey:@"version"];
    [params setSafeObject:@"237441FWznzlwEDdzsPOnd5W1uSa" forKey:@"user_key"];
    [params setSafeObject:@(category_id) forKey:@"category_id"];
    [params setSafeObject:sub_category_id forKey:@"sub_category_id"];
    [params setSafeObject:@"0" forKey:@"type"];
    
    [[NetService sharedNetService] getPath:MainRecommendPort parameters:params success:^(id sucRes) {
        if (suc) {
            if (last_data_id.integerValue == 0) {
                [CommentMethods setCacheTime:timeKey];
                [CommentMethods setLocalData:sucRes key:cacheKey];
            }
            suc(sucRes);
        }
    } failure:^(id failRes) {
        if (fail) {
            fail(failRes);
        }
    }];
}

-(void)getAlbumContentDataAlbumId:(NSNumber *)albumID andLastDataOrder:(NSNumber *)last_data_order Success:(successBlock)suc failure:(failureBlock)fail
{
    NSString *cacheKey = [NSString stringWithFormat:@"cacheContent%@",albumID];
    NSString *timeKey = [NSString stringWithFormat:@"timeKey%@",cacheKey];
    
    BOOL flag = [CommentMethods needUpdateCache:timeKey timeInterval:TimeInterval];
    if (!flag && last_data_order.integerValue == 0) { //获取本地数据
        NSDictionary *dict = [CommentMethods getLocalData:cacheKey];
        if (dict) {
            suc(dict);
        }
    }
    
    __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:@(1) forKey:@"is_down"];
    [params setSafeObject:@(0) forKey:@"is_first"];
    [params setSafeObject:last_data_order forKey:@"last_data_order"];
    [params setSafeObject:MOBILE_KEY forKey:@"mobile_key"];
    [params setSafeObject:@"IOS" forKey:@"platform"];
    [params setSafeObject:@(0) forKey:@"sort"];
    [params setSafeObject:@"237441FWznzlwEDdzsPOnd5W1uSa" forKey:@"user_key"];
    [params setSafeObject:@"2.0.8" forKey:@"version"];
    [params setSafeObject:albumID forKey:@"album_id"];
        
    [[NetService sharedNetService] getPath:AlbumContentPort parameters:params success:^(id sucRes) {
        if (suc) {
            if (last_data_order.integerValue == 0) {
                [CommentMethods setLocalData:sucRes key:cacheKey];
                [CommentMethods setCacheTime:timeKey];
            }
            suc(sucRes);
        }
    } failure:^(id failRes) {
        if (fail) {
            fail(failRes);
        }
    }];
}

-(void)getAlbumAllContentDataAlbumId:(NSNumber *)albumID Success:(successBlock)suc failure:(failureBlock)fail
{
    NSString *cacheKey = [NSString stringWithFormat:@"cacheAllContent%@",albumID];
    NSString *timeKey = [NSString stringWithFormat:@"timeKey%@",cacheKey];
    
    BOOL flag = [CommentMethods needUpdateCache:timeKey timeInterval:TimeInterval];
    if (!flag) { //获取本地数据
        NSDictionary *dict = [CommentMethods getLocalData:cacheKey];
        if (dict) {
            suc(dict);
        }
    }
    
    __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:MOBILE_KEY forKey:@"mobile_key"];
    [params setSafeObject:@"IOS" forKey:@"platform"];
    [params setSafeObject:@(0) forKey:@"sort"];
    [params setSafeObject:@"237441FWznzlwEDdzsPOnd5W1uSa" forKey:@"user_key"];
    [params setSafeObject:@"2.0.8" forKey:@"version"];
    [params setSafeObject:albumID forKey:@"album_id"];
    
    [[NetService sharedNetService] getPath:AlbumAllContentPort parameters:params success:^(id sucRes) {
        if (suc) {
            [CommentMethods setLocalData:sucRes key:cacheKey];
            [CommentMethods setCacheTime:timeKey];
            suc(sucRes);
        }
    } failure:^(id failRes) {
        if (fail) {
            fail(failRes);
        }
    }];
    
}


-(void)getMoreAppDataSuccess:(successBlock)suc failure:(failureBlock)fail
{
    NSString *cacheKey = @"cacheMoreApp";
    NSString *timeKey = [NSString stringWithFormat:@"timeKey%@",cacheKey];
    
    BOOL flag = [CommentMethods needUpdateCache:timeKey timeInterval:TimeInterval];
    if (!flag) { //获取本地数据
        NSDictionary *dict = [CommentMethods getLocalData:cacheKey];
        if (dict) {
            suc(dict);
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:@"lifeofpi" forKey:@"sku"];
    
    [[NetService sharedNetService] getPath:MoreAppPort parameters:params success:^(id sucRes) {
        if (suc) {
            [CommentMethods setLocalData:sucRes key:cacheKey];
            [CommentMethods setCacheTime:timeKey];
            suc(sucRes);
        }
    } failure:^(id failRes) {
        if (fail) {
            fail(failRes);
        }
    }];

}

-(void)getSubcategoryTitleSuccess:(void (^) (id))suc failure:(void (^) (id))fail
{
    NSString *cacheKey = @"cacheSubcategoryTitle";
    NSString *timeKey = [NSString stringWithFormat:@"timeKey%@",cacheKey];
    
    BOOL flag = [CommentMethods needUpdateCache:timeKey timeInterval:TimeInterval];
    if (!flag) { //获取本地数据
        NSDictionary *dict = [CommentMethods getLocalData:cacheKey];
        if (dict) {
            suc(dict);
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:@(category_id) forKey:@"category_id"];
    [params setSafeObject:MOBILE_KEY forKey:@"mobile_key"];
    
    [[NetService sharedNetService] getPath:SubTitlePort parameters:params success:^(id sucRes) {
        [CommentMethods setLocalData:sucRes key:cacheKey];
        [CommentMethods setCacheTime:timeKey];
        suc(sucRes);
    } failure:^(id failRes) {
        fail(failRes);
    }];
}

- (void)requestCheckUpdateVersionSuccess:(void (^) (id))suc failure:(void (^) (id))fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:SKU forKey:@"sku"];
    [params setSafeObject:APP_VERSION forKey:@"version"];
    [params setSafeObject:[NSNumber numberWithInteger:4] forKey:@"device_type"];
    [params setSafeObject:MOBILE_KEY forKey:@"mobile_key"];

    [[NetService sharedNetService] getPath:kIndexPhpVersion parameters:params success:^(id sucRes) {
        suc(sucRes);
    } failure:^(id failRes) {
        fail(failRes);
    }];
}

-(void)requestSearchWords:(NSString *)words Success:(successBlock)suc failure:(failureBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:APP_VERSION forKey:@"version"];
    [params setSafeObject:MOBILE_KEY forKey:@"mobile_key"];
    [params setSafeObject:@"iOS" forKey:@"platform"];
    [params setSafeObject:words forKey:@"word"];
    
    [[NetService sharedNetService] getPath:kSearchAssociate parameters:params success:^(id sucRes) {
        suc(sucRes);
    } failure:^(id failRes) {
        fail(failRes);
    }];
}

- (void)requestSeachAllWithLastId:(NSInteger)lastid title:(NSString *)title success:(void (^)(id))suc failure:(void (^)(id))fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:APP_VERSION forKey:@"version"];
    [params setSafeObject:MOBILE_KEY forKey:@"mobile_key"];
    [params setSafeObject:@"iOS" forKey:@"platform"];
    [params setSafeObject:title forKey:@"title"];
    [params setSafeObject:@(lastid) forKey:@"last_data_id"];
    
    [[NetService sharedNetService] getPath:kSearchAll parameters:params success:^(id sucRes) {
        if (suc) {
            suc(sucRes);
        }
    } failure:^(id failRes) {
        if (fail) {
            fail(failRes);
        }
    }];
}


- (void)requestSeachAlbumWithLastId:(NSInteger)lastid title:(NSString *)title success:(void (^)(id))suc failure:(void (^)(id))fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:APP_VERSION forKey:@"version"];
    [params setSafeObject:MOBILE_KEY forKey:@"mobile_key"];
    [params setSafeObject:@"iOS" forKey:@"platform"];
    [params setSafeObject:title forKey:@"title"];
    [params setSafeObject:@(lastid) forKey:@"last_data_id"];
    
    [[NetService sharedNetService] getPath:kSearchAlbum parameters:params success:^(id sucRes) {
        if (suc) {
            suc(sucRes);
        }
    } failure:^(id failRes) {
        if (fail) {
            fail(failRes);
        }
    }];
}

- (void)requestSeachTrackWithLastId:(NSInteger)lastid title:(NSString *)title success:(void (^)(id))suc failure:(void (^)(id))fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setSafeObject:APP_VERSION forKey:@"version"];
    [params setSafeObject:MOBILE_KEY forKey:@"mobile_key"];
    [params setSafeObject:@"iOS" forKey:@"platform"];
    [params setSafeObject:title forKey:@"title"];
    [params setSafeObject:@(lastid) forKey:@"last_data_id"];
    
    [[NetService sharedNetService] getPath:kSearchTrack parameters:params success:^(id sucRes) {
        if (suc) {
            suc(sucRes);
        }
    } failure:^(id failRes) {
        if (fail) {
            fail(failRes);
        }
    }];
}

@end

//
//  NetManager.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/22.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstant.h"
#import "NetService.h"

@interface NetManager : NSObject

typedef void(^successBlock)(id);
typedef void(^failureBlock)(id);
typedef void(^successBlankBlock)(void);
typedef void(^failureBlankBlock)(void);

+ (instancetype)sharedNetManager;

//获取首页数据
-(void)getMainData:(NSNumber *)last_data_id andSub_category_id:(NSNumber *)sub_category_id Success:(successBlock)suc failure:(failureBlock)fail;


//专辑内页接口
-(void)getAlbumContentDataAlbumId:(NSNumber *)albumID andLastDataOrder:(NSNumber *)last_data_order Success:(successBlock)suc failure:(failureBlock)fail;


//获取专辑内页所有数据
-(void)getAlbumAllContentDataAlbumId:(NSNumber *)albumID Success:(successBlock)suc failure:(failureBlock)fail;


//获取更多应用数据
-(void)getMoreAppDataSuccess:(successBlock)suc failure:(failureBlock)fail;



//获取二级标题
-(void)getSubcategoryTitleSuccess:(void (^) (id))suc failure:(void (^) (id))fail;


//检测新版本
- (void)requestCheckUpdateVersionSuccess:(void (^) (id))suc failure:(void (^) (id))fail;


//搜索联想
-(void)requestSearchWords:(NSString *)words Success:(successBlock)suc failure:(failureBlock)fail;

//搜索全部
- (void)requestSeachAllWithLastId:(NSInteger)lastid title:(NSString *)title success:(void (^)(id))suc failure:(void (^)(id))fail;

//搜素节目
- (void)requestSeachTrackWithLastId:(NSInteger)lastid title:(NSString *)title success:(void (^)(id))suc failure:(void (^)(id))fail;

//搜索专辑
- (void)requestSeachAlbumWithLastId:(NSInteger)lastid title:(NSString *)title success:(void (^)(id))suc failure:(void (^)(id))fail;
@end

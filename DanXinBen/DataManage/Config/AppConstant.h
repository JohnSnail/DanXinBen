//
//  AppConstant.h
//  duotin2.0
//
//  Created by Vienta on 4/16/14.
//  Copyright (c) 2014 Duotin Network Technology Co.,LTD. All rights reserved.
//

#ifndef duotin2_0_AppConstant_h
#define duotin2_0_AppConstant_h

#define API_HOST @"http://a2m.duotin.com/"                    //正式服务器
//#define API_HOST @"http://a2m.danxinben.com/"                   //测试服务器

#define MOBILE_KEY @"001f7679-TkqZSZ877HPvxs9hfuGPIN"
//#define MOBILE_KEY @"000000da-693xVJB2avZsx3F1la67n" //测试key

#define iOS_Platform 4

#define kNotificationNetworkChanged             @"kNotificationNetworkChanged"          //网络发生变化

#define kRequestSuccess 0

//判断url字符串是否有效
#define ISVALIDURLSTRING(urlstr) ((urlstr) && [(urlstr) length]>0 && ![(urlstr) isEqualToString:@"null"] && ![(urlstr) isEqualToString:@"(null)"]) ? urlstr : nil

//singleton
#define SINGLETON_CLASS(classname) \
\
+ (classname *)shared##classname \
{\
static dispatch_once_t pred = 0; \
__strong static id _shared##classname = nil; \
dispatch_once(&pred,^{ \
_shared##classname = [[self alloc] init]; \
});  \
return _shared##classname; \
}

//********************************************************************
//百家讲坛
#define category_id 323

//精品推荐
#define subCategoryId 332

////于丹
//#define subCategoryYu 287
//
////袁腾飞
//#define subCategoryYuan 288
//
////历史疑案
//#define subCategoryHis 288
//
////正说清史
//#define subCategoryZheng 289
//
////名著解说
//#define subCategoryMing 290
//
////战争档案
//#define subCategoryDang 291
//
////王朝兴衰
//#define subCategoryWang 292
//
////国学经典
//#define subCategoryGuo 293
//
////名人文化
//#define subCategoryHua 294
//
////易中天
//#define subCategoryYi 286


//********************************************************************



//百家讲坛（易中天）
#define MainRecommendPort @"category/album"

//专辑内页
#define AlbumContentPort @"album/track"

//专辑内所有节目
#define AlbumAllContentPort @"album/tracks"

//更多推荐
#define MoreAppPort @"http://www.duotin.com/api/app/more_app_new"

//二级分类
#define SubTitlePort @"category/sub_category"

//检测新版本
#define kIndexPhpVersion  @"index.php/version"

//搜索联想
#define kSearchAssociate  @"search/associate"

//搜索所有
#define kSearchAll  @"search/all"

//搜索专辑
#define kSearchAlbum                @"search/album"

//搜索节目
#define kSearchTrack                @"search/track"

#endif

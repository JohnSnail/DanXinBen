//
//  AppConstant.h
//  duotin2.0
//
//  Created by Vienta on 4/16/14.
//  Copyright (c) 2014 Duotin Network Technology Co.,LTD. All rights reserved.
//
/**
 *  该文件后期需要分开
 */
#ifndef duotin2_0_AppConstant_h
#define duotin2_0_AppConstant_h

#define API_HOST @"http://a2m.duotin.com/"                    //正式服务器
//#define API_HOST @"http://a2m.danxinben.com/"                   //测试服务器

#define iOS_Platform 4

#define kRequestSuccess 0
//多听主版本所有接口
#define kWelcomeIndex               @"welcome/index"                  //欢迎页数据
#define kRecommend                  @"recommend"                       //获取首页推荐
#define kAlbumSubscribeRank         @"album/subscribe_rank"           //订阅榜数据
#define kWelcome                    @"welcome"                        //登录界面背景图
#define kRecommendMore              @"recommend/more"                 //推荐分类下更多
#define kMobileSetting              @"mobile_setting"                 //获取推送通知设置信息
#define kMobileSettingTurnon        @"mobile_setting/turnon"          //开启推送通知
#define kMobileSettingTurnoff       @"mobile_setting/turnoff"         //关闭推送通知
#define kAlbumTrack                 @"album/track"                    //专辑包含节目
#define kAlbumTracks                @"album/tracks"                   //获取专辑下所有节目
#define kMobileUserRegist           @"mobile_user/regist"             //注册设备
#define kDownloadAlbum              @"download/album"                 //列出下载节目记录
#define kDownloadAlbumAdd           @"download/album/add"             //添加下载专辑
#define kDownloadAlbumDelete        @"download/album/delete"          //删除下载专辑
#define kDownloadAlbumClear         @"download/album/clear"           //清空下载记录
#define kDownloadTrackAdd           @"download/track/add"             //添加下载节目
#define kDownloadTrackDelete        @"download/track/delete"          //删除下载节目
#define kCategory                   @"category"                       //频道页面数据
#define kUserSubscribeCategoryUpdate @"user/subscribe_category/update" //更新订阅分类
#define kUserSubscribeCategory      @"user/subscribe_category"        //获取订阅分类
#define kPodcastAlbum               @"podcast/album"                  //博客电台列表
#define kUserLike                   @"user/like"                      //获取我喜欢的节目
#define kUserLikeAdd                @"user/like/add"                  //喜欢一个节目
#define kUserLikeDelete             @"user/like/delete"               //取消喜欢节目
#define kUserComment                @"user/comment"                   //我的评论
#define kUserCommentAdd             @"user/comment/add"               //评论节目
#define kUserCommentDelete          @"user/comment/delete"            //删除评论或回复
//#define kRecommendCategoryAll       @"recommend_category/all/"        //首页订阅
#define kRecommendCategorySubscribeList       @"recommend_category/subscribe_list/"        //首页订阅
#define kSubscribeNewTracks         @"/user/subscribe/has_new_tracks/" //订阅是否有更新

/**
 *  user/comment/reply 接口新增需要上传字段 track_id
 */
#define kUserCommentReply           @"user/comment/reply"             //回复评论
#define kMobileUserBindBaidu        @"mobile_user/bind_baidu"         //绑定百度
#define kUserRegist                 @"user/regist"                    //用户注册
#define kUserLogin                  @"user/login"                     //用户登录
#define kOpenUserLogin              @"open_user/login"                //第三方用户登录
#define kUserLogout                 @"user/logout"                    //用户退出登录
#define kUserInfo                   @"user/info"                      //我的个人信息
#define kUserInfoUpdate             @"user/info/update"               //修改个人信息
#define kUserInfoUpdatePassword     @"user/info/update_password"    //修改密码
#define kUserHistory                @"user/history"                   //收听历史
#define kUserHistoryDelete          @"user/history/delete"            //删除收听历史
#define kUserHistoryClear           @"user/history/clear"             //清空收听历史
#define kUserFeeds                  @"user/feeds"                     //我页面 feeds流
#define kUserNotice                 @"user/notice"                    //我的通知
#define kUserSubscribe              @"user/subscribe"                 //我订阅的专辑
#define kUserSubscribeSort          @"user/subscribe/sort"            //订阅的专辑排序
#define kUserSubscribeAdd           @"user/subscribe/add"             //订阅专辑
#define kUserSubscribeDelete        @"user/subscribe/delete"          //取消订阅
#define kSearch                     @"search"                         //搜索页面
#define kSearchAll                  @"search/all"                     //搜索所有
#define kSearchAlbum                @"search/album"                   //搜索专辑
#define kSearchTrack                @"search/track"                   //搜索节目
#define kTopic                      @"topic"                          //话题列表
#define kTopicAlbum                 @"topic/album"                    //话题包含的专辑
#define kTrack                      @"track"                          //节目信息
#define kTrackComment               @"track/comment"                  //列出节目评论
#define kMobileUserListening        @"mobile_user_listening"          //大家在听
#define kTrackListenRank            @"track/listen_rank"              //节目收听排行榜
#define kTrackCommentRank           @"track/comment_rank"             //节目评论排行榜
#define kMobileUserUpgrade          @"mobile_user/upgrade"            //多听1.0 设备升级
#define kCategoryAlbum              @"category/album"                 //频道页面专辑
#define kCategorySubCategory        @"category/sub_category"          //频道页面二级频道
#define kUserHistoryListenlog       @"user/history/listenlog"         //增加收听历史
#define kAlbumShare                 @"album/share"                    //分享专辑
#define kTrackShare                 @"track/share"                    //分享节目
#define kTrackShareRank             @"track/share_rank"               //节目分享排行榜
#define kSearchAssociate            @"search/associate"               //搜索联想
#define kIndexPhpVersion            @"index.php/version"              //检测新版本
#define kMoreApp                    @"more_app"                       //推荐更多应用
#define kMoreAppIsShow              @"more_app/is_show"               //显示隐藏更多推荐
#define kUserLikeClear              @"user/like/clear"                //清空喜欢节目
#define kUserRetrievePassword       @"user/retrieve_password"         //找回密码

//第三方获取用户详细信息
#define kSinaInfo                   @"https://api.weibo.com"
#define kTecentInfo                 @"https://graph.qq.com"


//UserDefaultKey
#define kRecommendUpdate        @"kRecommendUpdate"             //首页update时间
#define kVersion                @"VERSION"                      //旧版本
#define kShowMoreApp            @"is_show"                      //是否推荐more app
#define kUserSubscribeNew       @"userSubscribeNew"             //个人中心更新提示

/**********************Notification*********************/
#define kNotificationLoginSuccess               @"kNotificationLoginSuccess"            //登录成功，personinfo界面用

/**********************本地文件路径**********************/
#define kLocalUser      @"appuser.dat"                  //user信息
#define kLocalRecommend @"apprecommend.dat"             //首页推荐信息
#define kLocalChannel   @"appchannel.dat"               //频道页面信息       和user有关
#define kLocalTop10     @"apptop10.dat"                 //排行榜数据
#define kLocalWelcomePic @"welcome.png"                 //欢迎页面
#define kLocalPersonFeed @"apppersonfeed.dat"           //personinfo页面数据feeds


/**********************sqlite表名************************/
#define kDownloadAlbumTable  @"DownloadAlbum"                //下载专辑          和user无关，存入的是专辑
#define kHistoryTrackTable   @"HistoryTrack"                 //收听历史          和user有关，存入的是节目


//enum
//性别类型
typedef NS_ENUM(NSUInteger, GenderType) {
    GenderTypeMale = 1,
    GenderTypeFemale,
};
//时间周期类型，在排行榜处用到
typedef NS_ENUM(NSUInteger, PeriodType) {
    PeriodTypeToday = 1,    //今日
    PeriodTypeYesterday,    //昨日
    PeriodTypeWeek,         //本周
    PeriodTypeMonth,        //本月
    PeriodTypeAll           //所有
};
//排行榜请求相关，依次为订阅榜，收听榜，评论榜
typedef NS_ENUM(NSUInteger, TapStyle){
    TapStyleSubcribe = 1,
    TapStyleListen,
    TapStyleComment
};

typedef NS_ENUM(NSUInteger, SecondCategryStyle){
    SecondCategryStyleHot = 0,
    SecondCategryStyleNew
};

typedef void(^tapBlock)(id);

/************************Config**************************/
#define CREAT_XIB(__IBNAME__)  {[[[NSBundle mainBundle] loadNibNamed:__IBNAME__ owner:nil options:nil] objectAtIndex:0]}    //从xib加载方法
#define APP_WINDOW [[[UIApplication sharedApplication] delegate] window]                                                    //app的window
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]                   //app版本
#define StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)                                    //statusBar高度
#define NaviBarHeight 44                                                                                                    //NavigtionBar高度
#define TabBarHeight  49                                                                                                    //TabBar高度
#define GLOBAL_SCROLL_ANIMATION     0.3                                                                                     //标签动画时间
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height                                                           //屏幕高度
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width                                                             //屏幕宽度
#define OriginY ((IS_IOS_7) ? (StatusBarHeight + NaviBarHeight) : 0)                                                        //Add视图的origin.Y值
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568 ) < DBL_EPSILON)                 //iPhone5的判断
#define VenderBackgroundColor UIColorToRGB(0xf4f4f4)                                                                        //全局的背景色
#define UIColorToRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]                                                                                                              //将16进制颜色转换为uicolor

#endif

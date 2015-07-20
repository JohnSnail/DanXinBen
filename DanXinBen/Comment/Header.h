//
//  Header.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/15.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#ifndef DanXinBen_Header_h
#define DanXinBen_Header_h

#import "CommentMethods.h"
#import <UIImageView+AFNetworking.h>
#import "NetManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "NSMutableDictionary+SafeValue.h"
#import "UIScrollView+DXRefresh.h"
#import "SVProgressHUD.h"
#import <MobClick.h>

#define UMENG_KEY @"5306ba2756240be250161bab" //百家讲坛友盟key

#define AppleId @"845080575"

#define settingHeight ((IS_IOS_7)?53:0)
#define SuitHeightForIos ((IS_IOS_7)?64:44)

static inline CGPoint ccp( CGFloat x, CGFloat y )
{
    return CGPointMake(x, y);
}

typedef NS_ENUM(NSUInteger, TapStyle){
    TapStyleDesc = 1,
    TapStyleList,
    TapStyleRec
};

typedef NS_ENUM(NSUInteger, DownloadEidtStatus) {
    DownloadEidtStatusNormal = 1,
    DownloadEidtStatusEidt,
};

#define GLOBAL_SCROLL_ANIMATION     0.3                                                                                     //标签动画时间

#define boldFont(s) [UIFont boldSystemFontOfSize:(s)]

#define DOCUMENT_DIRECTORY_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define appDelegate  (AppDelegate *)[[UIApplication sharedApplication]delegate];

#define mainscreen [UIScreen mainScreen].bounds

#define mainScreenWidth [UIScreen mainScreen].bounds.size.width

#define mainScreenHeight [UIScreen mainScreen].bounds.size.height

#define CustomColor UIColorFromRGB(33, 189, 192)

#define NavTitleColor UIColorFromRGB(165,184,188)

#define CustomBgColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"custonBg"]]

#define UIColorFromRGB(RED,GREEN,BLUE) [UIColor colorWithRed:(float)RED/255.0 green:(float)GREEN/255.0 blue:(float)BLUE/255.0 alpha:1.0]

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]                   //app版本

#define SKU @"bjjt"

#define CREAT_XIB(__IBNAME__)  {[[[NSBundle mainBundle] loadNibNamed:__IBNAME__ owner:nil options:nil] objectAtIndex:0]}    //从xib加载方法

#define IS_IOS_7 (([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO)   //ios7判断宏定义

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568 ) < DBL_EPSILON)                 //iPhone5的判断


#define UIColorToRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]                                                                                                              //将16进制颜色转换为uicolor

#if __IPHONE_6_0 // iOS6 and later

#   define kTextAlignmentCenter    NSTextAlignmentCenter
#   define kTextAlignmentLeft      NSTextAlignmentLeft
#   define kTextAlignmentRight     NSTextAlignmentRight

#   define kTextLineBreakByWordWrapping      NSLineBreakByWordWrapping
#   define kTextLineBreakByCharWrapping      NSLineBreakByCharWrapping
#   define kTextLineBreakByClipping          NSLineBreakByClipping
#   define kTextLineBreakByTruncatingHead    NSLineBreakByTruncatingHead
#   define kTextLineBreakByTruncatingTail    NSLineBreakByTruncatingTail
#   define kTextLineBreakByTruncatingMiddle  NSLineBreakByTruncatingMiddle

#else // older versions

#   define kTextAlignmentCenter    UITextAlignmentCenter
#   define kTextAlignmentLeft      UITextAlignmentLeft
#   define kTextAlignmentRight     UITextAlignmentRight

#   define kTextLineBreakByWordWrapping       UILineBreakModeWordWrap
#   define kTextLineBreakByCharWrapping       UILineBreakModeCharacterWrap
#   define kTextLineBreakByClipping           UILineBreakModeClip
#   define kTextLineBreakByTruncatingHead     UILineBreakModeHeadTruncation
#   define kTextLineBreakByTruncatingTail     UILineBreakModeTailTruncation
#   define kTextLineBreakByTruncatingMiddle   UILineBreakModeMiddleTruncation

#endif


#if __IPHONE_6_0 // iOS6 and later

#   define kTextAlignmentCenter    NSTextAlignmentCenter
#   define kTextAlignmentLeft      NSTextAlignmentLeft
#   define kTextAlignmentRight     NSTextAlignmentRight

#   define kTextLineBreakByWordWrapping      NSLineBreakByWordWrapping
#   define kTextLineBreakByCharWrapping      NSLineBreakByCharWrapping
#   define kTextLineBreakByClipping          NSLineBreakByClipping
#   define kTextLineBreakByTruncatingHead    NSLineBreakByTruncatingHead
#   define kTextLineBreakByTruncatingTail    NSLineBreakByTruncatingTail
#   define kTextLineBreakByTruncatingMiddle  NSLineBreakByTruncatingMiddle

#else // older versions

#   define kTextAlignmentCenter    UITextAlignmentCenter
#   define kTextAlignmentLeft      UITextAlignmentLeft
#   define kTextAlignmentRight     UITextAlignmentRight

#   define kTextLineBreakByWordWrapping       UILineBreakModeWordWrap
#   define kTextLineBreakByCharWrapping       UILineBreakModeCharacterWrap
#   define kTextLineBreakByClipping           UILineBreakModeClip
#   define kTextLineBreakByTruncatingHead     UILineBreakModeHeadTruncation
#   define kTextLineBreakByTruncatingTail     UILineBreakModeTailTruncation
#   define kTextLineBreakByTruncatingMiddle   UILineBreakModeMiddleTruncation

#endif


#endif

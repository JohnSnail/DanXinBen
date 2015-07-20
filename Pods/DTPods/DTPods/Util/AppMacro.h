//
//  AppMacro.h
//  duotinfm
//
//  Created by Vienta on 14/10/24.
//  Copyright (c) 2014年 Duotin Network Technology Co.,LTD. All rights reserved.
//

#ifndef duotinfm_AppMacro_h
#define duotinfm_AppMacro_h

#define COLOR_RGBA(__red__,__green__,__blue__,__alpha__)    [UIColor colorWithRed:((__red__)*1.0/255.0) \
                                                                            green:((__green__)*1.0/255.0)\
                                                                             blue:((__blue__)*1.0/255.0) \
                                                                            alpha:(__alpha__*1.0)]

#define COLOR_CSS(__hex__)  [UIColor colorWithRed:((float)((__hex__ & 0xFF0000) >> 16))/255.0 \
                                            green:((float)((__hex__ & 0xFF00) >> 8))/255.0 \
                                             blue:((float)(__hex__ & 0xFF))/255.0 \
                                            alpha:1.0]
#define GLOBAL_BG_COLOR COLOR_CSS(0xf4f4f4)
#define GLOBAL_LINE_COLOR [UIColor colorWithRed:0.9 green:0.89 blue:0.9 alpha:1]
#define GLOBAL_TEXT_GRAY_COLOR [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1]
#define GLOBAL_SCROLL_ANIMATION 0.3
#define GLOBAL_BG_ALPHA 0.85

#define FONT_BOLD(__size__) [UIFont boldSystemFontOfSize:__size__]
#define FONT_SYSTEM(__size__) [UIFont systemFontOfSize:__size__]
#define CREAT_XIB(__xibname__)  {[[[NSBundle mainBundle] loadNibNamed:__xibname__ owner:nil options:nil] objectAtIndex:0]}
#define TIP_ALERT(__title__,__msg__) [[[UIAlertView alloc] initWithTitle:__title__ \
                                                                 message:__msg__ \
                                                                delegate:nil\
                                                       cancelButtonTitle:@"确定"\
                                                       otherButtonTitles:nil] show]

#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define APP_WINDOW [[[UIApplication sharedApplication] delegate] window] 
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]
#define DOCUMENT_DIRECTORY_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define SYSTEM_VERSION_EQUAL_TO(__version__)                  ([[[UIDevice currentDevice] systemVersion] compare:__version__ options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(__version__)              ([[[UIDevice currentDevice] systemVersion] compare:__version__ options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(__version__)  ([[[UIDevice currentDevice] systemVersion] compare:__version__ options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(__version__)                 ([[[UIDevice currentDevice] systemVersion] compare:__version__ options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(__version__)     ([[[UIDevice currentDevice] systemVersion] compare:__version__ options:NSNumericSearch] != NSOrderedDescending)


#define IS_IOS7_OR_GREATER (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) ? YES : NO)
#define STATUS_BAR_HEIGHT ((IS_IOS7_OR_GREATER)?20:0)
#define NAV_BAR_HEIGHT ((IS_IOS7_OR_GREATER)?64:44)
#define ADAPT_HEIGHT ((IS_IOS7_OR_GREATER)?64:44)
#define CONTENTVIEW_HEIGHT ((IS_IOS7_OR_GREATER)?(DEVICE_MAINSCREEN_HEIGHT - NAV_BAR_HEIGHT):(DEVICE_MAINSCREEN_HEIGHT - NAV_BAR_HEIGHT -20)) //这个要废弃掉 因为不合理

#define DEVICE_MAINSCREEN [UIScreen mainScreen].bounds
#define DEVICE_MAINSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEVICE_MAINSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define IS_IPHONE4S_OR_LOWER    ([Util phoneInch] == IPhoneInchType_3_5)
#define IS_IPHONE5              ([Util phoneInch] == IPhoneInchType_4_0)
#define IS_IPHONE6              ([Util phoneInch] == IPhoneInchType_4_7)
#define IS_IPHONE6_PLUS         ([Util phoneInch] == IPhoneInchType_5_5)

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


#endif

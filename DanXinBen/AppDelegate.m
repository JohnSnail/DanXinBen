//
//  AppDelegate.m
//  DanXinBen
//
//  Created by Jiangwei on 14/9/27.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "FindViewController.h"
#import "HistoryViewController.h"
#import "SettingViewController.h"
#import "Header.h"
#import "NavController.h"
#import "PlayViewController.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVFoundation.h>
#import <MobClick.h>

@interface AppDelegate ()
@property (nonatomic, strong) NSMutableArray *tabbarMuArray;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //友盟统计
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:REALTIME channelId:nil];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabbarMuArray = [NSMutableArray arrayWithCapacity:0];
    
    [self showRootViewContrller];
    
    [self.window makeKeyAndVisible];
    
    _PlayingInfoCenter = [[NSMutableDictionary alloc] init];
    //锁屏播放设置
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

    return YES;
}

- (void)showRootViewContrller
{
    NSString *proName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    
    //首页
    MainViewController *mainViewController = [[MainViewController alloc]init];
    mainViewController.navigationItem.titleView = [CommentMethods navigationTitleView:proName];
    [self showRootViewContrller:mainViewController andUnselectedImage:[UIImage imageNamed:@"tabmain"] andSelectedImage:[UIImage imageNamed:@"tabmain-selected"]];
    
    //发现
    FindViewController *findViewController = [[FindViewController alloc]init];
    [self showRootViewContrller:findViewController andUnselectedImage:[UIImage imageNamed:@"tabfind"] andSelectedImage:[UIImage imageNamed:@"tabfind-selected"]];
    
    //历史
    HistoryViewController *historyViewController = [[HistoryViewController alloc]init];
    historyViewController.navigationItem.titleView = [CommentMethods navigationTitleView:@"收听历史"];
    [self showRootViewContrller:historyViewController andUnselectedImage:[UIImage imageNamed:@"tabhistory"] andSelectedImage:[UIImage imageNamed:@"tabhistory-selected"]];
    
    //设置
    SettingViewController *settingViewController = [[SettingViewController alloc]init];
    settingViewController.navigationItem.titleView = [CommentMethods navigationTitleView:@"设置"];
    [self showRootViewContrller:settingViewController andUnselectedImage:[UIImage imageNamed:@"tabsetting"] andSelectedImage:[UIImage imageNamed:@"tabsetting-selected"]];
}

- (void)showRootViewContrller:(UIViewController *)viewController andUnselectedImage:(UIImage *)unSelectImage andSelectedImage:(UIImage *)selectImage
{
    if (IS_IOS_7) {
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0, 11, 30)];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UINavigationBar appearance] setTintColor:NavTitleColor];
    
    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(8, 0, -8, 0)];
    viewController.tabBarItem.image = [unSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NavController *navigationController = [[NavController alloc]initWithRootViewController:viewController];
    
    [self.tabbarMuArray addObject:navigationController];
    
    UITabBarController *tabbarController = [[UITabBarController alloc]init];
    
    UIImage *image = [UIImage imageNamed:@"tabbar"];
    [tabbarController.tabBar setBackgroundImage:image];
    
    tabbarController.viewControllers = [NSArray arrayWithArray:self.tabbarMuArray];
    
    self.window.rootViewController = tabbarController;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                [[PlayViewController sharedManager] playPauseAction:nil];
            }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack: {
                [[PlayViewController sharedManager] lastAction:nil];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack: {
                [[PlayViewController sharedManager] nextAction:nil];
                break;
            }
            default: {
                break;
            }
        }
    }
}

@end

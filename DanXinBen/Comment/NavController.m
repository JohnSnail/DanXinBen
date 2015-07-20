//
//  NavController.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/30.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "NavController.h"
#import "CommentMethods.h"
#import "Header.h"
#import "PlayViewController.h"
#import <AudioService.h>
#import "FindViewController.h"

@interface NavController ()
{
    UIButton *btn;
}
@end

@implementation NavController

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    NavController* nvc = [super initWithRootViewController:rootViewController];
    if (IS_IOS_7) {
        self.interactivePopGestureRecognizer.delegate = self;
        nvc.delegate = self;
    }
    return nvc;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    self.playShowVC = viewController;
    
    if (navigationController.viewControllers.count == 1)
        self.currentShowVC = nil;
    else
        self.currentShowVC = viewController;
}

-(void)pushPlayAction
{
    [CommentMethods pushCurrentPlayVC:self.playShowVC];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([PlayViewController sharedManager].playTrack) {
        if(viewController.navigationItem.rightBarButtonItem == nil && ![viewController isKindOfClass:[FindViewController class]]){
            if (!btn) {
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            if (IS_IOS_7) {
                btn.frame = CGRectMake(mainScreenWidth - 50,0, 40, 40);
            }else{
                btn.frame = CGRectMake(mainScreenWidth - 50,20, 40, 40);
            }
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
            [btn setImage:[UIImage imageNamed:@"play_1"] forState:UIControlStateNormal];
            [CommentMethods navigationPlayButtonItem:btn];
            
            [btn addTarget:self action:@selector(pushPlayAction) forControlEvents:UIControlEventTouchUpInside];
            viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        }else if(btn){
            [CommentMethods navigationPlayButtonItem:btn];
        }
    };
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer)
    {
        if ([self.currentShowVC isKindOfClass:[PlayViewController class]])
        {
            return NO; //播放界面时取消返回手势
        }

        return (self.currentShowVC == self.topViewController);
    }
    return YES;
}

@end

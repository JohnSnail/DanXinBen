//
//  DTBaseViewController.h
//  duotin2.0
//
//  Created by Vienta on 5/21/14.
//  Copyright (c) 2014 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTBaseViewController : UIViewController

@property (nonatomic, assign) BOOL switchNet;

@property (nonatomic, strong) UIView *dtNavigationBar;

@property (nonatomic, assign) BOOL dtNavigionBarHidden;//default is NO


@property (nonatomic, copy) NSString *dtTitle;
@property (nonatomic, strong) UIColor *dtTitleColor;
@property (nonatomic, strong) UIFont *dtTitleFont;

@property (nonatomic, strong) UIView *dtTitleView;
@property (nonatomic, strong) UIView *dtLeftCustomView;
@property (nonatomic, strong) UIView *dtRightCustomView;

@property (nonatomic, assign) BOOL isShowPlay;//是否显示播放中按钮
@property (nonatomic, assign) BOOL isShowNetError;//是否显示无网空界面 默认显示


@end

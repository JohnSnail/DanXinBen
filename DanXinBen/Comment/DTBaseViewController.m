//
//  DTBaseViewController.m
//  duotin2.0
//
//  Created by Vienta on 5/21/14.
//  Copyright (c) 2014 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import "DTBaseViewController.h"
#import "UIScrollView+AllowPanGestureEventPass.h"
#import "UINavigationController+iOS7Support.h"
#import "FXBlurView.h"
#import "UIButton+EnlargeArea.h"
#import "Header.h"

#define OriginSpace 56.0

@interface DTBaseViewController ()

@end

@implementation DTBaseViewController
{
    UIImageView *noNetIgv;
    UILabel *_dtTitleLabel;
    UIButton *_pushToPlayBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.dtNavigationBar = ({
        
        CGFloat navBarHeight = (IS_IOS_7) ? 64 : 44;
        CGFloat navBarWidth = CGRectGetWidth(self.view.bounds);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navBarWidth, navBarHeight)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(0, CGRectGetHeight(view.bounds))];
        [linePath addLineToPoint:CGPointMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds))];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.path = [linePath CGPath];
        lineLayer.strokeColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1].CGColor;
        lineLayer.lineWidth = 0.5f;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        [view.layer addSublayer:lineLayer];
        
        _dtTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.bounds) - OriginSpace *2, CGRectGetHeight(view.bounds))];
        _dtTitleLabel.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetHeight(view.bounds) - 22);
        _dtTitleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:_dtTitleLabel];
        
        self.dtTitleColor = UIColorToRGB(0xff6600);
        self.dtTitleFont = [UIFont boldSystemFontOfSize:18];
        
        view;
    });
    
    [self.view addSubview:self.dtNavigationBar];
    
    self.isShowNetError = YES;
    
    [[NetService sharedNetService] reachablityStatus:nil fail:^(int noNet) {
        noNetIgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenHeight)];
        NSString *imgName = IS_IPHONE_5 ? @"iphone5" : @"iphone4";
        [noNetIgv setImage:[UIImage imageNamed:imgName]];
        noNetIgv.userInteractionEnabled = YES;
        
        if (self.isShowNetError) {
            if (self.dtNavigationBar) {
                [self.view insertSubview:noNetIgv belowSubview:self.dtNavigationBar];
            } else {
                [self.view addSubview:noNetIgv];
            }
            noNetIgv.hidden = NO;
        } else {
            noNetIgv.hidden = YES;
        }
    }];
    
    
    if (IS_IOS_7) {
        [self.view.subviews enumerateObjectsUsingBlock:^(id subView, NSUInteger idx, BOOL *stop) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scrollSubView = (UIScrollView *)subView;
                if (self.navigationController) {
                    [scrollSubView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.screenEdgePanGestureRecognizer];
                }
            }
        }];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    self.view.backgroundColor = viewBackColor;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.dtLeftCustomView && self.navigationController && [[self.navigationController viewControllers] count] > 1) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.backgroundColor = [UIColor clearColor];
        backBtn.frame = CGRectMake(0, 0, 12, 20);
        [backBtn setImage:[UIImage imageNamed:@"back_general"] forState:UIControlStateNormal];
        self.dtLeftCustomView = backBtn;
        [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setEnlargeEdge:OriginSpace / 2];
    }
    
    if (self.isShowNetError) {
        noNetIgv.hidden = NO;
    } else {
        noNetIgv.hidden = YES;
    }
    
//    NSInteger currentId = [PlayController sharedManager].trackModel.track_id.integerValue;
//    if (self.isShowPlay && currentId != 0) {
//        [self customPlayView];
//    } else {
//        [self hideCustomPlayView];
//    }
//    [self.view bringSubviewToFront:self.dtNavigationBar];//为了最高层
//    
//    if (self.isShowNetError) {
//        
//    }
}

- (void)customPlayView
{
    if (!_pushToPlayBtn) {
        _pushToPlayBtn = ({
            
            UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, 0, 75, 35)];
            [btn setImage:[UIImage imageNamed:@"push_general"] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorToRGB(0xff6600) forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(7, 58, 7, 0)];
            [btn setTitle:@"播放中" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 15)];
            [btn addTarget:self action:@selector(pushToCurrentPlayView:) forControlEvents:UIControlEventTouchUpInside];

            btn;
        });
        
        _pushToPlayBtn.hidden = NO;
        [self.dtNavigationBar addSubview:_pushToPlayBtn];
       
        _pushToPlayBtn.center = CGPointMake(CGRectGetWidth(self.dtNavigationBar.bounds) - OriginSpace / 2 - 10, CGRectGetHeight(self.dtNavigationBar.bounds) - 22);
    }
}

- (void)hideCustomPlayView
{
    if (_pushToPlayBtn) {
        _pushToPlayBtn.hidden = YES;
    }
}

- (void)pushToCurrentPlayView:(id)sender
{
//    [PlayController sharedManager].hidesBottomBarWhenPushed = YES;
//    [Util pushPlayWithNavigation:self.navigationController block:^{
//        [PlayController sharedManager].isFromDownload = NO;
//        [self.navigationController pushViewController:[PlayController sharedManager] animated:YES];
//    }];
}

- (void)popViewController:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setDtTitle:(NSString *)dtTitle
{
    _dtTitle = dtTitle;
    _dtTitleLabel.text = dtTitle;
}

- (void)setDtTitleColor:(UIColor *)dtTitleColor
{
    _dtTitleColor = dtTitleColor;
    [_dtTitleLabel setTextColor:_dtTitleColor];
}

- (void)setDtTitleFont:(UIFont *)dtTitleFont
{
    _dtTitleFont = dtTitleFont;
    [_dtTitleLabel setFont:_dtTitleFont];
}

- (void)setDtNavigionBarHidden:(BOOL)dtNavigionBarHidden
{
    _dtNavigionBarHidden = dtNavigionBarHidden;
    self.dtNavigationBar.hidden = _dtNavigionBarHidden;
}

- (void)setDtTitleView:(UIView *)dtTitleView
{
    [_dtTitleView removeFromSuperview];
    _dtTitleView = dtTitleView;
    if (!_dtTitleView) {
        _dtTitleLabel.hidden = NO;
    } else {
        _dtTitleLabel.hidden = YES;
        [self.dtNavigationBar addSubview:_dtTitleView];
        _dtTitleView.center = _dtTitleLabel.center;
    }
}

- (void)setDtLeftCustomView:(UIView *)dtLeftCustomView
{
    [_dtLeftCustomView removeFromSuperview];
    _dtLeftCustomView = dtLeftCustomView;
    [self.dtNavigationBar addSubview:_dtLeftCustomView];
    _dtLeftCustomView.center = CGPointMake(OriginSpace / 2, CGRectGetHeight(self.dtNavigationBar.bounds) - 22);
}

- (void)setDtRightCustomView:(UIView *)dtRightCustomView
{
    [_dtRightCustomView removeFromSuperview];
    _dtRightCustomView = dtRightCustomView;
    [self.dtNavigationBar addSubview:_dtRightCustomView];
    _dtRightCustomView.center = CGPointMake(CGRectGetWidth(self.dtNavigationBar.bounds) - OriginSpace / 2, CGRectGetHeight(self.dtNavigationBar.bounds) - 22);
}

- (void)setSwitchNet:(BOOL)switchNet
{
    _switchNet = switchNet;
    noNetIgv.hidden = _switchNet;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

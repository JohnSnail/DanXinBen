//
//  NavController.h
//  DanXinBen
//
//  Created by Jiangwei on 14/10/30.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavController : UINavigationController<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property(nonatomic,weak) UIViewController* currentShowVC;
@property(nonatomic,weak) UIViewController* playShowVC;

@end

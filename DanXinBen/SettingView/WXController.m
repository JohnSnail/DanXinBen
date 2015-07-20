/**
 * WXController
 * @description 本文件提供多听2.0 官方微信引导功能
 * @package
 * @author 		guojiangwei@duotin.com
 * @copyright 	Copyright (c) 2012-2020   Duotin Network Technology Co.,LTD
 * @version 		1.0.1
 * @description 本文件提供多听2.0 官方微信引导功能
 */

#import "WXController.h"
#import "Header.h"

@interface WXController ()
{
    UIImageView *_backGroundImage;
    UIButton *_sendWX;
}
@end

@implementation WXController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.view.backgroundColor = viewBackColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _backGroundImage = [[UIImageView alloc]initWithFrame:mainscreen];
    if (IS_IPHONE_5){
        _backGroundImage.image = [UIImage imageNamed:@"aboutus_wx5"];
    }else{
        _backGroundImage.image = [UIImage imageNamed:@"aboutus_wx4"];
    }
    _backGroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backGroundImage];
    
//    self.dtTitle = @"官方微信";
    self.navigationItem.titleView = [CommentMethods navigationTitleView:@"官方微信"];
    
    _sendWX = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendWX.frame = CGRectMake(0, mainScreenHeight - 60, mainScreenWidth, mainScreenHeight);
    [_sendWX addTarget:self action:@selector(sendtoWXAction) forControlEvents:UIControlEventTouchUpInside];
    _sendWX.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_sendWX];
}

#pragma mark - 
#pragma mark - 跳到微信
-(void)sendtoWXAction
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:@"duotin"];
    
    NSString *str =@"weixin://qr/JnXv90fE6hqVrQOU9yA0";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end

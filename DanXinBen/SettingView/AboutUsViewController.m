//
//  AboutUsViewController.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/28.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "AboutUsViewController.h"
#import "Header.h"
//#import "DTWeiboViewController.h"
#import "WXController.h"

@interface AboutUsViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *aboutUsTbView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.aboutUsTbView.separatorStyle = NO;
    self.aboutUsTbView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = [CommentMethods navigationTitleView:@"关于我们"];
    self.view.backgroundColor = CustomBgColor;
    self.navigationItem.backBarButtonItem = [CommentMethods commendBackItem];
}


#pragma mark -
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *titleLabel = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutUsCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutUsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = NavTitleColor;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setting_list_bg"]];
        bgImageView.backgroundColor = [UIColor clearColor];
        bgImageView.frame = CGRectMake(0, 0, mainScreenWidth, 50);
        [cell.contentView addSubview:bgImageView];
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor darkGrayColor];

        view.frame = CGRectMake(10, 49, mainScreenWidth - 10, 1);
        [cell.contentView addSubview:view];

        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth - 110, 0, 100, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = NavTitleColor;
        titleLabel.textAlignment = kTextAlignmentRight;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cell.contentView addSubview:titleLabel];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"版本号:";
            titleLabel.text = APP_VERSION;
            
            break;
        }
        case 1:{
            cell.textLabel.text = @"QQ群:";
            titleLabel.text =@"244342461";
            break;
        }
//        case 2:{
//            cell.textLabel.text = @"官方微博";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            break;
//        }
//        case 3:{
//            cell.textLabel.text = @"官方微信";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            break;
//        }
        default:
            break;
    }
    
    return cell;
}

-(void)openMicroblog:(NSURL *)url
{
    UIWebView *microblogView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    microblogView.scalesPageToFit = YES;
    [microblogView loadRequest:[NSURLRequest requestWithURL:url]];
    [microblogView setBackgroundColor:NavTitleColor];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [microblogView.layer addAnimation:transition forKey:nil];
    
    microblogView.delegate = self;
    [self.view addSubview:microblogView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [self openMicroblog:[NSURL URLWithString:@"http://m.weibo.cn/2955982490"]];
    }else if (indexPath.row == 3){
        WXController *wxVC = [[WXController alloc]init];
        wxVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wxVC animated:YES];
    }
}

@end

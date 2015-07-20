//
//  SettingViewController.m
//  buddhism
//
//  Created by Jiangwei on 14/10/8.
//  Copyright (c) 2014年 xiaohou. All rights reserved.
//

#import "SettingViewController.h"
#import "Header.h"
#import "UMFeedbackViewController.h"
#import "AboutUsViewController.h"
#import "DTTimingViewController.h"
#import "DTTimingManager.h"
#import <Util.h>
#import "UIAlertView+Blocks.h"
#import <AudioService.h>

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *setTbView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *casheLabel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.view.backgroundColor = CustomBgColor;
    self.setTbView.backgroundColor = [UIColor clearColor];
    self.setTbView.separatorStyle = NO;
    self.navigationItem.backBarButtonItem = [CommentMethods commendBackItem];
    
    [DTTimingManager sharedDTTimingManager].timingBlk = ^(NSNumber *timing) {
        if (timing.integerValue == 0) {
            self.titleLabel.text = @"未开启";
        }else{
            self.titleLabel.text = [Util formatIntoDateWithSecond:timing];
        }
    };
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        return 40;
    }else{
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = NavTitleColor;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];

        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setting_list_line"]];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setting_list_bg"]];
        bgImageView.frame = CGRectMake(0, 0, mainScreenWidth, 50);
        
        if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
            view.frame = CGRectMake(0, 39, mainScreenWidth, 1);
        }else{
            view.frame = CGRectMake(0, 49, mainScreenWidth, 1);
            [cell.contentView addSubview:bgImageView];
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:view];

        if (indexPath.row == 1) {
            if (self.titleLabel == nil) {
                self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth - 140, 0, 100, 50)];
                self.titleLabel.backgroundColor = [UIColor clearColor];
                self.titleLabel.textColor = NavTitleColor;
                self.titleLabel.textAlignment = kTextAlignmentRight;
                self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                [cell.contentView addSubview:self.titleLabel];
            }
        }else if (indexPath.row == 3){
            if (self.casheLabel == nil) {
                self.casheLabel = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth - 140, 0, 100, 50)];
                self.casheLabel.backgroundColor = [UIColor clearColor];
                self.casheLabel.textColor = NavTitleColor;
                self.casheLabel.textAlignment = kTextAlignmentRight;
                self.casheLabel.font = [UIFont boldSystemFontOfSize:16];
                [cell.contentView addSubview:self.casheLabel];
            }
        }
    }
    switch (indexPath.row) {
        case 1:
        {
            cell.textLabel.text = @"定时关闭";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.titleLabel.text = @"未开启";
            break;
        }
        case 3:{
            cell.textLabel.text = @"清除缓存";
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *playCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"DTPrebufferCache"];
            NSString *playCachStr = [NSString stringWithFormat:@"%.0fM",[Util sizeOfFolder:playCachePath] *1.0/ 1024 / 1024];
            self.casheLabel.text = playCachStr;
            
            break;
        }
//        case 5:{
//            cell.textLabel.text = @"检测新版本";
//            break;
//        }
//        case 6:{
//            cell.textLabel.text = @"升级高级版";
//            
//            UIImage *img = [UIImage imageNamed:@"setting_icon_pro"];
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
//            imageView.image = img;
//            cell.accessoryView = imageView;
//            
//            break;
//        }
        case 5:{
            cell.textLabel.text = @"给我好评";
            break;
        }
//        case 8:{
//            cell.textLabel.text = @"关于我们";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            break;
//        }
        case 6:{
            cell.textLabel.text = @"意见反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

-(void)clearCasheData
{
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:[[AudioService sharedAudioService] prebufferCacheFolderPath]];
    for (NSString *p in files) {
        NSError *error;
        NSString *path = [[CommentMethods getCachesDirectory] stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
}

-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
}


- (float) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
            [self pushTimeViewController];
            break;
        case 3:
        {
            [UIAlertView showWithTitle:@"温馨提示" message:@"清除音频缓存后，再次网络播放收听过的节目需要消耗流量，是否清除？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"仍然清除"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != [alertView cancelButtonIndex]) {
                    [[AudioService sharedAudioService] clearPrebufferCache];
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                    NSString *playCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"DTPrebufferCache"];
                    NSString *playCachStr = [NSString stringWithFormat:@"%.0fM",[Util sizeOfFolder:playCachePath] *1.0/ 1024 / 1024];
                    
                    self.casheLabel.text = playCachStr;
                    
                }
            }];
            break;
        }
//        case 5:
//            [self checkVersion];
//            break;
//        case 6:
//            [MobClick event:@"setting_appStore" label:@"设置页升级入口"];
//            [self pushAppStore];
//            break;
        case 5:
            [self pushAppStore];
            break;
//        case 8:
//            [self pushAboutUs];
//            break;
        case 6:
            [self pushFeedBackAction];
            break;
        default:
            break;
    }
}

-(void)checkVersion
{
    [[NetManager sharedNetManager] requestCheckUpdateVersionSuccess:^(NSDictionary *sucRes) {
        if ([[sucRes objectForKey:@"is_upgrade"] integerValue] == 1) {
            [UIAlertView showWithTitle:@"温馨提示" message:@"检测有新版本出现，是否尝鲜？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"升级"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != [alertView cancelButtonIndex]) {
                    [self pushAppStore];
                }
            }];
        } else {
            [UIAlertView showWithTitle:@"温馨提示" message:@"已是最新版本" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        }
    } failure:nil];
}


-(void)pushTimeViewController
{
    DTTimingViewController *timeVC = [[DTTimingViewController alloc] initWithNibName:@"DTTimingViewController" bundle:nil];
    timeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:timeVC animated:YES];
}

-(void)pushAppStore
{
    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/duo-ting.fm-jie-fang-shuang/id%@?l=en&mt=8",AppleId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)pushAboutUs
{
    AboutUsViewController *aboutVC = [[AboutUsViewController alloc]init];
    aboutVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutVC animated:YES];
}

-(void)pushFeedBackAction
{
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = UMENG_KEY;
    feedbackViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

@end

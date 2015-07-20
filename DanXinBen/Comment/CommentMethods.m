//
//  CommentMethods.m
//  DanXinBen
//
//  Created by Jiangwei on 14/10/15.
//  Copyright (c) 2014年 Jiangwei. All rights reserved.
//

#import "CommentMethods.h"
#import "Header.h"
#import "PlayViewController.h"
#import "AutoRunLabel.h"
#import "Header.h"
#import <AudioService.h>

@implementation CommentMethods

+(UIView *)navigationTitleView:(NSString *)title
{
    AutoRunLabel * navLabel = [[AutoRunLabel alloc]init];
    
    navLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    navLabel.font = boldFont(20.0);  //设置文本字体与大小
    navLabel.textColor = NavTitleColor;
    navLabel.textAlignment = kTextAlignmentCenter;
    navLabel.moveSpeech = -50.0f;
    navLabel.text = title;
    
    CGSize _textSize = [title sizeWithFont:navLabel.font forWidth:NSIntegerMax lineBreakMode:NSLineBreakByClipping];
    
    NSMutableString *muStr = [NSMutableString stringWithFormat:@"%@",title];
    if (muStr.length > 8) {
        if (IS_IOS_7) {
            navLabel.frame = CGRectMake(mainScreenWidth/2 - 140/2, 20, 140, 44);
        }else{
            navLabel.frame = CGRectMake(mainScreenWidth/2 - 140/2, 0, 140, 44);
        }
    } else {
        if (IS_IOS_7) {
            navLabel.frame = CGRectMake(mainScreenWidth/2 - _textSize.width/2, 20, _textSize.width, 44);
        }else{
            navLabel.frame = CGRectMake(mainScreenWidth/2 - _textSize.width/2, 0, _textSize.width, 44);
            
        }
    }
   
    return (UIView *)navLabel;
}

+(UIBarButtonItem *)commendBackItem
{
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    return backItem;
}

+ (UIImageView *)cuttingLineWithOriginx:(CGFloat)x andOriginY:(CGFloat)y;
{
    UIImageView * lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, mainScreenWidth - 2 * x, 0.5)];
    lineImg.image = [UIImage imageNamed:@"line_general"];
    lineImg.backgroundColor = [UIColor darkGrayColor];
    return lineImg;
}

+(NSString *)getCachesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+(void)pushCurrentPlayVC:(UIViewController *)viewController
{
    [PlayViewController sharedManager].hidesBottomBarWhenPushed = YES;
    [viewController.navigationController pushViewController:[PlayViewController sharedManager] animated:YES];
}

+ (void)navigationPlayButtonItem:(UIButton *)btn
{
    NSMutableArray *anMuArr = [NSMutableArray arrayWithCapacity:19];
    for (int i=1; i<=19; i++) {
        NSString *str = [NSString stringWithFormat:@"play_%d",i];
        [anMuArr addObject:str];
    }
    
    NSMutableArray *anImgArr= [NSMutableArray arrayWithCapacity:0];
    for (int i= 0; i < [anMuArr count]; i++) {
        UIImage *img = [UIImage imageNamed:anMuArr[i]];
        [anImgArr addObject:img];
    }
    [btn.imageView setAnimationImages:anImgArr];
    [btn.imageView setAnimationDuration:0.9];
    if ([AudioService sharedAudioService].currentPlayState == AudioPlayStatePlaying) {
        [btn.imageView startAnimating];
    }else{
        [btn.imageView stopAnimating];
    }
}

#pragma mark -
#pragma mark - NSString和NSDate相互转化
+(NSString *)transformateToNSString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+(NSDate *)transformateToNSDate:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+(NSString *)getTargetFloderPath
{
    NSString *downPath = [DOCUMENT_DIRECTORY_PATH stringByAppendingPathComponent:@"Downloaded"];
    [CommentMethods addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:downPath]];
    return downPath;
}

#pragma mark -
#pragma mark - 标识不需备份数据

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    NSError *error = nil;
    [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}

+(void)clearDocu:(NSString *)filePath
{
    NSError *error;
    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    if ([defaultManager removeItemAtPath:filePath error:&error]!= YES)
    {
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        //显示文件目录的内容
    }
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

+ (void)setLocalData:(id)value key:(NSString *)key
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    if (key) {
        [setting setObject:value forKey:key];
    } else {
        [setting removeObjectForKey:key];
    }
    [setting synchronize];
}

/**
 * getLocalData
 *
 * 根据key获取本地保存的value
 *
 * @access public
 * @param string key
 *
 * @return 返回key对应的值
 */
+ (id)getLocalData:(NSString *)key
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    
    id data = [setting objectForKey:key];
    if (data) {
        return data;
    } else {
        return nil;
    }
}


/**
 * needUpdateCache
 *
 * 根据key和缓存的时间判断是否需要更新缓存
 *
 * @access public
 * @param string key        缓存的键值
 * @param NSTimeInterval    timeInterval  缓存的时间
 *
 * @return 返回key对应的值
 */
+ (BOOL)needUpdateCache:(NSString *)key timeInterval:(NSTimeInterval)timeInterval
{
    NSString *value = [CommentMethods getLocalData:key];
    if (value) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - [value intValue];
        if (interval < timeInterval) {
            return NO;
        }
    }
    return YES;
}

+ (void)setCacheTime:(NSString *)key
{
    [CommentMethods setLocalData:[NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]] key:key];
}

+ (void)saveSearchHistory:(NSString *)searchStr
{
    //存储搜索历史记录
    NSArray *filePath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *historyFile=[[filePath objectAtIndex:0] stringByAppendingPathComponent:@"historyFile.txt"];
    NSMutableArray * hisArr = [[NSMutableArray alloc]initWithCapacity:10];
    [hisArr addObjectsFromArray:[NSArray arrayWithContentsOfFile:historyFile]];
    //检查该热词是否存在在历史记录中，默认是没有，需要添加
    BOOL addToHistory = YES;
    for (NSString * historyStr in hisArr)
    {
        if ([historyStr isEqualToString:searchStr])
        {
            //找到，之前存在过，跳出循环
            addToHistory = NO;
            break;
        }
    }
    //判断是否加入到历史记录
    if (addToHistory)
    {
        [hisArr insertObject:searchStr atIndex:0];
        [hisArr writeToFile:historyFile atomically:YES];
    }
}

+(void)deleteSearchHistory:(NSString *)searchStr
{
    //存储搜索历史记录
    NSArray *filePath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *historyFile=[[filePath objectAtIndex:0] stringByAppendingPathComponent:@"historyFile.txt"];
    NSMutableArray * hisArr = [[NSMutableArray alloc]initWithCapacity:10];
    [hisArr addObjectsFromArray:[NSArray arrayWithContentsOfFile:historyFile]];
    
    [hisArr removeObject:searchStr];
    [hisArr writeToFile:historyFile atomically:YES];
}

+ (NSArray *)getSearchHistroy
{
    NSArray *filePath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *historyFile=[[filePath objectAtIndex:0] stringByAppendingPathComponent:@"historyFile.txt"];
    NSArray * hisarr = [NSArray arrayWithContentsOfFile:historyFile];
    return hisarr;
}

@end

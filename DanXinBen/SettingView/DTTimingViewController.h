//
//  DTTimingViewController.h
//  duotin2.0
//
//  Created by Vienta on 14-10-17.
//  Copyright (c) 2014年 Duotin Network Technology Co.,LTD. All rights reserved.
//

#import "DTBaseViewController.h"

@interface DTTimingViewController : DTBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tbvTiming;

@end

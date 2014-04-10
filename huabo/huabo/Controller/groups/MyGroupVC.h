//
//  MyGroupVC.h
//  huabo
//
//  Created by admin on 14-3-24.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void(^selectFinish)(NSArray *);

@interface MyGroupVC :  BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _selectedCount;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain,nonatomic) NSMutableArray *arrData;

@property (copy,nonatomic) selectFinish block;
@end

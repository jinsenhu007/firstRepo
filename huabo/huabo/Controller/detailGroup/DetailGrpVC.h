//
//  DetailGrpVC.h
//  huabo
//
//  Created by admin on 14-4-14.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"

@interface DetailGrpVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) NSMutableArray *arrData;
@end

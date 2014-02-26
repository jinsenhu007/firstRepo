//
//  AllViewController.h
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"

@interface AllViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>



@property (retain,nonatomic) UITableView *tableView;
@property (retain,nonatomic) NSMutableArray *arrData;
@end

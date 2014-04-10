//
//  AtUsersVC.h
//  huabo
//
//  Created by admin on 14-3-27.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^selectFinish)(NSArray *);

@interface AtUsersVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
{
    NSUInteger _selectCount;//选中人数
    
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchVC;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (retain,nonatomic) NSMutableArray *arrData; //处理raw数组
@property (retain,nonatomic) NSMutableArray *arrDataSource; //处理后的数组，作为数据源

@property (retain,nonatomic) NSMutableArray *arrFiltered;

@property (copy,nonatomic) selectFinish block;
@end

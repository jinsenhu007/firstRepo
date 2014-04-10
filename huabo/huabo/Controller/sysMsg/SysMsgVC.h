//
//  SysMsgVC.h
//  huabo
//
//  Created by admin on 14-4-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"

@interface SysMsgVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _needCache;
    NSInteger _maxID; //获取更多数据用的 for 回复我的
    BOOL _isLoadMore; //是否加载更多数据
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) NSMutableArray *arrData;

@property (retain,nonatomic) NSString *strOfUrl;
@end

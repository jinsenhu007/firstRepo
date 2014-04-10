//
//  MyReplyVC.h
//  huabo
//
//  Created by admin on 14-4-8.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"

@interface MyReplyVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _needCache;
    NSInteger _maxID;
    BOOL _isLoadMore;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;



@property (retain,nonatomic) NSMutableArray *arrData;

@property (retain,nonatomic) NSString *strOfUrl;
@end

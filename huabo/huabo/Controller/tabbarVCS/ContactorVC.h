//
//  ContactorVC.h
//  huabo
//
//  Created by admin on 14-3-19.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"

@interface ContactorVC : BaseViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _allFlag;
}
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchVC;
@property (strong, nonatomic) IBOutlet UISearchBar *sBar;
@property (strong, nonatomic) IBOutlet UITableView *tView;


@property (retain,nonatomic) NSMutableArray *arrData;
@property (retain,nonatomic) NSMutableArray *searchData;

@property (retain,nonatomic) NSMutableArray *nameArr;
@property (retain,nonatomic) NSMutableArray *phoneArr;
@end

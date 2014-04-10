//
//  DetailVC.h
//  huabo
//
//  Created by admin on 14-3-21.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "PopupListComponent.h"
#import "MBProgressHUD.h"
@class WeiboModel;
@class TrendsView;
@class ClickableUILabel;

@interface DetailVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,PopupListComponentDelegate,MBProgressHUDDelegate>
{
    TrendsView *_weiboView;
    
    ClickableUILabel *_zan;
    
    ClickableUILabel *pl;
    ClickableUILabel *zf;
    PopupListComponent *_popupList;
    NSMutableArray  *_popArray;
    
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UIView *userBarView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain,nonatomic) WeiboModel *model;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *labelName;

@property (retain,nonatomic) NSMutableArray *arrData;
@end

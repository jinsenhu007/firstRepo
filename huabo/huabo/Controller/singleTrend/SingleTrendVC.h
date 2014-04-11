//
//  SingleTrendVC.h
//  huabo
//
//  Created by admin on 14-4-10.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "ClickableUIImageView.h"
#import "WeiboModel.h"
@class ClickableUILabel;
@class TrendsView;
@interface SingleTrendVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    WeiboModel *wModel;
    TrendsView *_trendsView;
    
    ClickableUILabel *_zan;
    
    ClickableUILabel *pl;
    ClickableUILabel *zf;
    
    BOOL _hasParseComment;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) NSMutableArray *arrData;

@property (retain,nonatomic) NSString *strOfUrl;
@property (strong, nonatomic) IBOutlet UIView *tHeaderView;
@property (strong, nonatomic) IBOutlet ClickableUIImageView *headIcon;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *subTime;
@property (strong, nonatomic) IBOutlet UILabel *msgSource;


@end

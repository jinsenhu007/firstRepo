//
//  AtMeViewController.h
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
@class clickableUIView;
@interface MsgVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    clickableUIView *_reply;
    clickableUIView *_group;
    clickableUIView *_sysMsg;
}
@property (strong, nonatomic) IBOutlet UIView *tHeaderBGView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (retain,nonatomic) NSMutableArray *arrData;
@end

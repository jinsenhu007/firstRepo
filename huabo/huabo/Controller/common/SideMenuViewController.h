//
//  SideMenuViewController.h
//  huabo
//
//  Created by admin on 14-2-26.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableUIImageView.h"
@interface SideMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //header view
    UIImageView *_headIcon;
    UILabel *_labelName;
}

@property (retain,nonatomic) NSArray *arrData;
@end

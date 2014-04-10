//
//  GroupCell.h
//  huabo
//
//  Created by admin on 14-3-24.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupModel;

@interface GroupCell : UITableViewCell
{
    UILabel *_name;
}

@property (retain,nonatomic) GroupModel *gModel;
@end

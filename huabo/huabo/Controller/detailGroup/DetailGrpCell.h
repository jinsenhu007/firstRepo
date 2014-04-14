//
//  DetailGrpCell.h
//  huabo
//
//  Created by admin on 14-4-14.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"

@interface DetailGrpCell : UITableViewCell
{
    UIImageView *_grpHead;
    UILabel *_nameLabel;
    UILabel *_creator;
}

@property (retain,nonatomic) DetailGrpModel *model;
@end

//
//  SysMsgCell.h
//  huabo
//
//  Created by admin on 14-4-10.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"
@class SysMsgModel;
@interface SysMsgCell : UITableViewCell<RCLabelDelegate>
{
    RCLabel *_content;
}

@property (retain,nonatomic) SysMsgModel *model;

+(CGFloat )getHeightWithModel:(SysMsgModel*)model;
@end

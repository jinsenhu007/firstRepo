//
//  AtMeCell.h
//  huabo
//
//  Created by admin on 14-4-9.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReplyModel;
@class ClickableUIImageView;
#import "RCLabel.h"

@interface AtMeCell : UITableViewCell<RCLabelDelegate>
{
    ClickableUIImageView *_headIcon;
    UILabel *_nameLabel;
    
    RCLabel *_content;
    RCLabel *_sourceContent;
}


@property (retain,nonatomic) ReplyModel *model;


+ (CGFloat)getCellHeightWithModel:(ReplyModel *)oneModel;
@end

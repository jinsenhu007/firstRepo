//
//  MyReplyCell.h
//  huabo
//
//  Created by admin on 14-4-8.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableUIImageView.h"
#import "RCLabel.h"
@class ReplyModel;
@interface MyReplyCell : UITableViewCell<RCLabelDelegate>
{
    ClickableUIImageView *_headIcon;
    UILabel *_labelName;
    UILabel *_subTime;
    
    
    RCLabel *_content;
    RCLabel *_sourceContent;
    
    UILabel *oneLabel;
}

@property (retain,nonatomic) ReplyModel *model;


+ (CGFloat)getCellHeightWithModel:(ReplyModel *)oneModel;
@end

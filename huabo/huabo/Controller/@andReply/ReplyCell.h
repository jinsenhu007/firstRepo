//
//  ReplyCell.h
//  huabo
//
//  Created by admin on 14-4-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyModel.h"
#import "RCLabel.h"
#import "ClickableUIImageView.h"
@interface ReplyCell : UITableViewCell<RCLabelDelegate>
{
    ClickableUIImageView *_targetHead;
    UILabel *_userName;
    UILabel *_subTime;
    
    RCLabel *_content;//消息内容
    RCLabel *_originalContent; //原始消息内容
}

@property (retain,nonatomic) ReplyModel *model;


+ (CGFloat)getCellHeightWithModel:(ReplyModel *)oneModel;
@end


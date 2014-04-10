//
//  CommentCell.h
//  huabo
//
//  Created by admin on 14-3-21.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"
@class ClickableUIImageView;
@class CommentModel;

@interface CommentCell : UITableViewCell<RCLabelDelegate>
{
    ClickableUIImageView *_headIcon;
    UILabel *_labelName;
    UILabel *_labelTime;
    
    RCLabel *_content;
}

@property (retain,nonatomic) CommentModel *cModel;


+ (float)getCommentHeight:(CommentModel *)cModel;
@end

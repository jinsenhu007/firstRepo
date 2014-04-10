//
//  ClickableUILabel.h
//  huabo
//
//  Created by admin on 14-3-21.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClickableUILabel;

typedef void (^action)(ClickableUILabel *label);

@interface ClickableUILabel : UILabel
{
    action _block;
}

- (void)handleClickEvent:(action)block;
@end

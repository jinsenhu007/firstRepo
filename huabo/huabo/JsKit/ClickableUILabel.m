//
//  ClickableUILabel.m
//  huabo
//
//  Created by admin on 14-3-21.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "ClickableUILabel.h"

@implementation ClickableUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)handleClickEvent:(action)block{
    _block = [block copy];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLabel:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)clickLabel:(id)sender{
    if (_block) {
        _block(sender);
    }
}



@end

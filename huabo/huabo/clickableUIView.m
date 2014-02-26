//
//  clickableUIView.m
//  LimitFree
//
//  Created by sensen on 13-12-19.
//  Copyright (c) 2013年 sensen. All rights reserved.
//

#import "clickableUIView.h"

@implementation clickableUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}


-(void)tapAct{
    if (_block) {
        _block(self);
    }
}

-(void)handleComplemetionBlock:(handleComleplement)block{
    _block = [block copy];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAct)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

@end

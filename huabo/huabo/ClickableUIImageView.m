//
//  ClickableUIImageView.m
//  LimitFree
//
//  Created by sensen on 13-12-18.
//  Copyright (c) 2013年 sensen. All rights reserved.
//

#import "ClickableUIImageView.h"

@implementation ClickableUIImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /*
         下面这句话在这里写则必须在初始化时候加上block属性
         */
        //[self addTarget:self withSelector:@selector(handle)];
        
        [self setUserInteractionEnabled:YES];
    }
    return self;
}



//使用函数方式
-(void)handleComplemetionBlock:(handleAction)block{
    _block = [block copy];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [tap addTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];

}
-(void)tapAction{
    if (_block) {
        _block(self);
    }
    
}


@end

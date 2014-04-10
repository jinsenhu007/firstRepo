//
//  JsBtn.m
//  huabo
//
//  Created by admin on 14-3-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "JsBtn.h"
#import "WeiboModel.h"
#import "UIImage+imageNamed_JSen.h"

@implementation JsBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _btn = [[[NSBundle mainBundle]loadNibNamed:@"JsBtn" owner:self options:nil]lastObject];
       
        [self addSubview:_btn];
    }
    return self;
}


-(void)JsHandleAction:(actionBlock)block {
    _block = [block copy];
    [_btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnPress:(id)sender{
    if (_block) {
        _block(self);
    }
}

- (void)JsSetImageWithName:(NSString *)name label:(NSString *)text{
    self.iconView.image = [UIImage JSenImageNamed:name];
    self.labelTxt.text = text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

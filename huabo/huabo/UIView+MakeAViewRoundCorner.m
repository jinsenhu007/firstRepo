//
//  UIView+MakeAViewRoundCorner.m
//  LimitFree
//
//  Created by sensen on 13-12-22.
//  Copyright (c) 2013年 sensen. All rights reserved.
//

#import "UIView+MakeAViewRoundCorner.h"

@implementation UIView (MakeAViewRoundCorner)


-(void)setRoundedCornerWithRadius:(CGFloat)f{
    self.layer.cornerRadius = f;
    self.layer.masksToBounds = YES;
}
@end

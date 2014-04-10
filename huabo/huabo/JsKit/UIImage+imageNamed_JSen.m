//
//  UIImage+imageNamed_JSen.m
//  huabo
//
//  Created by admin on 14-3-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "UIImage+imageNamed_JSen.h"

@implementation UIImage (imageNamed_JSen)
+ (UIImage *)JSenImageNamed:(NSString*)name{
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],name]];
}
@end

//
//  BaseViewController.h
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BaseViewController : UIViewController
-(void)showTitle:(NSString *)title;

-(void)showLeftButton:(NSString*)str target:(id)target action:(SEL)sel;
-(void)showRightButton:(NSString *)str target:(id)target action:(SEL)sel;
//返回键
-(void)showBackButton:(NSString*)str withImage:(UIImage *)image target:(id)target action:(SEL)sel;

//------------下面是本项目-------------
-(void)showLeftButtonWithImageName:(NSString *)name target:(id)target action:(SEL)sel;
-(void)showRightButtonWithImageName:(NSString*)name target:(id)target action:(SEL)sel;
@end

//
//  JsBtn.h
//  huabo
//
//  Created by admin on 14-3-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeiboModel;
@class JsBtn;
typedef void(^actionBlock)(JsBtn*);

@interface JsBtn : UIButton
{
    actionBlock _block;
    UIButton *_btn;
}
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *labelTxt;

- (void)JsSetImageWithName:(NSString *)name label:(NSString *)text;
- (void)JsHandleAction:(actionBlock)block;
@end

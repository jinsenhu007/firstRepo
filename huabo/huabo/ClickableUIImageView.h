//
//  ClickableUIImageView.h
//  LimitFree
//
//  Created by sensen on 13-12-18.
//  Copyright (c) 2013年 sensen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClickableUIImageView;
typedef  void(^handleAction)(ClickableUIImageView*);

@interface ClickableUIImageView : UIImageView
{
    handleAction _block;
}

//使用函数方式
-(void)handleComplemetionBlock:(handleAction)block;


@end

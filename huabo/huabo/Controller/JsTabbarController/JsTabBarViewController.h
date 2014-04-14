//
//  JsTabBarViewController.h
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kController @"Controller"
#define kTitle @"Title"
#define kImageName @"ImageName"


@interface JsTabBarViewController : UITabBarController
{
    NSInteger _atAndReplyCnt;   //回复，提到我的总数量
    NSInteger _sysMsgCnt;   //系统消息数量
}
@end

//
//  TrendsView.h
//  huabo
//
//  Created by admin on 14-3-10.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableUIImageView.h"
#import "WeiboModel.h"
#import "JsDevice.h"
#import "RCLabel.h"



@interface TrendsView : UIView<RCLabelDelegate,RCLabelSizeDelegate>
{
    RCLabel *_textLabel;            //微博内容
    ClickableUIImageView *_iView;   //微博图片
    TrendsView *_repostView;        //zhuan fa
    UIImageView *_repostBGView;     //转发的微博视图背景
    
    ClickableUIImageView *iViewDocs;
}
//微博模型对象
@property (retain,nonatomic) WeiboModel *model;
//当前的微博试图，是否是转发的
@property (nonatomic,assign) BOOL isTransfer;
//是否显示在微博详情界面
@property (nonatomic,assign) BOOL isDetail;

+ (float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost;

+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel isRepost:(BOOL)isRepost isDetail:(BOOL)isDetail;
@end

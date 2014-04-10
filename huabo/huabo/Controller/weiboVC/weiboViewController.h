//
//  weiboViewController.h
//  huabo
//
//  Created by admin on 14-3-3.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "QCheckBox.h"
#import "WeiboModel.h"


@class FaceViewController;
@class PicVC;
//@class WeiboModel;
@interface WeiboViewController : BaseViewController<UITextViewDelegate>
{
    UITextView *_tView;
    UIToolbar *_tBar;
    UIView *_upTBar;//toolbar上面的view
    
    
    FaceViewController *_face;
    UIView *_faceView;
    BOOL _isFaceView;
    
    PicVC *_picVC;
    UIView *_picView;
    
    QCheckBox *_checkBox;
    
    NSInteger _devideType; //消息分类类型1：普通消息；2：图片
    
    
    NSMutableArray *_arrAttachId;//存储发送图片返回来得AttachmentID
    NSInteger _sendObjectType;  //发布对象类型（1：所有人(管理员)；2：所有粉丝(default)；4仅自己；8：发送至群组；16：所有粉丝和群组）
    NSInteger _comeFromType;    //消息来源（1：网页端；2：Android手机端；4：IOS手机端(default)；8：PC客户端）
    NSMutableString *_groupStrings; //群组字符串集合 例如: 1-软件测试组|4-研发组 有群组消息不能为空
    NSMutableString *_groupIDs;
    NSString *_attachmentIDStrings; //附件编号字符串集合  例如：1,2
    
    NSMutableString *_atUserIDStrings; //@用户编号字符串集合 例如：1,2

    CommentType _commType;  //评论类型
}

//回复和转发时用得
@property (assign,nonatomic) CommentType commType;  //1.评论源消息 2.回复回复者的消息 3.转发源消息 4.转发转发者的消息  ()

@property (retain,nonatomic) WeiboModel *model;
@property (retain,nonatomic) CommentModel *commModel;// 评论
@end

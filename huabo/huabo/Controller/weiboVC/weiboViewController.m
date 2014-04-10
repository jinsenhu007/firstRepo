//
//  weiboViewController.m
//  huabo
//
//  Created by admin on 14-3-3.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "WeiboViewController.h"
#import "JsDevice.h"
#import "UIViewExt.h"
#import "factory.h"
#import "FaceViewController.h"
#import "PicVC.h"
#import "Const.h"
#import "jsHttpHandler.h"
#import "UIImage+imageNamed_JSen.h"
#import "ClickableUILabel.h"
#import "DetailVC.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "ClickableUIImageView.h"
#import "MMProgressHUD.h"
#import "AtUsersVC.h"
#import "MyGroupVC.h"
#import "GroupModel.h"

#define TOOL_BAR_HEIGHT 40
#define kAbove_tBar_view_height 30

@interface WeiboViewController ()

@end

@implementation WeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)_fillUpTBar{
    _checkBox = [[QCheckBox alloc]initWithDelegate:self];
    _checkBox.frame = CGRectMake(8, 5, 150, 20);
    //[_checkBox setTitle:self.title forState:UIControlStateNormal];
    [_checkBox.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_checkBox setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    NSLog(@"self.title %@",self.title);
    if (![self.title isEqualToString:@"新建"]) {
        [_upTBar addSubview:_checkBox];
    }
    if ([self.title isEqualToString:@"回复"]){
        [_checkBox setTitle:@"转发到我的微博" forState:UIControlStateNormal];
    }
    if ([self.title isEqualToString:@"转发"]){
        [_checkBox setTitle:@"同时回复该动态" forState:UIControlStateNormal];
    }
    
    UIImageView *eyeView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-120, 5, 20, 20)];
    eyeView.image = [UIImage JSenImageNamed:@"眼睛未选中.png"];
    [_upTBar addSubview:eyeView];
    
    ClickableUILabel *label = [[ClickableUILabel alloc]initWithFrame:CGRectMake(eyeView.right+5, eyeView.top, 90, 20)];
    label.text = @"所有用户";
    label.font = SysFont(13);
    label.textColor = [UIColor darkGrayColor];
    //label.textAlignment = NSTextAlignmentCenter;
    [_upTBar addSubview:label];
    
    //点击文字或眼睛切换到群组
    [label handleClickEvent:^(ClickableUILabel *label) {
        MyGroupVC *group = [[MyGroupVC alloc]init];
        group.block = ^(NSArray *array){
            [self processArray:array label:label];
        };
        [self.navigationController pushViewController:group animated:YES];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrAttachId = [NSMutableArray array];
    _comeFromType = 4;
    _groupStrings = [NSMutableString string];
    _atUserIDStrings = [NSMutableString string];
    _groupIDs = [NSMutableString string];
    _sendObjectType = 2; //2：所有粉丝(default)
    _attachmentIDStrings = [NSMutableString string];
    
 //   [self showBackBtnTitle:@"返回" target:self action:@selector(pressBack:)];
    [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack:)];
   // [self showTitle:@"新建"];
    [self showRightButtonOfSureWithName:@"确定" target:self action:@selector(pressSure:)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShown:) name:UIKeyboardWillShowNotification
      object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    _tBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, kScreenHeight-TOOL_BAR_HEIGHT,kScreenWidth , TOOL_BAR_HEIGHT)];
    NSLog(@"%f ",_tBar.frame.origin.y);
    _tBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2_03.png"]];
   // [_tBar setBarStyle: UIBarStyleBlackOpaque];
    
    //[_tBar setTranslucent:NO];
    [self.view addSubview:_tBar];
    _upTBar = [[UIView alloc]initWithFrame:CGRectMake(0,_tBar.frame.origin.y-kAbove_tBar_view_height , kScreenWidth, kAbove_tBar_view_height)];
    _upTBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2_03.png"]];
    [self _fillUpTBar];
    [self.view addSubview:_upTBar];

    CGRect rect = CGRectMake(0, 0, 30, 35);
    UIButton *btnAt = [factory createButtonFrame:rect image:@"compose_mentionbutton_background.png" selectImage:@"compose_mentionbutton_background_highlighted.png" target:self action:@selector(btnAt:)];
    UIBarButtonItem *btnAtItem = [[UIBarButtonItem alloc]initWithCustomView:btnAt];
    
    UIButton *btnFace = [factory createButtonFrame:rect image:@"添加表情未选中.png" selectImage:@"添加表情.png" target:self action:@selector(btnFace:)];
    UIBarButtonItem *btnFaceItem = [[UIBarButtonItem alloc]initWithCustomView:btnFace];
    
    UIButton *btnPic = [factory createButtonFrame:rect image:@"添加图片未选中.png" selectImage:@"添加图片.png" target:self action:@selector(btnPic:)];
    UIBarButtonItem *btnPicItem = [[UIBarButtonItem alloc]initWithCustomView:btnPic];
    
    UIButton *btnKeyBoard = [factory createButtonFrame:rect image:@"compose_keyboardbutton_background.png" selectImage:@"compose_keyboardbutton_background_highlighted.png" target:self action:@selector(btnKeyBoard:)];
    UIBarButtonItem *btnKeyBoardItem = [[UIBarButtonItem alloc]initWithCustomView:btnKeyBoard];
    
    NSArray *arr = @[btnAtItem,btnFaceItem,btnPicItem,btnKeyBoardItem];
    [_tBar setItems:arr];
    
    _tView = [[UITextView alloc]initWithFrame:CGRECT_HAVE_NAV(0, 0, kScreenWidth, kScreenHeight-TOOL_BAR_HEIGHT-kAbove_tBar_view_height-64)];
    NSLog(@"%f %f",_tView.frame.origin.y,_tView.size.height);
    //_tView.backgroundColor = [UIColor blueColor];
    [self.view addSubview: _tView];
    
    
    
    _face = [[FaceViewController alloc]init];
    _faceView = _face.view;
    _isFaceView = NO;
    [_face handleSelectBlock:^(NSString* str) {
        NSLog(@"n %@",str);
        [self insertString:str intoTextView:_tView];
    }];
	
    _picVC = [[PicVC alloc]init];
    _picView = _picVC.view;
    
}
//向textView插入字符。。
- (void) insertString: (NSString *) insertingString intoTextView: (UITextView *) textView
{
    NSRange range = textView.selectedRange;
    NSString * firstHalfString = [textView.text substringToIndex:range.location];
    NSString * secondHalfString = [textView.text substringFromIndex: range.location];
    textView.scrollEnabled = NO;  // turn off scrolling or you'll get dizzy ... I promise
    
    textView.text = [NSString stringWithFormat: @"%@%@%@",
                     firstHalfString,
                     insertingString,
                     secondHalfString];
    range.location += [insertingString length];
    textView.selectedRange = range;
    textView.scrollEnabled = YES;  // turn scrolling back on.
    
}

#pragma mark - keyboard action
- (void)keyBoardShown:(NSNotification *)noti{
    NSDictionary *info = [noti userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //键盘尺寸
    CGSize keyBoardSize = [value CGRectValue].size;
    //键盘弹出动画时间
    NSValue *animatDur = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animatDuration;
    [animatDur getValue:&animatDuration];

    
    [UIView animateWithDuration:animatDuration animations:^{
        
        
        //中文输入
        if (keyBoardSize.height == 252) {
            CGRect f = _tBar.frame;
            CGRect new = CGRectMake(f.origin.x,kScreenHeight-252-TOOL_BAR_HEIGHT,kScreenWidth,TOOL_BAR_HEIGHT );
            CGRect new02 = CGRectMake(f.origin.x, new.origin.y-kAbove_tBar_view_height, kScreenWidth, kAbove_tBar_view_height);
            _upTBar.frame = new02;
            _tBar.frame = new;
            //textView height
            _tView.frame = CGRECT_HAVE_NAV(0, 0, kScreenWidth, kScreenHeight-64-252-TOOL_BAR_HEIGHT-kAbove_tBar_view_height);
        }else if (keyBoardSize.height == 216){
        //英文输入
            //设置toolbar的frame
          CGRect f = _tBar.frame;
          CGRect new =  CGRectMake(f.origin.x,kScreenHeight-216-TOOL_BAR_HEIGHT , kScreenWidth, TOOL_BAR_HEIGHT);
            CGRect new02 = CGRectMake(f.origin.x, new.origin.y-kAbove_tBar_view_height, kScreenWidth, kAbove_tBar_view_height);
            _upTBar.frame = new02 ;
            [_tBar setFrame:new];
            //_tView height
            _tView.frame = CGRECT_HAVE_NAV(0, 0, kScreenWidth, kScreenHeight-64-216-TOOL_BAR_HEIGHT-kAbove_tBar_view_height);
        }
        
    }];
    
}
- (void)keyBoardHidden:(NSNotification*)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *animatDur = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration ;
    [animatDur getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
//        CGRect  f = _tBar.frame;
//        f.origin.y = kScreenHeight-TOOL_BAR_HEIGHT;
//        [_tBar setFrame:f];
        [_upTBar setFrame:CGRectMake(0,kScreenHeight-TOOL_BAR_HEIGHT-kAbove_tBar_view_height , kScreenWidth, kAbove_tBar_view_height)];
        [_tBar setFrame:CGRectMake(0, kScreenHeight-TOOL_BAR_HEIGHT,kScreenWidth , TOOL_BAR_HEIGHT)];
        
        CGRect m = _tView.frame;
        m.size.height = kScreenHeight-TOOL_BAR_HEIGHT-64-kAbove_tBar_view_height;
        [_tView setFrame:m];
    }];
}

-(void)pressBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发微博
//发微博
- (void)pressSure:(id)sender{
    [_arrAttachId removeAllObjects];
    //没有文字不发送
    if ([_tView.text isEqualToString:@""] || _tView.text == nil) return;
    
    //有无图片
    if ([self _hasImage]) {
        //图片发送完成后发送文字信息
        _devideType = 2;
        [self _dealWithImage];
    }else{
        //直接发送文字信息
        _devideType = 1;
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithStatus:@"发送中..."];
        NSLog(@"_commType %d",_commType);
        if (_commType == CommentSource) {
            [self _commentSourceMsg];
        }else if (_commType == Comment_Comment){
            [self _commentCommentMsg];      //
        }else if (_commType == TransferSource){
            [self _transferSourceMsg];
        }else if (_commType == Transfer_Transfer){
            [self _transferTransferMsg];
        }else{
            [self _publishMsgWithAtts];
        }
        
        
    }
    
  //
    
    
}

- (BOOL)_hasImage{
    int i= 0;
        for (UIView *view in _picVC.bgView.subviews) {
        if ([view isKindOfClass:[ClickableUIImageView class]] ) {
            ClickableUIImageView *iView = (ClickableUIImageView *)view;
            if (iView.image) {
                i++;
            }
            
        }
    }
    return i > 0 ? YES : NO;

}

- (void)_dealWithImage{
    NSMutableArray *arr = [NSMutableArray array];
   
    for (UIView *view in _picVC.bgView.subviews) {
        if ([view isKindOfClass:[ClickableUIImageView class]] ) {
            ClickableUIImageView *iView = (ClickableUIImageView *)view;
            if (iView.image) {
               [arr addObject:iView.image];
            }
           
        }
    }
    
    if (arr.count) {
        //发送图片
        for (UIImage *image in arr) {
            [self _sendImage:image imageCount:arr.count];
        }
    }
}

#pragma mark - send picture
//- (NSData *) _getImageData:(NSString *)img{
//    UIImage *image = [UIImage imageNamed:img];
//    NSData *data = UIImagePNGRepresentation(image);
//    return data;
//}

- (void) _sendImage:(UIImage *)image imageCount:(NSInteger)count{
    if (![JsDevice netOK]) return;
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"发送中..."];
    NSURL *url = [NSURL URLWithString:kUploadImageUrl];
   
    NSLog(@"%@",kUploadImageUrl);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.shouldContinueWhenAppEntersBackground = YES;
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    [request addPostValue:model.Token forKey:@"token"];
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
  //  NSData *data = [self _getImageData:@"weibolist_pic.png"];
    [request addData:data withFileName:@"oneImage.jpg" andContentType:@"image/jpg" forKey:@"fileData"];
    [request startAsynchronous];
    
   
    __weak ASIFormDataRequest *weak = request;
    [request setCompletionBlock:^{
        NSError *err = nil;
        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:weak.responseData options:NSJSONReadingMutableContainers error:&err];
        if (err) {
            NSLog(@"发送图片错误%@",err);
            [MMProgressHUD dismissWithError:@"发送失败"];
            return ;
        }
        NSString *status = [dic objectForKey:@"Status"];
        if ([status isEqualToString:@"ok"]) {
            NSNumber *num = [dic objectForKey:@"AttachmentID"];
            [_arrAttachId addObject:num];
        }
        
        if (_arrAttachId.count == count) {
            //图片发送完毕
            _attachmentIDStrings = [self _getAttachmentIDStringsWithArray:_arrAttachId];
            NSLog(@"---%@",_attachmentIDStrings);
            ////------------------这里区分不同操作-----------------------
            if ([self.title isEqualToString:@"新建"]) {
                [self _publishMsgWithAtts];
            }else if ([self.title isEqualToString:@"回复"]){
                if (_commType == CommentSource) {
                    [self _commentSourceMsg];
                }else if (_commType == Comment_Comment){
                    [self _commentCommentMsg];
                }
            }else if ([self.title isEqualToString:@"转发"]){
                if (_commType == TransferSource) {
                    [self _transferSourceMsg];
                }else if (_commType == Transfer_Transfer){
                    [self _transferTransferMsg];
                }
            }
        }
        
    }];
}


- (void)_publishMsgWithAtts{
    if (![JsDevice netOK]) return;
    
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_tView.text forKey:@"messageContent"];
    [dic setObject:model.Token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInteger:_sendObjectType] forKey:@"sendObjectType"];
    [dic setObject:[NSNumber numberWithInteger:_devideType] forKey:@"divideType"];
    [dic setObject:[NSNumber numberWithInteger:_comeFromType] forKey:@"comeFromType"];//固定不变的
    [dic setObject:_groupStrings forKey:@"groupStrings"];
    [dic setObject:_groupIDs forKey:@"groupIDs"];
    [dic setObject:_atUserIDStrings forKey:@"atUserIDStrings"];
    [dic setObject:_attachmentIDStrings forKey:@"attachmentIDStrings"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"attachmentCanDownload"];//手机端上传的不能下载
    
    [jsHttpHandler JsHttpPostWithStrOfUrl:kPublishUrl paraDict:dic completionBlock:^(id JSON) {
      //  NSLog(@"+++%@",JSON);
        int success = [[JSON objectForKey:@"Success"] intValue];
        if (!JSON || !success) {
            
            [MMProgressHUD dismissWithError:@"发送失败，未收到响应"];
        }
        if (success == 1) {
           
            [MMProgressHUD dismissWithSuccess:@"发送成功"];
            dispatch_sync(dispatch_queue_create("myQueue", nil), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    
}

- (NSString *)_getAttachmentIDStringsWithArray:(NSMutableArray*)arr{
    NSMutableString *str = [NSMutableString string];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,",obj];
    }];
    return [str copy];
}


#pragma mark - 回复消息

- (void)_commentSourceMsg{
     if (![JsDevice netOK]) return;
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_tView.text forKey:@"commentMessageContent"];
    [dic setObject:model.Token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInteger:_devideType] forKey:@"divideType"];
    [dic setObject:[NSNumber numberWithInteger:_comeFromType] forKey:@"comeFromType"];//固定不变的
    [dic setObject:_groupStrings forKey:@"groupStrings"];
    [dic setObject:_groupIDs forKey:@"groupIDs"];
    [dic setObject:_atUserIDStrings forKey:@"atUserIDStrings"];
    [dic setObject:_attachmentIDStrings forKey:@"attachmentIDStrings"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"attachmentCanDownload"];//手机端上传的不能下载
    
    //评论源消息
    [dic setObject:self.model.msgInfo.ID  forKey:@"originalMessageID"];
    [dic setObject:self.model.UserInfoID forKey:@"originalUserID"];
    
    [self _sendCommentWithUrl:kCommentSourceUrl dict:dic ];
}

- (void)_sendCommentWithUrl:(NSString *)str dict:(NSDictionary *)dic{
    [MMProgressHUD showWithStatus:@"发送中..."];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [jsHttpHandler JsHttpPostWithStrOfUrl:str paraDict:dic completionBlock:^(id JSON) {
          //NSLog(@"******%@",JSON);
        int success = [[JSON objectForKey:@"Success"] intValue];
        if (!JSON || !success) {
            
            [MMProgressHUD dismissWithError:@"发送失败，未收到响应"];
        }
        if (success == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"commentSuccess" object:nil];
            //
#pragma warn ------因为有转发 这里可能有一些问题 未改
            [MMProgressHUD dismissWithSuccess:@"发送成功"];
            self.model.MessageCommentTotalCount = [NSNumber numberWithInteger:[self.model.MessageCommentTotalCount integerValue]+1];
            
            //同时转发到我的微博
            if (_checkBox.checked) {
                [self _transferSourceMsg];
            }else{
                dispatch_sync(dispatch_queue_create("myQueue", nil), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    }];
}

- (void)_commentCommentMsg{
    if (![JsDevice netOK]) return;
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_tView.text forKey:@"commentMessageContent"];
    [dic setObject:model.Token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInteger:_devideType] forKey:@"divideType"];
    [dic setObject:[NSNumber numberWithInteger:_comeFromType] forKey:@"comeFromType"];//固定不变的
    [dic setObject:_groupStrings forKey:@"groupStrings"];
    [dic setObject:_groupIDs forKey:@"groupIDs"];
    [dic setObject:_atUserIDStrings forKey:@"atUserIDStrings"];
    [dic setObject:_attachmentIDStrings forKey:@"attachmentIDStrings"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"attachmentCanDownload"];//手机端上传的不能下载
    
    //
    [dic setObject:self.model.UserInfoID forKey:@"originalUserID"];
    [dic setObject:self.model.msgInfo.ID forKey:@"originalMessageID"];
    [dic setObject:self.commModel.targetInfo.UserInfoID forKey:@"sourceUserID"];
    [dic setObject:self.commModel.targetInfo.msgInfo.ID forKey:@"sourceMessageID"];
    
    [self _sendCommentWithUrl:kCommentCommenterUrl dict:dic];
}


#pragma mark - 转发消息

- (void)_transferSourceMsg{
    if (![JsDevice netOK]) return;
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_tView.text forKey:@"transferMessageContent"];
    [dic setObject:[NSNumber numberWithInteger:_sendObjectType] forKey:@"sendObjectType"];
    [dic setObject:model.Token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInteger:_devideType] forKey:@"divideType"];
    [dic setObject:[NSNumber numberWithInteger:_comeFromType] forKey:@"comeFromType"];//固定不变的
    [dic setObject:_groupStrings forKey:@"groupStrings"];
    [dic setObject:_groupIDs forKey:@"groupIDs"];
    [dic setObject:_atUserIDStrings forKey:@"atUserIDStrings"];
    [dic setObject:_attachmentIDStrings forKey:@"attachmentIDStrings"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"attachmentCanDownload"];//手机端上传的不能下载
    
    //
    [dic setObject:_model.UserInfoID forKey:@"originalUserID"];
    [dic setObject:_model.msgInfo.ID forKey:@"originalMessageID"];
    
    NSNumber *isReply = [NSNumber numberWithBool:_checkBox.checked];
    [dic setObject:isReply forKey:@"commentToOriginalCreater"];
    
    
    [self _sendTransferWithUrl:kTransferSourceUrl dict:dic];
}

- (void)_sendTransferWithUrl:(NSString *)str dict:(NSDictionary *)dic{
    [MMProgressHUD showWithStatus:@"发送中..."];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [jsHttpHandler JsHttpPostWithStrOfUrl:str paraDict:dic completionBlock:^(id JSON) {
       // NSLog(@"******%@",JSON);
        int success = [[JSON objectForKey:@"Success"] intValue];
        if (!JSON || !success) {
            
            [MMProgressHUD dismissWithError:@"发送失败，未收到响应"];
        }
        if (success == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"commentSuccess" object:nil];
            [MMProgressHUD dismissWithSuccess:@"发送成功"];
            self.model.MessageTransferTotalCount = [NSNumber numberWithInteger:[self.model.MessageTransferTotalCount integerValue]+1];
            dispatch_sync(dispatch_queue_create("myQueue", nil), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];

}

- (void)_transferTransferMsg{
    if (![JsDevice netOK]) return;
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_tView.text forKey:@"transferMessageContent"];
    [dic setObject:[NSNumber numberWithInteger:_sendObjectType] forKey:@"sendObjectType"];
    [dic setObject:model.Token forKey:@"token"];
    [dic setObject:[NSNumber numberWithInteger:_devideType] forKey:@"divideType"];
    [dic setObject:[NSNumber numberWithInteger:_comeFromType] forKey:@"comeFromType"];//固定不变的
    [dic setObject:_groupStrings forKey:@"groupStrings"];
    [dic setObject:_groupIDs forKey:@"groupIDs"];
    [dic setObject:_atUserIDStrings forKey:@"atUserIDStrings"];
    [dic setObject:_attachmentIDStrings forKey:@"attachmentIDStrings"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"attachmentCanDownload"];//手机端上传的不能下载
    
    //
    [dic setObject:_model.transInfo.tModel.UserInfoID forKey:@"originalUserID"];
    [dic setObject:_model.transInfo.tModel.msgInfo.ID forKey:@"originalMessageID"];
    [dic setObject:_model.UserInfoID forKey:@"sourceUserID"];
    [dic setObject:_model.msgInfo.ID forKey:@"sourceMessageID"];
    
    NSNumber *isReply = [NSNumber numberWithBool:_checkBox.checked];
    [dic setObject:isReply forKey:@"commentToOriginalCreater"]; // 评论给初始消息创建者
    [dic setObject:isReply forKey:@"commentToTransfer"];
    [self _sendTransferWithUrl:kTransfer_transferUrl dict:dic];
    
}
#pragma mark - toolbar item pressed


- (void)btnAt:(id)sender{
    AtUsersVC *at = [[AtUsersVC alloc]init];
    NSLock *lock = [[NSLock alloc]init];
    
    [at setBlock:^(NSArray *array){
        [lock lock];
        NSMutableString *str = [NSMutableString string];
        NSMutableString *strInTextView = [NSMutableString new];
        for (UserModel *model in array) {
            [str appendFormat:@"%d,",model.ID];
            [strInTextView appendFormat:@"|@%@|",model.RealName];
            
        }
        _atUserIDStrings = [NSMutableString stringWithString:str];
        //  NSLog(@"_atUserIDStrings %@",_atUserIDStrings);
        [_tView insertText:strInTextView];
        [lock unlock];
    }];
   
    [self.navigationController pushViewController:at animated:YES];
    
}

- (void)btnFace:(id)sender{
   
    if (_isFaceView == NO) {
        _tView.inputView = _faceView;
        [_tView reloadInputViews];
        [_tView becomeFirstResponder];
        _isFaceView = YES;
    }else if (_isFaceView == YES){
        _tView.inputView = nil;
        [_tView reloadInputViews];
        [_tView becomeFirstResponder];
        _isFaceView = NO;
    }
}

- (void)btnPic:(id)sender{
   
    _tView.inputView = _picView;
    [_tView reloadInputViews];
    [_tView becomeFirstResponder];
}


- (void)btnKeyBoard:(id)sender{
    
}

#pragma mark - 处理传来群组数组
- (void)processArray:(NSArray*)array label:(ClickableUILabel *)label{
    
    //发布对象类型（1：所有人(管理员)；2：所有粉丝；4仅自己；8：发送至群组；16：所有粉丝和群组
    //只有管理员或网主能发送到所有人
    for (int i= 0; i < array.count; i++) {
        GroupModel *g = [array objectAtIndex:i];
        
        if ([g.GroupName isEqualToString:@"所有人"]) {
            _sendObjectType = 1;
           // label.text = @"所有人";
            break;
        }
        if ([g.GroupName isEqualToString:@"所有粉丝"]) {
            for (int j= i+1; j < array.count; j++) {
                GroupModel *jModel = [array objectAtIndex:j];
                if (![jModel.GroupName isEqualToString:@"仅自己"]) {
                    _sendObjectType = 16;
                    [self _generateGroupStringsAndGroupIDs:array];
                    return;
                }
               //  同时选择所有粉丝，和仅自己
                
            }
            
            _sendObjectType = 2;
            break;
        }
        if ([g.GroupName isEqualToString:@"仅自己"]) {
            _sendObjectType = 4;
            break;
        }
        //没有选中以上几项，则默认
        
            _sendObjectType = 8;
            [self _generateGroupStringsAndGroupIDs:array];
        
        
        
    }
}
// groupIds groupStrings
- (void)_generateGroupStringsAndGroupIDs:(NSArray *)array{
    
    NSMutableString *gStr = [NSMutableString new];
    NSMutableString *gIDStr = [NSMutableString new];
    
    for (int i = 0; i< array.count; i++) {
        GroupModel *g = [array objectAtIndex:i];
        if ([g.GroupName isEqualToString:@"所有粉丝"] || [g.GroupName isEqualToString:@"仅自己"]) {
            continue;
        }
        NSString *s1 = [NSString stringWithFormat:@"%@-%@|",g.ID,g.GroupName];
        [gStr appendFormat:@"%@",s1];
        
        [gIDStr appendFormat:@"%@|",g.ID];
    }
    //如果只有一个则不用加|，有多个则只在中间加  一句话 ：去掉末尾的|
    
    NSRange range = [gStr rangeOfString:@"|" options:NSBackwardsSearch];
    NSRange range02 = [gIDStr rangeOfString:@"|" options:NSBackwardsSearch];
    [gStr replaceCharactersInRange:range withString:@""];
    [gIDStr replaceCharactersInRange:range02 withString:@""];
    
    
    
   
    
    _groupStrings = [NSMutableString stringWithString:gStr];
    _groupIDs = [NSMutableString stringWithString:gIDStr];
    
    //NSLog(@"group %@ %@",gStr,gIDStr);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  secFooter.m
//  huabo
//
//  Created by admin on 14-3-17.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "SecFooter.h"
#import "UIImage+imageNamed_JSen.h"
#import "jsHttpHandler.h"
#import "Const.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "weiboViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"

@implementation SecFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bgView = [[[NSBundle mainBundle]loadNibNamed:@"SecFooter" owner:self options:nil]lastObject];
        [self addSubview:_bgView];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(like:) name:@"likeSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlike:) name:@"unlikeSuccess" object:nil];
    }
    return self;
}

- (void)like:(NSNotification *)noti{

    NSString *zanCnt = [NSString stringWithFormat:@"%@",_model.MessageLikeTotalCount];
    self.label03.text = zanCnt;
    self.img03.image = [UIImage JSenImageNamed:@"赞.png"];
    
}

-(void)unlike:(NSNotification *)noti{
    NSString *zanCnt = [NSString stringWithFormat:@"%@",_model.MessageLikeTotalCount];
    self.label03.text = zanCnt;
    self.img03.image = [UIImage JSenImageNamed:@"赞未选中.png"];
    
}

- (void)useModel:(WeiboModel*)model object:(id)obj{
    _model = model;
    _object = obj;
    NSString *rCount = [NSString stringWithFormat:@"%@",model.MessageTransferTotalCount];
    NSString *comCnt = [NSString stringWithFormat:@"%@",model.MessageCommentTotalCount];
    NSString *zanCnt = [NSString stringWithFormat:@"%@",model.MessageLikeTotalCount];
    
    // [footer.img01 JsSetImageWithName:@"转发未选中.png"  label: rCount];
    self.img01.image = [UIImage JSenImageNamed:@"转发未选中.png"];
    self.img02.image = [UIImage JSenImageNamed:@"评论未选中.png"];
    //LikeFlag暂时无用bug
    if (_model.LikeFlag ) {
        self.img03.image = [UIImage JSenImageNamed:@"赞.png"];
        
    }else{
    self.img03.image = [UIImage JSenImageNamed:@"赞未选中.png"];
        
    }
    
    self.label01.text = rCount;
    self.label02.text = comCnt;
    self.label03.text = zanCnt;
}



- (IBAction)zfAction:(UIButton *)sender {
    WeiboViewController *wc= [[WeiboViewController alloc]init];
    wc.title = @"转发";
    wc.model = _model;
    
    //有转发信息，则commType为转发转发者的消息
    if (wc.model.transInfo) {
        wc.commType = Transfer_Transfer;
    }else{
        //没有转发消息，则commType为转发源消息
        wc.commType = TransferSource;
    }
    
    UIViewController *vc = [self _getMainVC];
    [vc.navigationController pushViewController:wc animated:YES];
    
}
- (IBAction)plAction:(UIButton *)sender {
    WeiboViewController *wc= [[WeiboViewController alloc]init];
    wc.title = @"回复";
    wc.model = _model;
    //从这个界面推出发微博的界面，则pl一定是评论源消息
    wc.commType = CommentSource;
    
    UIViewController *vc = [self _getMainVC];
    [vc.navigationController pushViewController:wc animated:YES];
}

- (IBAction)zanAction:(UIButton *)sender {
    UserModel *uM = [[UserMgr sharedInstance]readFromDisk];
    NSString *mId = [NSString stringWithFormat:@"%@",_model.msgInfo.ID];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uM.Token,@"token",mId,@"messageID", nil];
    //未赞
    if (_model.LikeFlag == 0)
    {
    
        [jsHttpHandler JsHttpPostWithStrOfUrl:kMsgLikeUrl paraDict:dict completionBlock:^(id JSON) {
            NSLog(@"zan %@",JSON);
            if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                NSLog(@"点赞成功");
                
                _model.LikeFlag = 1;
                NSInteger lc = [_model.MessageLikeTotalCount integerValue];
                _model.MessageLikeTotalCount = [NSNumber numberWithInteger:lc+1];
                self.label03.text = [NSString stringWithFormat:@"%d" ,[self.label03.text intValue] +1];
                self.img03.image = [UIImage JSenImageNamed:@"赞.png"];
            }else{
                NSLog(@"点赞失败");
               
            }
        }];
    }else{
       //已赞
    
        [jsHttpHandler JsHttpPostWithStrOfUrl:kMsgUnLikeUrl paraDict:dict completionBlock:^(id JSON) {
             NSLog(@"qu xiaozan %@",JSON);
            if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                NSLog(@"取消点赞成功");
                
                _model.LikeFlag = 0;
                NSInteger lc = [_model.MessageLikeTotalCount integerValue];
                _model.MessageLikeTotalCount = [NSNumber numberWithInteger:lc-1];
                 self.label03.text = [NSString stringWithFormat:@"%d" ,[self.label03.text intValue] -1];
                self.img03.image = [UIImage JSenImageNamed:@"赞未选中.png"];
            }else{
                NSLog(@"取消点赞失败");
                
            }
        }];
    }
}

- (UIViewController *)_getMainVC{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    UIWindow *win = del.window;
    DDMenuController *dd = (DDMenuController *)win.rootViewController;
    UITabBarController *tab = (UITabBarController *)dd.rootViewController;
    UINavigationController *nav = [tab.viewControllers objectAtIndex:0];
    return [nav topViewController];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

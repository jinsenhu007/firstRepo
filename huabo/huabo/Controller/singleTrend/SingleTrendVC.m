//
//  SingleTrendVC.m
//  huabo
//
//  Created by admin on 14-4-10.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "SingleTrendVC.h"
#import "CommentCell.h"
#import "WeiboModel.h"
#import "weiboViewController.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "MMProgressHUD.h"
#import "JsDevice.h"
#import "jsHttpHandler.h"
#import "UIImageView+WebCache.h"
#import "TrendsView.h"
#import "UIViewExt.h"
#import "ClickableUILabel.h"
#import "clickableUIView.h"
#import "UIImage+imageNamed_JSen.h"
#import "DDMenuController.h"
#import "JsTabBarViewController.h"
#import "JsBtn.h"
#import "AppDelegate.h"
#import "UIView+MakeAViewRoundCorner.h"

@interface SingleTrendVC ()

@end

@implementation SingleTrendVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initView];
    _arrData = [NSMutableArray new];
    _hasParseComment = NO;
    
     [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack)];
    if (_strOfUrl) {
        UserModel *m = [[UserMgr sharedInstance] readFromDisk];
        _strOfUrl = [NSString stringWithFormat:@"%@&token=%@",_strOfUrl,m.Token];
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithStatus:@"加载中..."];
        [self loadData];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_hasParseComment) {
        [self _loadComments];
    }
}

- (void)_initView{
//    self.tableView.tableHeaderView = self.tHeaderView;
    
}

- (void)_loadComments{
    if (![JsDevice netOK]) {
        return;
    }
     UserModel *m = [[UserMgr sharedInstance] readFromDisk];
    NSString *str = [NSString stringWithFormat:kCommentsUrl,wModel.msgInfo.ID,m.Token];
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:NO completionBlock:^(id JSON) {
        int total = [[JSON objectForKey:@"Total"] intValue];
        if (total == 0)  return ;
        [_arrData removeAllObjects];
        
         for (NSDictionary *dic  in [JSON objectForKey:@"Rows"]) {
             [self _parseCommentsWithDict:dic];
         }
        
        [self.tableView reloadData];
    }];
}

- (void)_parseCommentsWithDict:(NSDictionary *)replyDic{
    CommentModel *cM = [[CommentModel alloc ]init];
    cM.MessageRelationType = [[replyDic objectForKey:@"MessageRelationType"] integerValue];
    cM.SubTimeStr = [replyDic objectForKey:@"SubTimeStr"];
    
    //1：评论源消息；2：评论评论者的消息；
    if (cM.MessageRelationType == 1) {
        //只需解析TargetMessageInfo
        cM.targetInfo = [[SourceTargetMsgInfo alloc]init];
        NSDictionary *targetDic = [replyDic objectForKey:@"TargetMessageInfo"];
        
        [self _parseSourceTargetDicWithObject:cM.targetInfo dict:targetDic isTarget:YES];
        
        
    }else if (cM.MessageRelationType == 2){
        //需解析TargetMessageInfo & SourceMessageInfo
        cM.targetInfo = [[SourceTargetMsgInfo alloc]init];
        cM.sourceInfo = [[SourceTargetMsgInfo alloc]init];
        NSDictionary *targetDic = [replyDic objectForKey:@"TargetMessageInfo"];
        NSDictionary *sourceDic = [replyDic objectForKey:@"SourceMessageInfo"];
        [self _parseSourceTargetDicWithObject:cM.targetInfo dict:targetDic isTarget:YES];
        [self _parseSourceTargetDicWithObject:cM.sourceInfo dict:sourceDic isTarget:NO];
        cM.targetInfo.UserRealName = [NSString stringWithFormat:@"%@ 回复：%@",cM.targetInfo.UserRealName,cM.sourceInfo.UserRealName];
    }
    
    [_arrData addObject:cM];

}

- (void)loadData{
    if (![JsDevice netOK]) {
        return;
    }
    NSLog(@"%s,url %@",__FUNCTION__,_strOfUrl);
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:_strOfUrl withCache:YES completionBlock:^(id JSON) {
        if (!JSON) {
            [MMProgressHUD dismissWithError:@"没有返回数据" afterDelay:0.5f];
            return ;
        }
       
        [_arrData removeAllObjects];
        NSDictionary *dict = JSON;
            
            wModel = [[WeiboModel alloc]init];
            wModel.MessageIndexID = [dict objectForKey:@"MessageIndexID"];
            wModel.UserInfoID = [dict objectForKey:@"UserInfoID"];
            wModel.UserRealName = [dict objectForKey:@"UserRealName"];
            wModel.HeadSculpture48 = [dict objectForKey:@"HeadSculpture48"];
            wModel.Level = [dict objectForKey:@"Level"];
            wModel.MessageCommentTotalCount = [dict objectForKey:@"MessageCommentTotalCount"];
            wModel.MessageTransferTotalCount = [dict objectForKey:@"MessageTransferTotalCount"];
            wModel.MessageLikeTotalCount = [dict objectForKey:@"MessageLikeTotalCount"];
            wModel.MessageCollectTotalCount = [dict objectForKey:@"MessageCollectTotalCount"];
            //
            wModel.CollectFlag = [[dict objectForKey:@"CollectFlag"]intValue];
            wModel.IsMy = [[dict objectForKey:@"IsMy"]intValue];
            wModel.LikeFlag = [[dict objectForKey:@"LikeFlag"] intValue];
            // NSLog(@"LikeFlag %d",wModel.LikeFlag);
            wModel.StarMark = [[dict objectForKey:@"StarMark"] intValue];
            wModel.LikerMore = [[dict objectForKey:@"LikerMore"] intValue];
            
            
            NSDictionary *msgDic = [dict objectForKey:@"MessageInfo"];
            MessageInfo *msgInfo = [[MessageInfo alloc]init];
            msgInfo.ID = [msgDic objectForKey:@"ID"];
            //msgInfo.ContentTip = [msgDic objectForKey:@"ContentTip"];//没要content
            msgInfo.Content = [msgDic objectForKey:@"Content"];
            // NSLog(@"contentTip %@",msgInfo.Content);
            
            msgInfo.ComeFromType = [[msgDic objectForKey:@"ComeFromType"] intValue];
            msgInfo.SendObjectType = [[msgDic objectForKey:@"SendObjectType"] intValue];
            msgInfo.SubTimeStr = [msgDic objectForKey:@"SubTimeStr"];
            msgInfo.Type = [[msgDic objectForKey:@"Type"] intValue];
            
            wModel.msgInfo = msgInfo;
            
            
            NSArray *attInfoArr = [dict objectForKey:@"AttachmentInfoList"];
            //带有附件（图片...）
            if (attInfoArr.count) {
                wModel.arrAttachments = [NSMutableArray array];
                for (NSDictionary *attDict in attInfoArr) {
                    AttachmentInfo *attach = [[AttachmentInfo alloc]init];
                    attach.Type = [[attDict objectForKey:@"Type"] intValue];
                    attach.ID = [attDict objectForKey:@"ID"];
                    attach.AttachmentPathFull = [attDict objectForKey:@"AttachmentPathFull"];
                    attach.AttachmentName = [attDict objectForKey:@"AttachmentName"];
                    attach.ImageSmallPath = [attDict objectForKey:@"ImageSmallPath"];
                    attach.ImageBigPath = [attDict objectForKey:@"ImageBigPath"];
                    
                    [wModel.arrAttachments addObject:attach];
                }
            }else{
                wModel.arrAttachments = nil;
            }
            // NSLog(@"msg dic %@",msgDic);
            
            //带有转发的消息
            NSDictionary *transDic = [dict objectForKey:@"TransferedMessageInfo"];
            
            if (![transDic isKindOfClass:[NSNull class]]) {
                wModel.transInfo = [[TransferedMessageInfo alloc ]init];
                [self _parseMessageInfo:transDic model:wModel];
                [self _parseAttachmentInfoList:transDic model:wModel];
                wModel.transInfo.tModel.UserRealName = [transDic objectForKey:@"UserRealName"];
                wModel.transInfo.tModel.UserInfoID = [transDic objectForKey:@"UserInfoID"];
                //  NSLog(@"++++ wModel.transInfo.tModel.UserRealName  %@",[transDic objectForKey:@"UserRealName"]);
            }else{
                //  NSLog(@"no transfer");
                wModel.transInfo = nil;
            }
            
            
            NSDictionary *voteDic = [dict objectForKey:@"VoteInfo"];
            //带有投票
            if (![voteDic isKindOfClass:[NSNull class]]) {
                wModel.voteInfo = [[VoteInfo alloc]init];
                [self _parseVoteInfo:voteDic model:wModel];
            }else{
                wModel.voteInfo = nil;
            }
        
         [self _fillTableHeaderView];
//---go on----
        
        //-------------------------解析回复--------------------------------------------------
        
        [self _parseCommentWithModel:wModel dict:dict];
         _hasParseComment = YES;
                //---------------------------------------------------------------------------
        [MMProgressHUD dismiss];
        
    }];
}

- (void)_parseCommentWithModel:(WeiboModel *)model dict:(NSDictionary *)dict{
    wModel.MessageCommentTotalCount = [dict objectForKey:@"MessageCommentTotalCount"];
    NSArray *arrReply = [dict objectForKey:@"MessageCommentModelList"];
    
    if (arrReply.count != 0) {
        for (NSDictionary *replyDic in arrReply) {
            
            CommentModel *cM = [[CommentModel alloc ]init];
            cM.MessageRelationType = [[replyDic objectForKey:@"MessageRelationType"] integerValue];
            cM.SubTimeStr = [replyDic objectForKey:@"SubTimeStr"];
            
            //1：评论源消息；2：评论评论者的消息；
            if (cM.MessageRelationType == 1) {
                //只需解析TargetMessageInfo
                cM.targetInfo = [[SourceTargetMsgInfo alloc]init];
                NSDictionary *targetDic = [replyDic objectForKey:@"TargetMessageInfo"];
                
                [self _parseSourceTargetDicWithObject:cM.targetInfo dict:targetDic isTarget:YES];
                
                
            }else if (cM.MessageRelationType == 2){
                //需解析TargetMessageInfo & SourceMessageInfo
                cM.targetInfo = [[SourceTargetMsgInfo alloc]init];
                cM.sourceInfo = [[SourceTargetMsgInfo alloc]init];
                NSDictionary *targetDic = [replyDic objectForKey:@"TargetMessageInfo"];
                NSDictionary *sourceDic = [replyDic objectForKey:@"SourceMessageInfo"];
                [self _parseSourceTargetDicWithObject:cM.targetInfo dict:targetDic isTarget:YES];
                [self _parseSourceTargetDicWithObject:cM.sourceInfo dict:sourceDic isTarget:NO];
                cM.targetInfo.UserRealName = [NSString stringWithFormat:@"%@ 回复：%@",cM.targetInfo.UserRealName,cM.sourceInfo.UserRealName];
            }
            
            [_arrData addObject:cM];
        }
        
        [self.tableView reloadData];
    }
    

}

- (void)_fillTableHeaderView{
    [_headIcon setImageWithURL:[NSURL URLWithString:wModel.HeadSculpture48] placeholderImage:nil];
    [_headIcon setRoundedCornerWithRadius:5.0f];
    _labelName.text = wModel.UserRealName;
    _subTime.text = wModel.msgInfo.SubTimeStr;
    NSString *str = nil;
    //（1：网页端；2：android手机端；4：Ios手机端；8：pc客户端）
    if (wModel.msgInfo.ComeFromType == 1) {
        str = @"来自:网页端";
    }else if (wModel.msgInfo.ComeFromType == 2){
        str = @"来自:android客户端";
    }else if (wModel.msgInfo.ComeFromType == 3){
        str = @"来自:iPhone客户端";
    }else if (wModel.msgInfo.ComeFromType == 4){
        str = @"来自:pc客户端";
    }
    _msgSource.text = str;
    
    //微博消息
    float h = [TrendsView getWeiboViewHeight:wModel isRepost:NO isDetail:YES];
    _tHeaderView.frame = CGRectMake(_tHeaderView.left, _tHeaderView.right, self.view.width, h+_tHeaderView.height);
    _trendsView = [[TrendsView alloc]initWithFrame:CGRectMake(35, 60, self.view.width, h)];
    _trendsView.model = wModel;
    [_tHeaderView addSubview:_trendsView];
    
    self.tableView.frame = CGRectMake(self.tableView.left,self.tableView.top+h, self.tableView.width, self.tableView.height);
    
    self.tableView.tableHeaderView = self.tHeaderView;
    [self _createBottmView];
}

#pragma mark - bottom view
- (void)_createBottmView{
    
    UIView *botView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
    botView.backgroundColor  = [UIColor orangeColor];
    [self.view addSubview:botView];
    
    //转发
    clickableUIView *oneView = [[[NSBundle mainBundle]loadNibNamed:@"JsBotBtn" owner:self options:nil]lastObject];
    [(UIImageView*)[oneView viewWithTag:100] setImage:[UIImage JSenImageNamed:@"转发.png"]];
    [(UILabel*)[oneView viewWithTag:101] setText:@"转发"];
    [oneView handleComplemetionBlock:^(clickableUIView *view) {
        UIViewController *vc = [self _getMainVC];
        WeiboViewController *wc = [[WeiboViewController alloc]init];
        wc.model = wModel;
        wc.title = @"转发";
        
        //是转发源消息还是转发转发者的消息
        if (wc.model.transInfo) {
            wc.commType = Transfer_Transfer;
        }else{
            wc.commType = TransferSource;
        }
        
        [vc.navigationController pushViewController:wc animated:YES];
    }];
    [botView addSubview:oneView];
    
    //评论
    clickableUIView *twoView = [[[NSBundle mainBundle]loadNibNamed:@"JsBotBtn" owner:self options:nil]lastObject];
    twoView.frame = CGRectMake(kScreenWidth/3, 0, kScreenWidth/3, 44);
    [(UIImageView*)[twoView viewWithTag:100] setImage:[UIImage JSenImageNamed:@"评论.png"]];
    [(UILabel*)[twoView viewWithTag:101] setText:@"评论"];
    [twoView handleComplemetionBlock:^(clickableUIView *view) {
        UIViewController *vc = [self _getMainVC];
        WeiboViewController *wc = [[WeiboViewController alloc]init];
        wc.model = wModel;
        wc.title = @"回复";
        
        //点击这里评论则一定是评论源消息
        wc.commType = CommentSource;
        
        [vc.navigationController pushViewController:wc animated:YES];
    }];
    [botView addSubview:twoView];
    
    //赞
    clickableUIView *threeView = [[[NSBundle mainBundle]loadNibNamed:@"JsBotBtn" owner:self options:nil]lastObject];
    threeView.frame = CGRectMake(kScreenWidth/3*2, 0, kScreenWidth/3, 44);
    
    [(UIImageView*)[threeView viewWithTag:100] setImage:[UIImage JSenImageNamed:@"赞.png"]];
    NSString *str = nil;
    if (wModel.LikeFlag) {
        str = @"已赞";
    }else{
        str = @"赞";
    }
    [(UILabel*)[threeView viewWithTag:101] setText:str];
    
    [threeView handleComplemetionBlock:^(clickableUIView *view) {
        UILabel *zan = (UILabel*)[threeView viewWithTag:101];
        UserModel *uM = [[UserMgr sharedInstance]readFromDisk];
        NSString *mId = [NSString stringWithFormat:@"%@",wModel.msgInfo.ID];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uM.Token,@"token",mId,@"messageID", nil];
        
        if ([zan.text isEqualToString:@"赞"]) {
            //点赞
            
            [jsHttpHandler JsHttpPostWithStrOfUrl:kMsgLikeUrl paraDict:dict completionBlock:^(id JSON) {
                NSLog(@"zan %@",JSON);
                if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                    NSLog(@"点赞成功");
                    zan.text = @"已赞";
                    wModel.LikeFlag = 1;
                    NSInteger lc = [wModel.MessageLikeTotalCount integerValue];
                    wModel.MessageLikeTotalCount =[NSNumber numberWithInteger:lc+1];
                    _zan.text = [NSString stringWithFormat:@"%d赞",[_zan.text integerValue]+1];
                    NSDictionary *myDic = [NSDictionary dictionaryWithObjectsAndKeys:wModel,@"model", nil];
                    //通知SecFooter改变现实的赞数目和图片
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"likeSuccess" object:nil userInfo:myDic];
                }else{
                    NSLog(@"点赞失败");
                    
                }
            }];
            
        }else{
            //取消点赞
            [jsHttpHandler JsHttpPostWithStrOfUrl:kMsgUnLikeUrl paraDict:dict completionBlock:^(id JSON) {
                NSLog(@"qu xiaozan %@",JSON);
                if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                    NSLog(@"取消点赞成功");
                    zan.text = @"赞";
                    wModel.LikeFlag = 0;
                    NSInteger lc = [wModel.MessageLikeTotalCount integerValue];
                    wModel.MessageLikeTotalCount =[NSNumber numberWithInteger:lc-1];
                    _zan.text = [NSString stringWithFormat:@"%d赞",[_zan.text integerValue]-1];
                    //通知SecFooter改变现实的赞数目和图片
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"unlikeSuccess" object:nil ];
                }else{
                    NSLog(@"取消点赞失败");
                    
                }
            }];
        }
    }];
    [botView addSubview:threeView];
}

- (UIViewController *)_getMainVC{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    UIWindow *win = del.window;
    DDMenuController *dd = (DDMenuController *)win.rootViewController;
    UITabBarController *tab = (UITabBarController *)dd.rootViewController;
    UINavigationController *nav = [tab.viewControllers objectAtIndex:tab.selectedIndex];
    return [nav topViewController];
}

#pragma mark - parse JSON
- (void)_parseSourceTargetDicWithObject:(SourceTargetMsgInfo*)stInfo dict:(NSDictionary *)targetDic isTarget:(BOOL)yesOrNo{
    stInfo.HeadSculpture48 = [targetDic objectForKey:@"HeadSculpture48"];
    stInfo.Level = [targetDic objectForKey:@"Level"];
    stInfo.UserInfoID = [targetDic objectForKey:@"UserInfoID"];
    stInfo.UserRealName = [targetDic objectForKey:@"UserRealName"];
    
    //messageInfo
    NSDictionary *msgDic = [targetDic objectForKey:@"MessageInfo"];
    MessageInfo *msg = [[MessageInfo alloc]init];
    msg.ComeFromType = [[msgDic objectForKey:@"ComeFromType"] integerValue];
    msg.Content = [msgDic objectForKey:@"Content"];
    msg.ID = [msgDic objectForKey:@"ID"] ;
    msg.SendObjectType = [[msgDic objectForKey:@"SendObjectType"] integerValue];
    msg.SubTimeStr = [msgDic objectForKey:@"SubTimeStr"];
    msg.Type = [[msgDic objectForKey:@"Type"] integerValue];
    
    stInfo.msgInfo = msg;
    
    //attachmentInfoList
    if (yesOrNo) {
        
        NSArray *attInfoArr = [targetDic objectForKey:@"AttachmentInfoList"];
        //转发的消息带有附件（图片...）
        if (attInfoArr.count) {
            stInfo.arrAttInfoList  = [NSMutableArray array];
            for (NSDictionary *attDict in attInfoArr) {
                AttachmentInfo *attach = [[AttachmentInfo alloc]init];
                attach.Type = [[attDict objectForKey:@"Type"] intValue];
                attach.ID = [attDict objectForKey:@"ID"];
                attach.AttachmentPathFull = [attDict objectForKey:@"AttachmentPathFull"];
                attach.AttachmentName = [attDict objectForKey:@"AttachmentName"];
                attach.ImageBigPath = [attDict objectForKey:@"ImageBigPath"];
                
                [stInfo.arrAttInfoList addObject:attach];
            }
        }else{
            stInfo.arrAttInfoList = nil;
        }
    }
    
}


//解析消息  将消息放到   wModel.transInfo.tModel.msgInfo
- (void)_parseMessageInfo:(NSDictionary*)dict model:(WeiboModel*)wModel{
    NSDictionary *msgDic = [dict objectForKey:@"MessageInfo"];
    MessageInfo *msgInfo = [[MessageInfo alloc]init];
    msgInfo.ID = [msgDic objectForKey:@"ID"];
    msgInfo.Content = [msgDic objectForKey:@"Content"];//没要content
    NSLog(@"content %@",msgInfo.Content);
    
    msgInfo.ComeFromType = [[msgDic objectForKey:@"ComeFromType"] intValue];
    msgInfo.SendObjectType = [[msgDic objectForKey:@"SendObjectType"] intValue];
    msgInfo.SubTimeStr = [msgDic objectForKey:@"SubTimeStr"];
    msgInfo.Type = [[msgDic objectForKey:@"Type"] intValue];
    
    wModel.transInfo.tModel.msgInfo = msgInfo;
}
//解析附件
- (void)_parseAttachmentInfoList:(NSDictionary*)dict model:(WeiboModel*)wModel{
    NSArray *attInfoArr = [dict objectForKey:@"AttachmentInfoList"];
    //转发的消息带有附件（图片...）
    if (attInfoArr.count) {
        wModel.transInfo.tModel.arrAttachments = [NSMutableArray array];
        for (NSDictionary *attDict in attInfoArr) {
            AttachmentInfo *attach = [[AttachmentInfo alloc]init];
            attach.Type = [[attDict objectForKey:@"Type"] intValue];
            attach.ID = [attDict objectForKey:@"ID"];
            attach.AttachmentPathFull = [attDict objectForKey:@"AttachmentPathFull"];
            attach.AttachmentName = [attDict objectForKey:@"AttachmentName"];
            attach.ImageSmallPath = [attDict objectForKey:@"ImageSmallPath"];
            attach.ImageBigPath = [attDict objectForKey:@"ImageBigPath"];
            
            [wModel.transInfo.tModel.arrAttachments addObject:attach];
        }
    }else{
        wModel.transInfo.tModel.arrAttachments = nil;
    }
    
}
//解析投票
- (void)_parseVoteInfo:(NSDictionary*)dict model:(WeiboModel*)wModel{
    
    wModel.voteInfo.Anonymous = [[dict objectForKey:@"Anonymous"] intValue];
    wModel.voteInfo.AvailableNumber = [dict objectForKey:@"AvailableNumber"];
    wModel.voteInfo.Deadline = [dict objectForKey:@"Deadline"];
    wModel.voteInfo.IsDeadline = [[dict objectForKey:@"IsDeadline"] intValue];
    wModel.voteInfo.MyVoted  = [[dict objectForKey:@"MyVoted"] intValue];
    //我投过票
    if (wModel.voteInfo.MyVoted) {
        wModel.voteInfo.arrMyVotedOptions = [NSMutableArray arrayWithArray:[dict objectForKey:@"MyVotedOptions"]];
    }else{
        wModel.voteInfo.arrMyVotedOptions = nil;
    }
    
    wModel.voteInfo.arrOptions  = [NSMutableArray array];
    //解析Options
    NSArray *arrOptions = [dict objectForKey:@"Options"];
    for (NSDictionary *one in arrOptions) {
        Options *opt = [[Options alloc]init];
        opt.OptionID = [one objectForKey:@"OptionID"];
        opt.OptionName = [one objectForKey:@"OptionName"];
        opt.Percentage = [one objectForKey:@"Percentage"];
        
        //投票中得附件
        NSDictionary *attDict = [one objectForKey:@"AttachmentInfo"];
        if (![attDict isKindOfClass:[NSNull class]]) {
            AttachmentInfo *attach = [[AttachmentInfo alloc]init];
            attach.Type = [[attDict objectForKey:@"Type"] intValue];
            attach.ID = [attDict objectForKey:@"ID"];
            attach.AttachmentName = [attDict objectForKey:@"AttachmentName"];
            attach.ImageSmallPath = [attDict objectForKey:@"ImageSmallPath"];
            attach.ImageBigPath = [attDict objectForKey:@"ImageBigPath"];
        }else{
            opt.attMent = nil;
        }
        
        [wModel.voteInfo.arrOptions addObject:opt];
    }
}



#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CommentCell" owner:self options:nil]lastObject];
    }
    if (_arrData.count == 0) {
        return cell;
    }
    
    CommentModel *cModel = [_arrData objectAtIndex:indexPath.row];
    cell.cModel = cModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = [_arrData objectAtIndex:indexPath.row];
    float h = [CommentCell getCommentHeight:model];
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_arrData.count) return;
    CommentModel *comm = [_arrData objectAtIndex:indexPath.row];
    
    WeiboViewController *wc = [[WeiboViewController alloc]init];
    wc.title = @"回复";
    wc.model = wModel;
    wc.commModel = comm;
    //从这里评论一定是评论评论者的消息
    wc.commType = Comment_Comment;
    
    [self.navigationController pushViewController:wc animated:YES];
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // if(!_arrData.count) return nil;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor clearColor];
    
    
    zf = [[ClickableUILabel alloc]initWithFrame:CGRectMake(0, 8, kScreenWidth/3, 20)];
    zf.text = [NSString stringWithFormat:@"%d转发",[wModel.MessageTransferTotalCount integerValue]];
    zf.textAlignment = NSTextAlignmentCenter;
    zf.backgroundColor = [UIColor clearColor];
    zf.font = SysFont(13);
    [view addSubview:zf];
    
    pl = [[ClickableUILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3, 8, kScreenWidth/3, 20)];
   
    pl.text = [NSString stringWithFormat:@"%d评论",[wModel.MessageCommentTotalCount integerValue ]];
    pl.textAlignment = NSTextAlignmentCenter;
    pl.backgroundColor = [UIColor clearColor];
    pl.font = SysFont(13);
    [view addSubview:pl];
    
    _zan = [[ClickableUILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3*2, 8, kScreenWidth/3, 20)];
    _zan.text = [NSString stringWithFormat:@"%d赞",[wModel.MessageLikeTotalCount integerValue]];
    _zan.textAlignment = NSTextAlignmentCenter;
    _zan.font = SysFont(13);
    _zan.backgroundColor = [UIColor clearColor];
    [view addSubview:_zan];
    return view;
    
}


#pragma mark - press Button
- (void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

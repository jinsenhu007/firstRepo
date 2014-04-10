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

@interface SingleTrendVC ()

@end

@implementation SingleTrendVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (_strOfUrl) {
        UserModel *m = [[UserMgr sharedInstance] readFromDisk];
        _strOfUrl = [NSString stringWithFormat:@"%@&token=%@",_strOfUrl,m.Token];
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithStatus:@"加载中..."];
        [self loadData];
    }
    
}

- (void)loadData{
    NSLog(@"%s,url %@",__FUNCTION__,_strOfUrl);
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:_strOfUrl withCache:YES completionBlock:^(id JSON) {
//        if ([[JSON objectForKey:@"Total"] intValue] == 0) {
//            NSLog(@"没有更多数据了");
//            [MMProgressHUD dismissWithError:@"没有数据!" afterDelay:0.5f];
//            return;
//        }
     
        //只有在下拉刷新的时候才需要改变SinceID
      
        
        NSDictionary *dict = JSON;
            
            WeiboModel *wModel = [[WeiboModel alloc]init];
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
//---go on----

    }];
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
    //wc.model = self.model;
    wc.commModel = comm;
    //从这里评论一定是评论评论者的消息
    wc.commType = Comment_Comment;
    
    [self.navigationController pushViewController:wc animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

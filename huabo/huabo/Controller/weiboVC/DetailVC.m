//
//  DetailVC.m
//  huabo
//
//  Created by admin on 14-3-21.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "DetailVC.h"
#import "JsDevice.h"
#import "UIView+MakeAViewRoundCorner.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"
#import "TrendsView.h"
#import "Const.h"
#import "jsHttpHandler.h"
#import "CommentCell.h"
#import "JsDevice.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "CommentCell.h"
#import "weiboViewController.h"
#import "ClickableUILabel.h"
#import "clickableUIView.h"
#import "UIImage+imageNamed_JSen.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "PopupListComponent.h"
#import "BlockUI.h"
#import "MBProgressHUD.h"
#import "MMProgressHUD.h"
@interface DetailVC ()

@end

@implementation DetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)_initView{
    UIView *tHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [tHeadView addSubview:self.userBarView];
    
    [self.icon setRoundedCornerWithRadius:5.0f];
    [self.icon setImageWithURL:[NSURL URLWithString:_model.HeadSculpture48] placeholderImage:nil];
    [self.labelName setText:_model.UserRealName];
    
    tHeadView.height += 60;
    //
    float h = [TrendsView getWeiboViewHeight:_model isRepost:NO isDetail:YES];
    _weiboView = [[TrendsView alloc]initWithFrame:CGRectMake(5, _userBarView.bottom+10, kScreenWidth-10, h)];
    _weiboView.isDetail = YES;
    
    _weiboView.model = _model;
    [tHeadView addSubview:_weiboView];
    tHeadView.height += (h + 25);
    self.tableView.tableHeaderView = tHeadView;
}

- (void)_loadData{
    
    if (![JsDevice netOK]) {
        //网络故障
        return;
    }
        //加载评论
        UserModel *um = [[UserMgr sharedInstance] readFromDisk];
        NSString *str = [NSString stringWithFormat:kCommentsUrl,_model.msgInfo.ID,um.Token];
        NSLog(@"str = %@",str);
        [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:YES completionBlock:^(id JSON) {
            NSLog(@"comment %@",JSON);
            int total = [[JSON objectForKey:@"Total"] intValue];
            if (total == 0)  return ;
            [_arrData removeAllObjects];
            for (NSDictionary *dic  in [JSON objectForKey:@"Rows"]) {
                
                CommentModel *cM = [[CommentModel alloc ]init];
                cM.MessageRelationType = [[dic objectForKey:@"MessageRelationType"] integerValue];
                cM.SubTimeStr = [dic objectForKey:@"SubTimeStr"];
                
                //1：评论源消息；2：评论评论者的消息；
                if (cM.MessageRelationType == 1) {
                    //只需解析TargetMessageInfo
                    cM.targetInfo = [[SourceTargetMsgInfo alloc]init];
                    NSDictionary *targetDic = [dic objectForKey:@"TargetMessageInfo"];
                    
                    [self _parseSourceTargetDicWithObject:cM.targetInfo dict:targetDic isTarget:YES];
                    
                    
                }else if (cM.MessageRelationType == 2){
                    //需解析TargetMessageInfo & SourceMessageInfo
                    cM.targetInfo = [[SourceTargetMsgInfo alloc]init];
                    cM.sourceInfo = [[SourceTargetMsgInfo alloc]init];
                    NSDictionary *targetDic = [dic objectForKey:@"TargetMessageInfo"];
                    NSDictionary *sourceDic = [dic objectForKey:@"SourceMessageInfo"];
                    [self _parseSourceTargetDicWithObject:cM.targetInfo dict:targetDic isTarget:YES];
                    [self _parseSourceTargetDicWithObject:cM.sourceInfo dict:sourceDic isTarget:NO];
                    cM.targetInfo.UserRealName = [NSString stringWithFormat:@"%@ 回复：%@",cM.targetInfo.UserRealName,cM.sourceInfo.UserRealName];
                }
                
                 [_arrData addObject:cM];
            }
            
            [_tableView reloadData];
        
        }];
        [jsHttpHandler setCacheTime:10*60];//10min(待定)

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self _loadData];
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initView];
     [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack)];
    [self showRightButtonOfSureWithName:@"更多" target:self action:@selector(clickRightBtn:)];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    btn.frame = CGRectMake(0, 0, 40, 35);
//    btn.titleLabel.text = @"更多";
//    btn.titleLabel.textColor = [UIColor colorWithRed:0.000 green:0.800 blue:0.800 alpha:1.000];
//    [btn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = btnItem;
    _arrData = [NSMutableArray array];
    
    
    [self _createBottmView];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"commentSuccess" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        int count = [self.model.MessageCommentTotalCount integerValue];
        [pl setText:[NSString stringWithFormat:@"%d评论",count]];
    }];
    [self setExtraCellLineHidden:self.tableView];
}

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
        wc.model = _model;
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
        wc.model = _model;
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
    if (_model.LikeFlag) {
        str = @"已赞";
    }else{
        str = @"赞";
    }
    [(UILabel*)[threeView viewWithTag:101] setText:str];
    
    [threeView handleComplemetionBlock:^(clickableUIView *view) {
        UILabel *zan = (UILabel*)[threeView viewWithTag:101];
        UserModel *uM = [[UserMgr sharedInstance]readFromDisk];
        NSString *mId = [NSString stringWithFormat:@"%@",_model.msgInfo.ID];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uM.Token,@"token",mId,@"messageID", nil];

        if ([zan.text isEqualToString:@"赞"]) {
            //点赞
          
            [jsHttpHandler JsHttpPostWithStrOfUrl:kMsgLikeUrl paraDict:dict completionBlock:^(id JSON) {
                NSLog(@"zan %@",JSON);
                if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                    NSLog(@"点赞成功");
                   zan.text = @"已赞";
                    _model.LikeFlag = 1;
                    NSInteger lc = [_model.MessageLikeTotalCount integerValue];
                    _model.MessageLikeTotalCount =[NSNumber numberWithInteger:lc+1];
                   _zan.text = [NSString stringWithFormat:@"%d赞",[_zan.text integerValue]+1];
                    NSDictionary *myDic = [NSDictionary dictionaryWithObjectsAndKeys:_model,@"model", nil];
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
                    _model.LikeFlag = 0;
                    NSInteger lc = [_model.MessageLikeTotalCount integerValue];
                    _model.MessageLikeTotalCount =[NSNumber numberWithInteger:lc-1];
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


#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrData.count) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
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
    wc.model = self.model;
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
    zf.text = [NSString stringWithFormat:@"%@转发",_model.MessageTransferTotalCount];
    zf.textAlignment = NSTextAlignmentCenter;
    zf.backgroundColor = [UIColor clearColor];
    zf.font = SysFont(13);
    [view addSubview:zf];
    
    pl = [[ClickableUILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3, 8, kScreenWidth/3, 20)];
    pl.text = [NSString stringWithFormat:@"%@评论",_model.MessageCommentTotalCount];
    pl.textAlignment = NSTextAlignmentCenter;
    pl.backgroundColor = [UIColor clearColor];
    pl.font = SysFont(13);
    [view addSubview:pl];
    
    _zan = [[ClickableUILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3*2, 8, kScreenWidth/3, 20)];
    _zan.text = [NSString stringWithFormat:@"%@赞",_model.MessageLikeTotalCount];
    _zan.textAlignment = NSTextAlignmentCenter;
    _zan.font = SysFont(13);
    _zan.backgroundColor = [UIColor clearColor];
    [view addSubview:_zan];
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

#pragma mark - button action
- (void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn:(id)sender{
    
    NSString *str1 = nil;
    if (_model.CollectFlag) {
        str1 = @"取消收藏";
    }else{
        str1 = @"收藏";
    }
   
    UserModel *user = [[UserMgr sharedInstance] readFromDisk];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:user.Token forKey:@"token"];
    [dict setObject:_model.msgInfo.ID forKey:@"messageID"];
    
    if (_model.IsMy) {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:str1,@"删除", nil];
        [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
           
            if (buttonIndex == 0) {
                //
                if (_model.CollectFlag) {
                    //取消收藏
//                    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//                    [MMProgressHUD showWithStatus:@"请稍后..."];
//                    AppDelegate *del = [UIApplication sharedApplication].delegate;
//                    HUD = [[MBProgressHUD alloc]initWithWindow:del.window];
//                    [HUD show:YES];
                    [jsHttpHandler JsHttpPostWithStrOfUrl:kUnCollectMsgUrl paraDict:dict completionBlock:^(id JSON) {
                        if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                            _model.CollectFlag = 0;
#pragma warn -  还没显示就pop当前controller可能崩溃
                            [self _showMBHUDWithTitle:@"取消收藏成功!" success:YES];
                        }else{
                            [self _showMBHUDWithTitle:@"取消收藏失败!" success:NO];
                        }
                    }];
                    
                }else{
                    //收藏
                    [jsHttpHandler JsHttpPostWithStrOfUrl:kCollectMsgUrl paraDict:dict completionBlock:^(id JSON) {
                        if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                            _model.CollectFlag = 1;
                            [self _showMBHUDWithTitle:@"收藏成功!" success:YES];
                            
                        }else{
                            [self _showMBHUDWithTitle:@"收藏失败!" success:NO];
                        }
                    }];

                }
            }else{
                //删除消息
                [jsHttpHandler JsHttpPostWithStrOfUrl:kDeleteMsgUrl paraDict:dict completionBlock:^(id JSON) {
                    if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                        [self _showMBHUDWithTitle:@"删除成功！" success:YES];
                        NSDictionary *myDic = [NSDictionary dictionaryWithObject:_model forKey:@"model"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMSGSuccess" object:nil userInfo:myDic];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }else{
                        [self _showMBHUDWithTitle:@"删除失败" success:NO];
                    }
                }];
            }
        }];
    }else{
        
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:str1, nil];
        [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
            if (_model.CollectFlag) {
                //取消收藏
                [jsHttpHandler JsHttpPostWithStrOfUrl:kUnCollectMsgUrl paraDict:dict completionBlock:^(id JSON) {
                    if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                        _model.CollectFlag = 0;
                        [self _showMBHUDWithTitle:@"取消收藏成功!" success:YES];
                    }else{
                        [self _showMBHUDWithTitle:@"取消收藏失败!" success:NO];
                    }
                }];
                
            }else{
                //收藏
                [jsHttpHandler JsHttpPostWithStrOfUrl:kCollectMsgUrl paraDict:dict completionBlock:^(id JSON) {
                    if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
                        _model.CollectFlag = 1;
                        [self _showMBHUDWithTitle:@"收藏成功!" success:YES];
                        
                    }else{
                        [self _showMBHUDWithTitle:@"收藏失败!" success:NO];
                    }
                }];
            }
        }];
    }
    
    
}

- (void)_showMBHUDWithTitle:(NSString *)title success:(BOOL)isSuccess{
    //将当前controller pop出去后不能在显示HUD，否则会崩
    if (!self.view) {
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.navigationController.view addSubview:HUD];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    if (isSuccess) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage JSenImageNamed:@"37x-Checkmark.png"]] ;
    }else{
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage JSenImageNamed:@"37fail-Checkmark.png"]] ;
    }
	
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText =title;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:0.8];
}

- (UIViewController *)_getMainVC{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    UIWindow *win = del.window;
    DDMenuController *dd = (DDMenuController *)win.rootViewController;
    UITabBarController *tab = (UITabBarController *)dd.rootViewController;
    UINavigationController *nav = [tab.viewControllers objectAtIndex:tab.selectedIndex];
    return [nav topViewController];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

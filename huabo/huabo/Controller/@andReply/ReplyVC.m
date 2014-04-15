//
//  ReplyVC.m
//  huabo
//
//  Created by admin on 14-4-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "ReplyVC.h"
#import "Const.h"
#import "jsHttpHandler.h"
#import "ReplyCell.h"
#import "ReplyModel.h"
#import "SVPullToRefresh.h"
#import "JsDevice.h"
#import "MMProgressHUD.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "AtMeVC.h"

@interface ReplyVC ()

@end

@implementation ReplyVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = self.navTitleView;
    self.titleLabel.text = @"回复我的";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    IOS7;
    //self.tableView.frame = CGRECT_HAVE_NAV(0, 0, kScreenWidth, kScreenHeight-64-49-40);
    __weak ReplyVC *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.tableView.pullToRefreshView setTitle:@"正在加载中..." forState:SVPullToRefreshStateLoading];
        [weakSelf.tableView.pullToRefreshView setTitle:@"释放立即刷新" forState:SVPullToRefreshStateTriggered];
        [weakSelf.tableView.pullToRefreshView setTitle:@"往下拉来刷新" forState:SVPullToRefreshStateStopped];
        
        [weakSelf _loadDataSource];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (weakSelf.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading ) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            return ;
        }
        [weakSelf _loadMoreData];
    }];
    
    
    //default
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    _strOfUrl = [NSString stringWithFormat:kReplyMeUrl,model.Token];
    _needCache = NO;
    _arrData = [NSMutableArray array];
    [self _loadOrigionalData];
    
     [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack)];
    
    
    _myReply = [[MyReplyVC alloc]init];
    _myReplyView = _myReply.view;
    
    _atMe = [[AtMeVC alloc]init];
    _atMeView = _atMe.view;
    //[self.view insertSubview:_myReplyView belowSubview:self.tableView];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"加载中..."];
}

- (void)_loadOrigionalData{
    if (![JsDevice netOK]) {
        [MMProgressHUD dismissWithError:@"加载失败"];
        return;
    }
    NSLog(@"url %@",_strOfUrl);
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:_strOfUrl withCache:_needCache completionBlock:^(id JSON){
       
        if (!JSON) {
            [MMProgressHUD dismissWithError:@"加载失败"];
            return ;
        }
        if ([[JSON objectForKey:@"Total"] intValue] == 0) {
            NSLog(@"没有更多数据了");
            [MMProgressHUD dismiss];
            if (_tableView.pullToRefreshView.state == 2) {
                [_tableView.pullToRefreshView stopAnimating];
                return ;
            }
            [_tableView.infiniteScrollingView stopAnimating];
            return;
        }

       // NSLog(@"--%@",JSON);
       
        
//        if ([[JSON objectForKey:@"OriginalMessageIsDeleted"] intValue]) {
//            //源消息已被删除
//            m.OriginalMessageContent = @"源消息已被删除";
//        }
        if (_isLoadMore == NO) {
            [_arrData removeAllObjects];
        }
        _maxID = [[JSON objectForKey:@"MaxID"] integerValue];

        for (NSDictionary *dict in [JSON objectForKey:@"Rows"]) {
             ReplyModel *m = [[ReplyModel alloc]init];
            m.IsStarMark = [[dict objectForKey:@"IsStarMark"] intValue];
            m.MessageIndexID =[dict objectForKey:@"MessageIndexID"];
            m.OriginalMessageIsDeleted = [[dict objectForKey:@"OriginalMessageIsDeleted"] intValue];
            if (m.OriginalMessageIsDeleted == 1) {
                m.OriginalMessageContent = @"源消息已被删除";
                
            }else{
                m.OriginalMessageContent = [dict objectForKey:@"OriginalMessageContent"];
                m.OriginalUserHeadSculpture48 = [dict objectForKey:@"OriginalUserHeadSculpture48"];
                m.OriginalMessageID = [dict objectForKey:@"OriginalMessageID"];
                m.OriginalUserID = [dict objectForKey:@"OriginalUserID"];
                m.OriginalUserName = [dict objectForKey:@"OriginalUserName"];
            }
            m.SubTimeStr = [dict objectForKey:@"SubTimeStr"];
            m.TargetMessageContent = [dict objectForKey:@"TargetMessageContent"];
            m.TargetMessageID = [dict objectForKey:@"TargetMessageID"];
            m.TargetUserHeadSculpture48 = [dict objectForKey:@"TargetUserHeadSculpture48"];
            m.TargetUserID =[dict objectForKey:@"TargetUserID"];
            m.TargetUserLevel = [dict objectForKey:@"TargetUserLevel"];
            m.TargetUserName = [dict objectForKey:@"TargetUserName"];
            m.TransferedMessageID = [dict objectForKey:@"TransferedMessageID"];
            m.TransferedUserID = [dict objectForKey:@"TransferedUserID"];
         //   NSLog(@"m.Target %@",m.TargetMessageContent);
            [_arrData addObject:m];
            
        }
        [_tableView reloadData];
        if (_tableView.pullToRefreshView.state == 2) {
            [_tableView.pullToRefreshView stopAnimating];
            [MMProgressHUD dismiss];
            return ;
        }
        [_tableView.infiniteScrollingView stopAnimating];
    
        [MMProgressHUD dismiss];
    }];
}

- (void)_loadDataSource{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    NSString *subTitle = [NSString stringWithFormat:@"上次更新%@",str];
    [self.tableView.pullToRefreshView setSubtitle:subTitle forState:SVPullToRefreshStateLoading];
    _isLoadMore = NO;
    _needCache = NO;
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    _strOfUrl = [NSString stringWithFormat:kReplyMeUrl,model.Token];
    [self _loadOrigionalData];
    
//    if ([self.titleLabel.text isEqualToString:@"回复我的"]) {
//        
//    }else if ([self.titleLabel.text isEqualToString:@"我的回复"]){
//        _strOfUrl = [NSString stringWithFormat:kReplyByMeUrl,model.Token];
//        
//    }else if([self.titleLabel.text isEqualToString:@"@我的"]){
//        
//    }

}

- (void)_loadMoreData{
    _needCache = YES;
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    NSString *str = [NSString stringWithFormat:kReplyMeUrl,model.Token];
    _strOfUrl = [NSString stringWithFormat:@"%@&maxID=%d",str,_maxID];
    _needCache = YES;
    _isLoadMore = YES;
    [self _loadOrigionalData];

}


#pragma mark - TableView Delegate Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ReplyCell" owner:self options:nil]lastObject];
    }
    if (_arrData.count == 0) {
        return cell;
    }
    
    ReplyModel *model = [_arrData objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_arrData.count==0) {
        return 40;
    }
    ReplyModel *model = [_arrData objectAtIndex:indexPath.row];
    float h = [ReplyCell getCellHeightWithModel:model];
    
    return h;
}


#pragma mark - button action
- (IBAction)clickBtn:(UIButton *)sender {
    if (_popupList) {
        
        [UIView animateWithDuration:0.3f animations:^{
            self.arrow.transform = CGAffineTransformIdentity;
        }];
        _popupList = nil;
        if (_popupBGView) {
            [_popupBGView removeFromSuperview];
            _popupBGView = nil;
        }

        return;
    }
   [UIView animateWithDuration:0.3f animations:^{
       CGAffineTransform transfrom = CGAffineTransformMakeRotation(M_PI);
       self.arrow.transform = transfrom;
   }];
    PopupListComponentItem *itemOne = [[PopupListComponentItem alloc]initWithCaption:@"回复我的" image:Nil itemId:1 showCaption:YES];
     PopupListComponentItem *itemTwo = [[PopupListComponentItem alloc]initWithCaption:@"我的回复" image:Nil itemId:2 showCaption:YES];
     PopupListComponentItem *itemThree = [[PopupListComponentItem alloc]initWithCaption:@"@我的" image:Nil itemId:3 showCaption:YES];
    
    _popArray = [NSMutableArray arrayWithObjects:itemOne,itemTwo,itemThree, nil];
    
    _popupList = [[PopupListComponent alloc]init];
    _popupList.font = [UIFont systemFontOfSize:13];
    _popupList.buttonSpacing = 3;
    _popupList.textPaddingHorizontal = 4;
    _popupList.textPaddingVertical = 3;
    [_popupList showAnchoredTo:self.navigationItem.titleView inView:[self _popupBGView] withItems:_popArray withDelegate:self];
    
}

- (UIView *)_popupBGView{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    UIWindow *win = del.window;
    if (!_popupBGView) {
        _popupBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, win.frame.size.width, win.frame.size.height)];
        [win addSubview:_popupBGView];
    }    
    return _popupBGView;
}

#pragma mark - PopupListComponent Delegate 
- (void) popupListcomponent:(PopupListComponent *)sender choseItemWithId:(int)itemId{
    //UIButton *btnSelect = (UIButton *)[self.view viewWithTag:itemId];
 //   NSLog(@"subviews count %d",self.view.subviews.count);
    
    if (itemId == 1) {
        //回复我的
        if (![self.titleLabel.text isEqualToString:@"回复我的"]) {
            [self.tableView triggerPullToRefresh];
             self.titleLabel.text = @"回复我的";
            [self.view bringSubviewToFront:self.tableView];
        }
     
    }else if (itemId == 2){
        //我的回复
        if (![self.titleLabel.text isEqualToString:@"我的回复"]) {
            self.titleLabel.text = @"我的回复";
            _isLoadMore = NO;
            [self.view insertSubview:_myReplyView atIndex:self.view.subviews.count];
        }
      
    }else if (itemId == 3){
        //@我的
        if (![self.titleLabel.text isEqualToString:@"@我的"]) {
            self.titleLabel.text = @"@我的";
            [self.view insertSubview:_atMeView atIndex:self.view.subviews.count];
        }
        
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.arrow.transform = CGAffineTransformIdentity;
    }];
    _popupList = nil;
    [_popupBGView removeFromSuperview];
    _popupBGView = nil;
}
- (void) popupListcompoentDidCancel:(PopupListComponent *)sender{
    if (_popupList) {
        [UIView animateWithDuration:0.3f animations:^{
            self.arrow.transform = CGAffineTransformIdentity;
        }];
        _popupList = nil;
    }
    if (_popupBGView) {
        [_popupBGView removeFromSuperview];
        _popupBGView = nil;
    }

}

#pragma mark - Scroll View Delegate 
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_popupList) {
        _popupList = nil;
    }
    if (_popupBGView) {
        [_popupBGView removeFromSuperview];
        _popupBGView = nil;
    }
}

#pragma mark - PressBack
- (void)pressBack{
    if (_popupList) {
        _popupList = nil;
    }
    if (_popupBGView) {
        [_popupBGView removeFromSuperview];
        _popupBGView = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end

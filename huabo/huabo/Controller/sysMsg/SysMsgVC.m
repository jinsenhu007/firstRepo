//
//  SysMsgVC.m
//  huabo
//
//  Created by admin on 14-4-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "SysMsgVC.h"
#import "JsDevice.h"
#import "jsHttpHandler.h"
#import "SysMsgModel.h"
#import "SysMsgCell.h"
#import "Const.h"
#import "SVPullToRefresh.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "MMProgressHUD.h"


@interface SysMsgVC ()

@end

@implementation SysMsgVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    IOS7;
      [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack)];
    _arrData = [NSMutableArray new];
    
    __weak SysMsgVC *weakSelf = self;
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

    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"加载中..."];
    if (self.tableView.pullToRefreshView.state != 2) {
        [self.tableView triggerPullToRefresh];
    }
 
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
    _strOfUrl = [NSString stringWithFormat:kSysMsgUrl,model.Token];
    
    [self load];

}

- (void)_loadMoreData{
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    NSString *str = [NSString stringWithFormat:kSysMsgUrl,model.Token];
    _strOfUrl = [NSString stringWithFormat:@"%@&maxID=%d",str,_maxID];
    _needCache = YES;
    _isLoadMore = YES;
    
    [self load];

}

- (void)load{
    if (![JsDevice netOK]) {
        return;
    }
    NSLog(@"%s,url %@",__FUNCTION__,_strOfUrl);
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:_strOfUrl withCache:_needCache completionBlock:^(id JSON) {
        //返回的没有数据
        if ([[JSON objectForKey:@"Total"] intValue] == 0) {
            NSLog(@"没有更多数据了");
            [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
            [MMProgressHUD showWithStatus:@"没有更多数据" ];
            [MMProgressHUD dismissWithError:@"没有更多数据" title:nil afterDelay:0.5f];
            if (_tableView.pullToRefreshView.state == 2) {
                [_tableView.pullToRefreshView stopAnimating];
                return ;
            }
            [_tableView.infiniteScrollingView stopAnimating];
            return;
        }
        
        if ( !_isLoadMore ) {
            [_arrData removeAllObjects];
        }
        
        _maxID = [[JSON objectForKey:@"MaxID"] integerValue];
        for (NSDictionary *dict  in [JSON objectForKey:@"Rows"]) {
            SysMsgModel *m = [[SysMsgModel alloc]init];
            m.MessageIndexID = [dict objectForKey:@"MessageIndexID"];
            m.MessageContent = [dict objectForKey:@"MessageContent"];
            m.SubTimeStr = [dict objectForKey:@"SubTimeStr"];
            
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    SysMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SysMsgCell" owner:self options:nil]lastObject];
    }
    if (_arrData.count == 0) {
        return cell;
    }
    
    SysMsgModel *m = [_arrData objectAtIndex:indexPath.row];
    cell.model = m;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_arrData.count == 0) {
        return 40;
    }
    SysMsgModel *model = [_arrData objectAtIndex:indexPath.row];
    float h = [SysMsgCell getHeightWithModel:model];
    return h;
    
}

- (void)pressBack{
    if (self.tableView.pullToRefreshView.state == 2 || self.tableView.infiniteScrollingView.state == 2) {
        [self.tableView.pullToRefreshView stopAnimating ];
        [self.tableView.infiniteScrollingView stopAnimating];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

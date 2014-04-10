//
//  MyReplyVC.m
//  huabo
//
//  Created by admin on 14-4-8.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "MyReplyVC.h"
#import "JsDevice.h"
#import "SVPullToRefresh.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "ReplyModel.h"
#import "Const.h"
#import "MyReplyCell.h"
#import "jsHttpHandler.h"

@interface MyReplyVC ()

@end

@implementation MyReplyVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView triggerPullToRefresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    IOS7;
    
    __weak MyReplyVC *weakSelf = self;
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

    _arrData = [NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
}

- (void)_loadDataSource{
    _needCache = NO;
    UserModel *m = [[UserMgr sharedInstance] readFromDisk];
    _strOfUrl = [NSString stringWithFormat:kReplyByMeUrl,m.Token];
    _isLoadMore = NO;
    [self _loadMyReply];
}

- (void)_loadMoreData{
    _needCache = YES;
    UserModel *m = [[UserMgr sharedInstance] readFromDisk];
    NSString *str = [NSString stringWithFormat:kReplyByMeUrl,m.Token];
    _strOfUrl = [NSString stringWithFormat:@"%@&maxid=%d",str,_maxID];
    _isLoadMore = YES;
    [self _loadMyReply];
}


#pragma mark - TableView Delegate Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    MyReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyReplyCell" owner:self options:nil]lastObject];
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
    float h = [MyReplyCell getCellHeightWithModel:model];
    
    return h;
}

- (void)_loadMyReply{
    if (![JsDevice netOK]) {
        return;
    }
    NSLog(@"myreply %@",_strOfUrl);
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:_strOfUrl withCache:_needCache completionBlock:^(id JSON) {
        if (!JSON) {
            //            [MMProgressHUD dismissWithError:@"加载失败"];
            return ;
        }
        if ([[JSON objectForKey:@"Total"] intValue] == 0) {
            NSLog(@"没有更多数据了");
            if (_tableView.pullToRefreshView.state == 2) {
                [_tableView.pullToRefreshView stopAnimating];
                return ;
            }
            [_tableView.infiniteScrollingView stopAnimating];
            return;
        }
        
        if (_isLoadMore == NO) {
            [_arrData removeAllObjects];
        }
        _maxID = [[JSON objectForKey:@"MaxID"] integerValue];
        
        for (NSDictionary *dict in [JSON objectForKey:@"Rows"]) {
            ReplyModel *m = [[ReplyModel alloc]init];
            m.MessageIndexID = [dict objectForKey:@"MessageIndexID"];
            m.OriginalMessageID = [dict objectForKey:@"OriginalMessageID"];
            m.SourceMessageIsDeleted = [[dict objectForKey:@"SourceMessageIsDeleted"] intValue];
            if (m.SourceMessageIsDeleted) {
                m.SourceMessageContent = @"源消息已被删除";
            }else{
                m.SourceMessageContent = [dict objectForKey:@"SourceMessageContent"];
                m.SourceMessageID = [dict objectForKey:@"SourceMessageID"];
                m.SourceMessageType = [dict objectForKey:@"SourceMessageType"];
            }
            m.SourceUserID = [dict objectForKey:@"SourceUserID"];
            m.SourceUserName = [dict objectForKey:@"SourceUserName"];
            m.SubTimeStr = [dict objectForKey:@"SubTimeStr"];
            m.TargetMessageContent = [dict objectForKey:@"TargetMessageContent"];
            m.TargetMessageID = [dict objectForKey:@"TargetMessageID"];
            //未解析其他的target==
            
            [_arrData addObject:m];
        }
        
        [_tableView reloadData];
        if (_tableView.pullToRefreshView.state == 2) {
            [_tableView.pullToRefreshView stopAnimating];
            return ;
        }
        [_tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

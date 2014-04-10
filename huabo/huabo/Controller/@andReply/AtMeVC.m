//
//  AtMeVC.m
//  huabo
//
//  Created by admin on 14-4-9.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "AtMeVC.h"
#import "AtMeCell.h"
#import "AtMeModel.h"
#import "Const.h"
#import "jsHttpHandler.h"
#import "SVPullToRefresh.h"
#import "JsDevice.h"
#import "UserModel.h"
#import "UserMgr.h"

@interface AtMeVC ()

@end

@implementation AtMeVC

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
    
    
    _arrData = [NSMutableArray new];
    
    //IOS7;
    //self.tableView.frame = CGRECT_HAVE_NAV(0, 0, kScreenWidth, kScreenHeight-64-49-40);
    __weak AtMeVC *weakSelf = self;
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

    // Do any additional setup after loading the view from its nib.
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
    _strOfUrl = [NSString stringWithFormat:kAtMeUrl,model.Token];
    
     [self load];
}

- (void)_loadMoreData{
    
    UserModel *model = [[UserMgr sharedInstance] readFromDisk];
    NSString *str = [NSString stringWithFormat:kAtMeUrl,model.Token];
    _strOfUrl = [NSString stringWithFormat:@"%@&maxID=%d",str,_maxID];
    _needCache = YES;
    _isLoadMore = YES;
    
    [self load];
}

- (void)load{
    if (![JsDevice netOK]) {
        return;
    }
     NSLog(@"url %@",_strOfUrl);
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:_strOfUrl withCache:_needCache completionBlock:^(id JSON) {
        if(!JSON) return ;
        
        if ([[JSON objectForKey:@"Total"] intValue] == 0) {
            NSLog(@"没有更多数据了");
          
            if (_tableView.pullToRefreshView.state == 2) {
                [_tableView.pullToRefreshView stopAnimating];
                return ;
            }
            [_tableView.infiniteScrollingView stopAnimating];
            return;
        }
        if (!_isLoadMore) {
            [_arrData removeAllObjects];
        }
        _maxID = [[JSON objectForKey:@"MaxID"] integerValue];
        
        for (NSDictionary *dict in [JSON objectForKey:@"Rows"]) {
            AtMeModel *model = [[AtMeModel alloc]init];
            
             model.MessageIndexID = [dict objectForKey:@"MessageIndexID"];
             model.OriginalUserID = [dict objectForKey:@"OriginalUserID"];
            if ([model.OriginalUserID integerValue] == 0) {
                //
                model.OriginalMessageContent = @"源消息已删除";
            }else{
               
                model.OriginalMessageContent = [dict objectForKey:@"OriginalMessageContent"];
                model.OriginalMessageID = [dict objectForKey:@"OriginalMessageID"];
                model.OriginalUserHeadSculpture48 = [dict objectForKey:@"OriginalUserHeadSculpture48"];
                model.OriginalUserName = [dict objectForKey:@"OriginalUserName"];
            }
           
            model.SubTimeStr = [dict objectForKey:@"SubTimeStr"];
            model.TargetMessageContent = [dict objectForKey:@"TargetMessageContent"];
            model.TargetMessageID = [dict objectForKey:@"TargetMessageID"];
            model.TargetMessageType = [[dict objectForKey:@"TargetMessageType"] intValue];
            model.TargetUserHeadSculpture48 = [dict objectForKey:@"TargetUserHeadSculpture48"];
            model.TargetUserID = [dict objectForKey:@"TargetUserID"];
            model.TargetUserLevel = [dict objectForKey:@"TargetUserLevel"];
            model.TransferedMessageID = [dict objectForKey:@"TransferedMessageID"];
            model.TransferedUserID = [dict objectForKey:@"TransferedUserID"];
            model.TargetUserName = [dict objectForKey:@"TargetUserName"];
            
            [_arrData addObject:model];
        }
        
        [_tableView reloadData];
        if (_tableView.pullToRefreshView.state == 2) {
            [_tableView.pullToRefreshView stopAnimating];
           
            return ;
        }
        [_tableView.infiniteScrollingView stopAnimating];
        
    
        
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    AtMeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AtMeCell" owner:self options:nil]lastObject];
    }
    
    if (!_arrData.count) {
        return cell;
    }
    
    AtMeModel *m = [_arrData objectAtIndex:indexPath.row];
    cell.model = m;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_arrData.count) {
        return 50;
    }
    AtMeModel *m = [_arrData objectAtIndex:indexPath.row];
    
    float h = [AtMeCell getCellHeightWithModel:m ];
    return h;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

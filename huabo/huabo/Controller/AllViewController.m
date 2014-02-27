//
//  AllViewController.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "AllViewController.h"
#import "JsDevice.h"
#import "AllCell.h"
#import "SVPullToRefresh.h"
#import "AppDelegate.h"
#import "factory.h"
#import "BlockUI.h"

#import "DDMenuController.h"

#define CELL_HEIGHT 200



@interface AllViewController ()

@end

@implementation AllViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
        
    }
    return self;
}

-(void)createDropDwonMenu{
    btn = [factory createButtonFrame:CGRectMake(0, 0, 100, 44) Title:@"全部消息" Target:self Action:@selector(btnClicked) Tag:1];
    btn.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = btn;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    IOS7;
    [self showTitle:@"全部消息"];
    
    [self showLeftButtonWithImageName:@"按钮1.png" target:self action:@selector(leftBtnPress)];
    [self showRightButtonWithImageName:@"按钮2.png" target:self action:@selector(rightBtnPress)];
    
    _arrData = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-20-44) style:UITableViewStylePlain];
    NSLog(@"%f %f",kScreenHeight,kScreenWidth);
    NSLog(@"%f",_tableView.frame.origin.y);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    [self createDropDwonMenu];
    
    
    __weak AllViewController *weakSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.tableView.pullToRefreshView setTitle:@"正在加载中..." forState:SVPullToRefreshStateLoading];
        [weakSelf.tableView.pullToRefreshView setTitle:@"释放立即刷新" forState:SVPullToRefreshStateTriggered];
        [weakSelf.tableView.pullToRefreshView setTitle:@"往下拉来刷新" forState:SVPullToRefreshStateStopped];
        
        [weakSelf loadDataSource];
    }];
    
    
    //上拉加载更多
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        [weakSelf loadMoreData];
    }];

	// Do any additional setup after loading the view.
}

-(void)loadDataSource{
    __weak AllViewController *weakSelf = self;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSString *subTitle = [NSString stringWithFormat:@"上次更新%@",str];
        [weakSelf.tableView.pullToRefreshView setSubtitle:subTitle forState:SVPullToRefreshStateAll];

        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}
-(void)loadMoreData{
    __weak AllViewController *weakSelf = self;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
         [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_arrData.count == 0) {
        return 10;
    }
    return _arrData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"cellId";
    if (tableView != _tableView) {
        return nil;
    }
    AllCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AllCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

#pragma mark - button action
-(void)leftBtnPress{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
    
}

-(void)rightBtnPress{
    
}

-(void)btnClicked{

}

#pragma mark - UITableViewDelegate method
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

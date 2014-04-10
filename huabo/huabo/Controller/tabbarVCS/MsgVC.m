//
//  AtMeViewController.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "MsgVC.h"
#import "MsgCell.h"
#import "clickableUIView.h"
#import "ReplyVC.h"
#import "AllGroupVC.h"
#import "SysMsgVC.h"

@interface MsgVC ()

@end

@implementation MsgVC

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
    self.view.backgroundColor = [UIColor yellowColor];
    [self showTitle:@"消息"];
    
    self.tableView.tableHeaderView = self.tHeaderBGView;
    _reply = (clickableUIView *)[self.tHeaderBGView viewWithTag:100];
    _group = (clickableUIView *)[self.tHeaderBGView viewWithTag:101];
    _sysMsg = (clickableUIView *)[self.tHeaderBGView viewWithTag:102];
    
    [_reply handleComplemetionBlock:^(clickableUIView *view1) {
        ReplyVC *rep = [[ReplyVC alloc]init];
        [self.navigationController pushViewController:rep animated:YES];
    }];
    
    [_group handleComplemetionBlock:^(clickableUIView *view2) {
        AllGroupVC *allgroup = [[AllGroupVC alloc]init];
        [self.navigationController pushViewController:allgroup animated:YES];
    }];
    
    [_sysMsg handleComplemetionBlock:^(clickableUIView *view3) {
        SysMsgVC *sys = [[SysMsgVC alloc]init];
        [self.navigationController pushViewController:sys animated:YES];
    }];
  
	// Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[MsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

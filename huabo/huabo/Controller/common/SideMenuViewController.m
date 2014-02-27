//
//  SideMenuViewController.m
//  huabo
//
//  Created by admin on 14-2-26.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "SideMenuViewController.h"
#import "JsDevice.h"
#import "factory.h"
#import "SideMenuCell.h"

#define TOP_GAP 8
#define LEFT_GAP 8

#define BGVIEW_HEIGHT 60
#define BGVIEW_WIDTH 280

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)createHeaderView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BGVIEW_WIDTH, BGVIEW_HEIGHT)];
    bgView.backgroundColor = [UIColor darkGrayColor];
    
    _headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_GAP, TOP_GAP, 40, 40)];
    _headIcon.backgroundColor = [UIColor redColor];
    [bgView addSubview:_headIcon];
    
    _labelName = [factory createLabelFrame:CGRectMake(_headIcon.frame.origin.x+_headIcon.frame.size.width+15, BGVIEW_HEIGHT/2-10, 100, 15) Text:@"二哥"];
    _labelName.font = BoldFont(14);
    _labelName.textColor = [UIColor redColor];
    [bgView addSubview:_labelName];
    _tableView.tableHeaderView = bgView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrData = @[@"个人中心",@"消息中心",@"事务中心",@"通讯录"];
    self.view.backgroundColor = [UIColor blackColor];
    //IOS7;
    _tableView = [[UITableView alloc]initWithFrame:CGRECT_NO_NAV(0, 0, kScreenWidth-40, kScreenHeight) style:UITableViewStylePlain];
    NSLog(@"%f %f",kScreenHeight,kScreenWidth);
    NSLog(@"%f",_tableView.frame.origin.y);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self createHeaderView];
	// Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cellid";
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[SideMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.text = [_arrData objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
#import "UserMgr.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+MakeAViewRoundCorner.h"
#import "Const.h"
#import "jsHttpHandler.h"
#import "PersonalVC.h"
#import "clickableUIView.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "JsDevice.h"
#import "TrendsVC.h"
#import "MyGroupVC.h"

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
        [self _getUserProfile];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sideMenuBG.png"]];
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}

-(void)createHeaderView{
    
    
    
    clickableUIView *bgView = [[clickableUIView alloc]initWithFrame:CGRectMake(0, 0, BGVIEW_WIDTH, BGVIEW_HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sideMenuBG.png"]];
    
    _headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_GAP, TOP_GAP, 40, 40)];
   // _headIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sideMenuBG.png"]];
    [_headIcon setRoundedCornerWithRadius:6.0f];
   
    [bgView addSubview:_headIcon];
    
    [bgView handleComplemetionBlock:^(clickableUIView *v) {
        
        PersonalVC *p =  [[PersonalVC alloc]init];
        UIViewController *vc = [self _getMianController];
        //这时应该把信息都下来了
         UserModel *model = [[UserMgr sharedInstance]readFromDisk];
        p.uModel = model;
        DDMenuController *dd = [self _getDDMenuController];
        [dd showRootController:YES];
        [vc.navigationController pushViewController:p animated:YES];
    }];
   
    
    _labelName = [factory createLabelFrame:CGRectMake(_headIcon.frame.origin.x+_headIcon.frame.size.width+15, BGVIEW_HEIGHT/2-10, 100, 15) Text:@""];
    _labelName.font = BoldFont(16);
    _labelName.textColor = [UIColor whiteColor];
    [bgView addSubview:_labelName];
    _tableView.tableHeaderView = bgView;
}

- (DDMenuController*)_getDDMenuController{
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *del = app.delegate;
    UIWindow *win = del.window;
    DDMenuController *vc =(DDMenuController*) win.rootViewController;
    return vc;
}

- (UIViewController *)_getMianController{
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *del = app.delegate;
    UIWindow *win = del.window;
    DDMenuController *vc =(DDMenuController*) win.rootViewController;
    UITabBarController *tab = (UITabBarController*)vc.rootViewController;
  //  UINavigationController *nav = [tab.viewControllers objectAtIndex:0];
    UINavigationController *nav = [tab.viewControllers objectAtIndex:tab.selectedIndex];
    return [nav topViewController];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UserModel *model = [[UserMgr sharedInstance]readFromDisk];
    [_headIcon setImageWithURL:[NSURL URLWithString:model.HeadSculpture24] placeholderImage:[UIImage imageNamed:@"weibolist_pic.png"]];
    _labelName.text = model.RealName;
   // NSLog(@"model %@",model.RealName);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrData = @[@"动态",@"消息",@"群组",@"通讯录",@"新闻公告",@"任务中心",@"日程中心"];
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
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1) {
        //动态
        [self _showTabBarVCWithIndex:indexPath.row];
    }
    
    if (indexPath.row == 2) {
        //群组
        UIViewController *vc = [self _getMianController];
        MyGroupVC *mvc = [[MyGroupVC alloc]init];
        DDMenuController *dd = [self _getDDMenuController];
        [dd showRootController:YES];
        [vc.navigationController pushViewController:mvc animated:YES];
    }
    if (indexPath.row == 3) {
        //通讯录
        [self _showTabBarVCWithIndex:2];
    }
    if (indexPath.row == 4) {
        //新闻公告
    }
    if (indexPath.row == 5) {
        //任务中心
    }
    if(indexPath.row == 6){
        //日程中心
    }
}

- (void)_showTabBarVCWithIndex:(NSInteger)index{
    DDMenuController *dd = [self _getDDMenuController];
    [dd showRootController:YES];
    UITabBarController *tab = (UITabBarController *)dd.rootViewController;
    tab.selectedIndex = index;
}

- (void)_getUserProfile{
    if (![JsDevice netOK]) {
        NSLog(@"无网络连接，不获取个人资料");
        return;
    }
    UserModel *model = [[UserMgr sharedInstance]readFromDisk];
    NSString *str = [NSString stringWithFormat:kUserInfoUrl,model.ID,model.Token];
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:NO completionBlock:^(id JSON) {
        if (JSON == nil) return ;
        //NSLog(@"%@",JSON);
        model.CompanyEmail = [JSON objectForKey:@"CompanyEmail"];
        model.CompanyName = [JSON objectForKey:@"CompanyName"];
        model.DepartmentName = [JSON objectForKey:@"DepartmentName"];
        model.FollowCount = [[JSON objectForKey:@"FollowCount"]integerValue];
        model.HeadSculpture = [JSON objectForKey:@"HeadSculpture"];
        model.HeadSculpture100 = [JSON objectForKey:@"HeadSculpture100"];
        model.HeadSculpture24 = [JSON objectForKey:@"HeadSculpture24"];
        model.HeadSculpture48 = [JSON objectForKey:@"HeadSculpture48"];
        
        model.Integral = [[JSON objectForKey:@"Integral"] integerValue];
        model.IsCurrentUser = [[JSON objectForKey:@"IsCurrentUser"] integerValue];
        model.IsFollowed = [[JSON objectForKey:@"IsFollowed"] integerValue];
        model.JobName = [JSON objectForKey:@"JobName"];
        model.JobNumber = [JSON objectForKey:@"JobNumber"];
        model.Level = [[JSON objectForKey:@"Level"] integerValue];
        model.LevelName = [JSON objectForKey:@"LevelName"];
        model.ListenerCount = [[JSON objectForKey:@"ListenerCount"] integerValue];
        model.QQ = [JSON objectForKey:@"QQ"];
        model.RealName = [JSON objectForKey:@"RealName"];
        NSLog(@"model %@",model.RealName);
        model.TelPhone = [JSON objectForKey:@"TelPhone"];
        model.VisitedCount = [[JSON objectForKey:@"VisitedCount"] integerValue];
        //
        model.SinaWeiBo = [JSON objectForKey:@"SinaWeiBo"];
        model.TencentWeiBo = [JSON objectForKey:@"TencentWeiBo"];
        model.WeiXin = [JSON objectForKey:@"WeiXin"];
         [[UserMgr sharedInstance] setLoginUser:model];
    }];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

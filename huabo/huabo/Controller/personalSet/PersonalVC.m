//
//  PsersonalVC.m
//  huabo
//
//  Created by admin on 14-3-4.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "PersonalVC.h"
#import "EditProfileVC.h"
#import "UIImageView+WebCache.h"
#import "UIView+MakeAViewRoundCorner.h"
#import "jsHttpHandler.h"
#import "Const.h"
#import "UserModel.h"
#import "UserMgr.h"

@interface PersonalVC ()

@end

@implementation PersonalVC

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
    if (_uModel) {
        [self _fill];
    }
   
}

- (void)_fill{
    [_headImage setRoundedCornerWithRadius:5.0f];
    [_headImage setImageWithURL:[NSURL URLWithString:_uModel.HeadSculpture48] placeholderImage:nil];
    _name.text = _uModel.RealName;
    _depart.text = _uModel.DepartmentName;
    _job.text = _uModel.JobName;
    _level.text = [NSString stringWithFormat:@"%d(%@)",_uModel.Level,_uModel.LevelName];
    _score.text = [NSString stringWithFormat:@"%d",_uModel.Integral ];
    _company.text = _uModel.CompanyName;
    if ([_uModel.JobNumber isKindOfClass:[NSNull class]]) {
        _jobNum.text = @"暂无数据";
    }else{
        _jobNum.text = _uModel.JobNumber;
    }
    if ( [_uModel.TelPhone isKindOfClass:[NSNull class]]  ) {//对于[NSNull length]会奔溃
        _telNum.text = @"暂无数据";
    }else{
        _telNum.text = _uModel.TelPhone;
    }
    
    self.follow.titleLabel.text = [NSString stringWithFormat:@"%d",_uModel.FollowCount];
    self.fans.titleLabel.text = [NSString stringWithFormat:@"%d",_uModel.ListenerCount];
    
    if (_uModel.IsCurrentUser || _uModel.IsMy) {
       [self showRightButtonWithImageName:@"个人设置编辑.png" target:self action:@selector(pressEdit)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack)];
   
    
    if (_userId) {
        [self _loadUserInfo:_userId];
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)_loadUserInfo:(NSInteger)userId{
    UserModel *m = [[UserMgr sharedInstance] readFromDisk];
    NSString *str = [NSString stringWithFormat:kUserInfoUrl,userId,m.Token];
    NSLog(@"++= %@",str);
    [jsHttpHandler jsHttpDownloadWithStrOfUrl:str withCache:YES completionBlock:^(id JSON) {
        if (JSON == nil) return ;
        //NSLog(@"%@",JSON);
        UserModel *model = [[UserModel alloc]init];
        model.CompanyEmail = [JSON objectForKey:@"CompanyEmail"];
        model.CompanyName = [JSON objectForKey:@"CompanyName"];
        model.DepartmentName = [JSON objectForKey:@"DepartmentName"];
        model.FollowCount = [[JSON objectForKey:@"FollowCount"]intValue];
        model.HeadSculpture = [JSON objectForKey:@"HeadSculpture"];
        model.HeadSculpture100 = [JSON objectForKey:@"HeadSculpture100"];
        model.HeadSculpture24 = [JSON objectForKey:@"HeadSculpture24"];
        model.HeadSculpture48 = [JSON objectForKey:@"HeadSculpture48"];
        
        model.Integral = [[JSON objectForKey:@"Integral"] intValue];
        model.IsCurrentUser = [[JSON objectForKey:@"IsCurrentUser"] intValue];
        model.IsFollowed = [[JSON objectForKey:@"IsFollowed"] intValue];
        model.JobName = [JSON objectForKey:@"JobName"];
        model.JobNumber = [JSON objectForKey:@"JobNumber"];
        model.Level = [[JSON objectForKey:@"Level"] intValue];
        model.LevelName = [JSON objectForKey:@"LevelName"];
        model.ListenerCount = [[JSON objectForKey:@"ListenerCount"] intValue];
        model.QQ = [JSON objectForKey:@"QQ"];
        model.RealName = [JSON objectForKey:@"RealName"];
        NSLog(@"model %@",model.RealName);
        model.TelPhone = [JSON objectForKey:@"TelPhone"];
        model.VisitedCount = [[JSON objectForKey:@"VisitedCount"] intValue];
        //
        model.SinaWeiBo = [JSON objectForKey:@"SinaWeiBo"];
        model.TencentWeiBo = [JSON objectForKey:@"TencentWeiBo"];
        model.WeiXin = [JSON objectForKey:@"WeiXin"];
        
        _uModel = model;
        [self _fill];
    }];
    [jsHttpHandler setCacheTime:60*60];//1hour
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressEdit{
    EditProfileVC *edit = [[EditProfileVC alloc ]init];
    edit.model = _uModel;
    [self.navigationController pushViewController:edit animated:YES];
}

- (IBAction)btnEditAction:(UIButton *)sender {
}
- (IBAction)followAction:(UIButton *)sender {
}
- (IBAction)fansAction:(UIButton *)sender {
}
- (IBAction)myWeiboAction:(UIButton *)sender {
}
- (IBAction)myCollectionAction:(UIButton *)sender {
}
@end

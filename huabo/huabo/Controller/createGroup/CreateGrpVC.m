//
//  CreateGrpVC.m
//  huabo
//
//  Created by admin on 14-4-15.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "CreateGrpVC.h"
#import "jsHttpHandler.h"
#import "UserModel.h"
#import "UserMgr.h"
#import "Const.h"
#import "AtUsersVC.h"
#import "GrpTypeVC.h"
#import "JsDevice.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface CreateGrpVC ()

@end

@implementation CreateGrpVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.grpName resignFirstResponder];
    [self.briefIntroTView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showTitle:@"新建群组"];
    [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack)];
    [self showRightButtonOfSureWithName:@"保存" target:self action:@selector(clickRightBtn)];
    
    _grpName.text = @"";
    _briefIntroTView.text = @"";
    //default
    _groupType = 1;//列入
    
    [self.inviteFriend handleComplemetionBlock:^(clickableUIView *view) {
        AtUsersVC *atvc = [[AtUsersVC alloc]init];
        atvc.title = @"选择参与人";
        atvc.block = ^(NSArray *array){
            if (!array && !array.count) {
                _inviteArray = [NSMutableArray arrayWithArray:array];
            }else{
                _inviteArray = nil;
            }
        } ;
        [self.navigationController pushViewController:atvc animated:YES];
    }];
    
    [self.grpType handleComplemetionBlock:^(clickableUIView *view) {
        GrpTypeVC *gvc = [[GrpTypeVC alloc]init];
        gvc.block = ^(int n){
            _groupType = n;
        };
        [self.navigationController pushViewController:gvc animated:YES];
    }];
   
}

- (void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn{
    
    if ( _grpName.text.length == 0) {
        [self _showHUDWithString:@"群组名不能为空"];
        return;
    }
    
    if (_grpName.text.length > 64) {
        [self _showHUDWithString:@"群组名不能超过64个字符!"];
        return;
    }
    
    if (_briefIntroTView.text.length >= 256) {
        [self _showHUDWithString:@"群简介字数太多!"];
        return;
    }
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_grpName.text forKey:@"groupName"];
    if (_briefIntroTView.text.length != 0) {
        [dic setObject:_briefIntroTView.text forKey:@"groupSummary"];
    }
    [dic setObject:[NSNumber numberWithInt:_groupType] forKey:@"groupType"];
    UserModel *m = [[UserMgr sharedInstance] readFromDisk];
    [dic setObject:m.Token forKey:@"token"];
//    NSLog(@"url %@",kCreateGrp);
    [jsHttpHandler JsHttpPostWithStrOfUrl:kCreateGrp paraDict:dic completionBlock:^(id JSON) {
        if (!JSON) {
            [self _showHUDWithString:@"服务器无响应"];
            return ;
        }
        if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]) {
            [self _showHUDWithString:[NSString stringWithFormat:@"恭喜，创建群组 %@ 成功！",_grpName.text]];
            _grpName.text = @"";
            _briefIntroTView.text = @"";
        }else{
            [self _showHUDWithString:@"创建群组失败"];
        }
    }];
    
}

- (void)_showHUDWithString:(NSString *)str{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    if (hud == nil) {
        hud = [[MBProgressHUD alloc]initWithWindow:del.window ];
    }
   
    hud.mode = MBProgressHUDModeText;
    [del.window addSubview:hud];
    hud.labelText = str;
    [hud show:YES];
    [hud hide:YES afterDelay:1.0f];
}

- (void)dealloc{
    hud = nil;
}

@end

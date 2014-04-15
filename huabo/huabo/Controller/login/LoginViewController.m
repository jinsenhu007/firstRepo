//
//  LoginViewController.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "LoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "jsHttpHandler.h"
#import "Const.h"
#import "UserModel.h"
#import "MLTableAlert.h"
 #import "TSMessageView.h"
#import "JsDevice.h"
#import "WTStatusBar.h"
#import "UserMgr.h"
#import "MMProgressHUD.h"

#define kAuToLogin @"isAutoLogin"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.tUser resignFirstResponder];
    [self.tPwd resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    IOS7;
   // self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.scrollView contentSizeToFit];
      [self _getLoginUser];
   // UITextField
    
    _check1 = [[QCheckBox alloc] initWithDelegate:self];
    _check1.frame = CGRectMake(199, 392, 80, 20);
    [_check1 setTitle:@"自动登录" forState:UIControlStateNormal];
    [_check1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.scrollView addSubview:_check1];
    [_check1 setChecked:YES];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kAuToLogin];
    if (isLogin) {
        [self bLoginClick:nil];
    }
}

- (IBAction)bRegClick:(UIButton *)sender {
    
}
- (IBAction)bLoginClick:(UIButton *)sender {
    if (![JsDevice netOK]) {
        return;
    }
  
    if (self.tUser.text != nil && ![_tUser.text isEqualToString:@""] && _tPwd.text != nil && ![_tPwd.text isEqualToString:@""])
    {
        [sender setEnabled:NO];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_tUser.text,kLoginCode,_tPwd.text,kLoginPwd, nil];
        [WTStatusBar setLoading:YES loadAnimated:YES];
//        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//        [MMProgressHUD showWithTitle:@"请稍后" status:@"正在登录"];
        [jsHttpHandler JsHttpPostWithStrOfUrl:kLoginUrl paraDict:dict completionBlock:^(id JSON) {
           // NSLog(@"%@",JSON);
            NSString *str = [JSON objectForKey:@"Status"];
            if ([str isEqualToString:@"ok"]) {
                
                NSLog(@"登录成功");
                _uModel = [[UserModel alloc]init];
               
                _uModel.LoginEmail = _tUser.text;
                _uModel.LoginPwd = _tPwd.text;
                NSLog(@"name %@ pass %@",_uModel.LoginEmail,_uModel.LoginPwd);
                
                NSDictionary *dict = [NSDictionary dictionaryWithObject:[JSON objectForKey:@"AccountID"] forKey:kAccountID];
                
               // [MMProgressHUD updateStatus:@"登录成功!"];
                //刷新当前账号用户访问令牌
              [jsHttpHandler JsHttpPostWithStrOfUrl:kUpdateTokenUrl paraDict:dict completionBlock:^(id JSON) {
                 // NSLog(@"JSON %@",JSON);
                  if (JSON == nil || [[JSON objectForKey:@"Status"] isEqualToString:@"fail"]) {
                      
                  }
                  
                  if ([[JSON objectForKey:@"Status"] isEqualToString:@"ok"]){
                      //获取用户所在所有网络信息
                      [jsHttpHandler JsHttpPostWithStrOfUrl:kUserNetworkUrl paraDict:dict completionBlock:^(id JSON) {
                          NSLog(@"%@",JSON);
                          NSArray *arr = [JSON objectForKey:@"Rows"];
                          
                          //弹出视图，选择加入的网络
                          _tAlert = [MLTableAlert tableAlertWithTitle:@"请选择网络" cancelButtonTitle:@"取消登录" numberOfRows:^NSInteger(NSInteger section) {
                              return arr.count;
                          } andCells:^UITableViewCell *(MLTableAlert *alert, NSIndexPath *indexPath) {
                              static NSString *CellIdentifier = @"CellIdentifier";
                              UITableViewCell *cell = [_tAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                              if (cell == nil)
                                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                              
                             // cell.textLabel.text = [NSString stringWithFormat:@"Section %d Row %d", indexPath.section, indexPath.row];
                              NSDictionary *dic = [arr objectAtIndex:indexPath.row];
                              cell.textLabel.text = [dic objectForKey:@"NetworkName"];
                              
                              return cell;
                          }];
                          
                          _tAlert.height = 80;
                          //选择了某一个cell
                          [_tAlert configureSelectionBlock:^(NSIndexPath *selectedIndex) {
                              NSLog(@"selectedIndex %ld",(long)selectedIndex.row);
                              //根据选择的网络获取用户token等信息
                               NSDictionary *dic = [arr objectAtIndex:selectedIndex.row];
                              _uModel.Token = [dic objectForKey:@"Token"];
                              _uModel.NetworkID = [[dic objectForKey:@"NetworkID"]intValue];
                              _uModel.NetworkName = [dic objectForKey:@"NetworkName"];
                              _uModel.UserNetworkType = [[dic objectForKey:@"UserNetworkType"] intValue];
                              _uModel.UserNetworkRole = [[dic objectForKey:@"UserNetworkRole"]intValue];
                              _uModel.ID = [[dic objectForKey:@"UserID"] integerValue];
                              //选中了 用一个bool值表示下次是否需要自动登录
                              if (_check1.checked) {
                                //
                                  [[ NSUserDefaults standardUserDefaults] setBool:YES forKey:kAuToLogin];
                              }else{
                                  [[ NSUserDefaults standardUserDefaults] setBool:NO forKey:kAuToLogin];
                              }
                               [[UserMgr sharedInstance]setLoginUser:_uModel];
                              //发送通知，登录成功
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"LS" object:nil];
                              
                              [WTStatusBar clearStatusAnimated:YES];
                          } andCompletionBlock:^{
                              //点击了取消登录
                              [sender setEnabled:YES];
                          }];
                          [_tAlert show];
                          
                      }];
                  }
              }];
            }
            else{
                //登录出错
                NSLog(@"登录出错");
                [WTStatusBar clearStatusAnimated:YES];
                
                [sender setEnabled:YES];
            }
        }];
    }
}

- (void)_getLoginUser{
   UserModel *model =  [[UserMgr sharedInstance]readFromDisk];
    _tUser.text = model.LoginEmail;
    _tPwd.text = model.LoginPwd;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)dealloc{
    _tAlert = nil;
    
}
@end

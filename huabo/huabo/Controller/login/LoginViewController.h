//
//  LoginViewController.h
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "QCheckBox.h"
@class UserModel;
@class MLTableAlert;
@class TPKeyboardAvoidingScrollView;
@class TSMessageView;

@interface LoginViewController : BaseViewController<UITextFieldDelegate>
{
    UserModel *_uModel;
    MLTableAlert *_tAlert;
    
    QCheckBox *_check1;
}
@property (strong, nonatomic) IBOutlet UITextField *tUser;
@property (strong, nonatomic) IBOutlet UITextField *tPwd;
@property (strong, nonatomic) IBOutlet UIButton *bReg;
- (IBAction)bRegClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *bLogin;
- (IBAction)bLoginClick:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;



@end

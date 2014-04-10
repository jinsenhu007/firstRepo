//
//  EditProfileVC.h
//  huabo
//
//  Created by admin on 14-3-20.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class UserModel;
@class clickableUIView;

@interface EditProfileVC : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet clickableUIView *changeHeadIcon;

@property (strong, nonatomic) IBOutlet UITextField *tUserName;
@property (strong, nonatomic) IBOutlet UITextField *tPwd;
@property (strong, nonatomic) IBOutlet UITextField *tEmail;
@property (strong, nonatomic) IBOutlet UITextField *tTelPhone;

@property (retain,nonatomic) UserModel *model;
@end

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
    // Do any additional setup after loading the view from its nib.
}

- (void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn{
    
}

@end

//
//  CreateGrpVC.h
//  huabo
//
//  Created by admin on 14-4-15.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "clickableUIView.h"
@class MBProgressHUD;
@interface CreateGrpVC : BaseViewController
{
    int _groupType;
    MBProgressHUD *hud;
}
@property (strong, nonatomic) IBOutlet UITextField *grpName;
@property (strong, nonatomic) IBOutlet UITextView *briefIntroTView;
@property (strong, nonatomic) IBOutlet clickableUIView *grpType;
@property (strong, nonatomic) IBOutlet clickableUIView *inviteFriend;

@property (retain,nonatomic) NSMutableArray *inviteArray;
@end

//
//  SendToMeViewController.h
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"

@interface SetVC : BaseViewController
@property (strong, nonatomic) IBOutlet UIButton *commonSet;
- (IBAction)commonSetAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *suggest;
- (IBAction)suggestAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *about;
- (IBAction)aboutAction:(UIButton *)sender;


@end

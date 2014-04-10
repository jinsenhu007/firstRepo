//
//  SendToMeViewController.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "SetVC.h"
#import "commSetVC.h"

@interface SetVC ()

@end

@implementation SetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showTitle:@"设置"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commonSetAction:(UIButton *)sender {
    commSetVC *CSV = [[commSetVC alloc]init];
    [self.navigationController pushViewController:CSV animated:YES];
}
- (IBAction)suggestAction:(UIButton *)sender {
}
- (IBAction)aboutAction:(UIButton *)sender {
}
@end

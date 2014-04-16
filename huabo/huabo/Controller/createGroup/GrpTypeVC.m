//
//  GrpTypeVC.m
//  huabo
//
//  Created by admin on 14-4-16.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "GrpTypeVC.h"
#import "JsDevice.h"

@interface GrpTypeVC ()

@end

@implementation GrpTypeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //IOS7;
    _first = [[QCheckBox alloc]initWithDelegate:self];
    _first.frame = CGRectMake(55,111 , 30, 20);
    _first.checked = YES;
    [self.view addSubview:_first];
    
    _private = [[RadioButton alloc]initWithGroupId:@"myGroup" index:1];
    _private.frame = CGRectMake(25, 80, kScreenWidth-50, 20);
    [_private setChecked:YES];
    [self.view addSubview:_private];
    
    _groupType = 1; 
    
    _public = [[RadioButton alloc]initWithGroupId:@"myGroup" index:4];
    _public.frame = CGRectMake(25, 152, 30, 20);
    [self.view addSubview:_public];
    
     [RadioButton addObserverForGroupId:@"myGroup" observer:self];
    
    [self showLeftButtonWithImageName:@"返回.png" target:self action:@selector(pressBack)];
    [self showRightButtonOfSureWithName:@"保存" target:self action:@selector(clickRightBtn)];
    
    
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    _first.checked = checked;
    if (_first.checked) {
        _groupType = 1;
    }else{
        _groupType = 2;
    }
}

- (void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn{
    if (_block) {
        _block(_groupType);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    NSLog(@"changed to %d in %@",index,groupId);
    if (index == 1) {
        _first.enabled = YES;
       
        if (_first.checked) {
            _groupType = 1; //列入
        }else{
             _groupType = 2; //不列入
        }
    }else if (index == 4){
        _first.checked = NO;
        _first.enabled = NO;
        _groupType = 4;
    }

}



@end

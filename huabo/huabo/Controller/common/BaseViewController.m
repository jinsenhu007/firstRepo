//
//  BaseViewController.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "BaseViewController.h"
#import "clickableUIView.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) showTitle:(NSString *)s {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = s;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    //label.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.7 alpha:1];
    label.textColor = [UIColor blackColor];
    self.navigationItem.titleView = label;
    
}



-(void)showLeftButtonWithImageName:(NSString *)name target:(id)target action:(SEL)sel{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 30);
    btn.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = btnItem;
}

-(void)showRightButtonWithImageName:(NSString*)name target:(id)target action:(SEL)sel{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 30);
    btn.showsTouchWhenHighlighted = YES;

    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;

}

-(void)showLeftButton:(NSString*)str target:(id)target action:(SEL)sel{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"buttonbar_action.png"] forState:UIControlStateNormal];
    //  [button setTitle:str forState:UIControlStateNormal];
    
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 50, 30);
    
    //button上放置文字label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 3,button.bounds.size.width, 25)];
    label.text = str;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = btnItem;
}

-(void)showRightButton:(NSString *)str target:(id)target action:(SEL)sel{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 30);
    [button setImage:[UIImage imageNamed:@"buttonbar_action.png"] forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    //
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 3,button.bounds.size.width, 25)];
    label.text = str;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:75 green:188 blue:241 alpha:0.8];
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btn;
}

-(void)showBackButton:(NSString*)str withImage:(UIImage *)image target:(id)target action:(SEL)sel{
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height);
    label.text = @"返回";
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [btn addSubview:label];
    
    
    
    //   [btn addSubview:iView];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc  ]initWithCustomView:btn];
    
    
    //UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:str style:UIBarButtonItemStylePlain target:target action:sel];
    
    //  [barBtnItem setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = barBtn;
}


-(void)showBackBtnTitle:(NSString *)name target:(id)target action:(SEL)sel{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
       btn.frame = CGRectMake(0, 0, 45, 40);
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = btItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)showRightButtonOfSureWithName:(NSString*)name target:(id)target action:(SEL)sel{
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithTitle:name style:UIBarButtonItemStylePlain target:target action:sel];

    self.navigationItem.rightBarButtonItem = btnItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

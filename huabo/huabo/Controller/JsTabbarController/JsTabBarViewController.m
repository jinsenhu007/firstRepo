//
//  JsTabBarViewController.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "JsTabBarViewController.h"
#import "JsDevice.h"

@interface JsTabBarViewController ()

@end

@implementation JsTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
        self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbarItem_press.png"];
    
	// Do any additional setup after loading the view.
}

-(void)setViewControllers:(NSArray *)viewControllers{
    NSMutableArray *arr = [NSMutableArray array];
    int tag = 1;
    for (NSDictionary *dict  in viewControllers) {
        UIViewController *c = [dict objectForKey:kController];
        [arr addObject:c];
        NSString *title = [dict objectForKey:kTitle];
        NSString *imageName = [dict objectForKey:kImageName];
        
        UIImage *img = nil;
        //如果有图片
        if (imageName != nil) {
            img = [UIImage imageNamed:imageName];
        }
       // UIImage *imag = [UIImage imageNamed:imageName];
        UIColor *color = [[UIColor alloc]initWithRed:0.54 green:0.048 blue:0.3 alpha:1];
        UIColor *colorSelect = [UIColor whiteColor];
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title image:img tag:tag++];
        [item setTitlePositionAdjustment:UIOffsetMake(0, -15)];
        [item setTitleTextAttributes:@{UITextAttributeTextColor: color} forState:UIControlStateNormal];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorSelect,UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SysFont(13),UITextAttributeFont, nil] forState:UIControlStateNormal];
        c.tabBarItem = item;
    }
    [super setViewControllers:arr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

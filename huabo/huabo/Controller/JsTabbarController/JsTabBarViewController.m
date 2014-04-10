//
//  JsTabBarViewController.m
//  huabo
//
//  Created by admin on 14-2-25.
//  Copyright (c) 2014年 华博创意. All rights reserved.
//

#import "JsTabBarViewController.h"
#import "JsDevice.h"
#import "TSMessageView.h"
#import "Reachability.h"

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
  // [TSMessage setDefaultViewController:self];
    self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"下按钮选中.png"];
    
//    Reachability *reach = [JsDevice sharedReach];

    Reachability *reach = [JsDevice sharedReach];
    
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                    name:kReachabilityChangedNotification
                                                   object:nil];
    
//    reach.reachableBlock = ^(Reachability *reachability){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [TSMessage showNotificationWithTitle:@"网络恢复" type:TSMessageNotificationTypeMessage];
//        });
//        
//    };
//    
//    reach.unreachableBlock = ^(Reachability *reachability){
//        dispatch_queue_t myQueue =  dispatch_get_main_queue();
//       
//        dispatch_async(myQueue, ^{
//            [TSMessage showNotificationWithTitle:@"网络断开" type:TSMessageNotificationTypeMessage];
//            [TSMessage iOS7StyleEnabled];
//        });
//      
//    };
    
    [reach startNotifier];
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
        UIColor *color = [UIColor blackColor];
        UIColor *colorSelect = [UIColor colorWithRed:23 green:99 blue:151 alpha:1];
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title image:img tag:tag++];
        
       // [item setTitlePositionAdjustment:UIOffsetMake(0, -15)];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName: color} forState:UIControlStateNormal];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorSelect,UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SysFont(13),UITextAttributeFont, nil] forState:UIControlStateNormal];
        c.tabBarItem = item;
    }
    [super setViewControllers:arr];
}


-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    NetworkStatus status = [reach currentReachabilityStatus];
    if(status == NotReachable)
    {
         [TSMessage showNotificationWithTitle:@"网络断开" type:TSMessageNotificationTypeMessage];
    }
    else
    {
        // [TSMessage showNotificationWithTitle:@"" type:TSMessageNotificationTypeMessage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
